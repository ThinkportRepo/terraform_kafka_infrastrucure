#!/bin/bash
yum install -y jq

sum_ip () {
  IFS='.' read -a arr <<< "$1"
  sum=0
  for ((i=0; i<$${#arr[@]}; i++)); do
   sum=$(($sum + $${arr[i]}))
  done
  echo "$sum"
}

MY_INST_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
MY_INST_AZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
MY_IP=$(hostname -i)

MY_ASG_NAME="kafka_autoscaling_group"
TAG="kafka-eni"

instances=$(aws autoscaling --region ${region} describe-auto-scaling-groups --auto-scaling-group-name kafka_autoscaling_group)

enis=$(aws ec2 describe-network-interfaces --region ${region} --filter Name=tag-value,Values=$TAG)

volumes=$(aws ec2 describe-volumes --region ${region}  --filters Name=tag-value,Values=kafka-ebs-volumes-*)

ip_json=$(echo $enis | jq -rc '.NetworkInterfaces[].PrivateIpAddresses[].PrivateIpAddress' )

sorted_array_ips=()

for ip in $(echo $enis | jq -rc '.NetworkInterfaces[].PrivateIpAddresses[].PrivateIpAddress'); do
   sorted_array_ips+=("$ip")
done

array_length=$${#sorted_array_ips[@]}

for ((i=$((array_length-1)); i>0; i--)); do
  for ((j=0; j<i; j++)); do
    sum_ip_current=$(sum_ip $${sorted_array_ips[$j]})
    sum_ip_next=$(sum_ip $${sorted_array_ips[$((j+1))]})
    if (( sum_ip_current > sum_ip_next )); then
      temp=$${sorted_array_ips[$j]}
      sorted_array_ips[$j]=$${sorted_array_ips[$((j+1))]}
      sorted_array_ips[$((j+1))]=$temp
    fi
  done
done

for ip in "$${sorted_array_ips[@]}"; do
   echo $ip >> /temp/sorted_ips
done

ZOOKEEPER_NODES=""
ZOOKEEPER_CONNECT=""
COUNTER=1
SERVER_I=0
ENI_ASSIGNED=0
ENI_ASSIGNATION_FAILED=1

while [ $ENI_ASSIGNATION_FAILED == 1 ]; do
 for eni in $(echo $enis | jq -rc '.NetworkInterfaces[]'); do
  INST_ID=$(echo $eni | jq -r '.Attachment[].InstanceId')
  IP=$(echo $eni | jq -r '.PrivateIpAddresses[].PrivateIpAddress')
  ENI_ID=$(echo $eni | jq -r '.NetworkInterfaceId')
  ENI_AZ=$(echo $eni | jq -r '.AvailabilityZone')


  if [[ $INST_ID  == '' ]] && [[ $MY_INST_AZ == $ENI_AZ ]] && [[ $ENI_ASSIGNED == 0 ]]; then
    ENI_ASSIGNATION_FAILED=0
    aws ec2 attach-network-interface --region ${region} --device-index 1  --instance-id $MY_INST_ID --network-interface-id $ENI_ID &> /tmp/error_out_$COUNTER.txt || ENI_ASSIGNATION_FAILED=1
    if [[ $ENI_ASSIGNATION_FAILED == 0 ]]; then

      TG_ARN=$(aws elbv2 describe-target-groups --names kafka-lb-tg --region ${region} | jq -rc '.TargetGroups[].TargetGroupArn')
      aws elbv2 register-targets --target-group-arn $TG_ARN --targets Id=$IP --region ${region}

      ENI_ASSIGNED=1
      SERVER_I=$(($(echo $${sorted_array_ips[@]/$IP//} | cut -d/ -f1 | wc -w | tr -d ' ')+1))
      echo "listeners=SSL://$IP:9092" >> /etc/kafka/server.properties
      echo "advertised.listeners=SSL://$IP:9092" >> /etc/kafka/server.properties
      echo "broker.rack=$ENI_AZ" >> /etc/kafka/server.properties
      sed -i '12i export JMX_PORT=9999'  /bin/kafka-server-start
      sed -i '16i export KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname='$IP' -Dcom.sun.management.jmxremote.port=9999 -Dcom.sun.management.jmxremote.rmi.port=9999"'  /bin/kafka-server-start
    fi
  fi
  ZOOKEEPER_NODES=$ZOOKEEPER_NODES"server.$(($(echo $${sorted_array_ips[@]/$IP//} | cut -d/ -f1 | wc -w | tr -d ' ')+1))=$IP:2888:3888"$'\n'
  if [[ $COUNTER == 1 ]]; then
    ZOOKEEPER_CONNECT="$IP:2181"
  else
    ZOOKEEPER_CONNECT="$ZOOKEEPER_CONNECT,$IP:2181"
  fi
  COUNTER=$(($COUNTER+1))
 done
done

VOLUME_ASSIGNED=0
VOLUME_ASSIGNATION_FAILED=1
COUNTER_EBS=1

while [ $VOLUME_ASSIGNATION_FAILED == 1 ]; do
 volumes=$(aws ec2 describe-volumes --region ${region}  --filters Name=tag-value,Values=kafka-ebs-volumes-*)
 for volume in $(echo $volumes | jq -rc '.Volumes[]'); do
  STATE=$(echo $volume | jq -rc '.State')
  VOLUME_AZ=$(echo $volume | jq -rc '.AvailabilityZone')
  VOLUME_ID=$(echo $volume | jq -rc '.VolumeId')
  VOLUME_TAG=$(echo $volume | jq -rc  '.Tags[].Value')


  if [[ $VOLUME_TAG == "kafka-ebs-volumes-" ]]; then
    NEW_TAG=$(echo "$VOLUME_TAG$SERVER_I")
    echo $NEW_TAG >> /tmp/not_attached.txt
    if [[ $VOLUME_ASSIGNED == 0 ]] && [[ $MY_INST_AZ == $VOLUME_AZ ]] && [[ $STATE == "available" ]]; then
      VOLUME_ASSIGNATION_FAILED=0
      echo "I GET CALLED " >> /tmp/test.txt
      aws ec2 attach-volume --region ${region} --volume-id $VOLUME_ID --instance-id $MY_INST_ID --device "/dev/xvdf" &> /tmp/error_out_ebs_$COUNTER_EBS.txt || VOLUME_ASSIGNATION_FAILED=1


      if [[ $VOLUME_ASSIGNATION_FAILED == 0 ]]; then
        DATA_STATE="unkown"
        until [ $DATA_STATE == "attached" ]; do
          DATA_STATE=$(aws ec2 describe-volumes --region ${region} --filters Name=attachment.instance-id,Values=$MY_INST_ID Name=attachment.device,Values=/dev/xvdf --query Volumes[].Attachments[].State --output text)
          echo "Not Attached" >> /tmp/trying_to_attach.txt
          sleep 5
        done
        VOLUME_ASSIGNED=1
        aws ec2 create-tags --region ${region} --resources $VOLUME_ID --tags Key=Name,Value=kafka-ebs-volumes-$SERVER_I
        # format EBS volume
        if [ $(file -s /dev/xvdf | cut -d ' ' -f 2) == "data" ]; then
           echo "format EBS VOLUME GETS CALLED" >> /tmp/EBS_CALL.txt
           mkfs -t ext4 /dev/xvdf
        fi
        if ! grep /dev/xvdf /etc/mtab > /dev/null; then
          echo "mount the volume" >> /tmp/mount_volume.txt
          mount /dev/xvdf /var/lib/kafka
        fi
        # update fstab
        if ! grep /var/lib/kafka /etc/fstab > /dev/null; then
          echo "update fstab" >> /tmp/update_fstab.txt
          echo "/dev/xvdf /var/lib/kafka ext4 defaults,nofail 0 2" >> /etc/fstab
        fi
        if [ ! -d /var/lib/kafka/data ]; then
          mkdir -p /var/lib/kafka/data
          chown -R cp-kafka:confluent /var/lib/kafka
        fi
      fi
    fi
  fi

  if [[ $VOLUME_TAG =~ kafka-ebs-volumes-* ]]; then
    echo "ebs volumes attached" >> /tmp/already_attached.txt
    EBS_I=$(echo $VOLUME_TAG | cut -d- -f4)
    if [[ $VOLUME_ASSIGNED == 0 ]] && [[ $MY_INST_AZ == $VOLUME_AZ ]] && [[ $STATE == "available" ]] && [[ $EBS_I == $SERVER_I ]]; then
      VOLUME_ASSIGNATION_FAILED=0
      echo "I GET CALLED " >> /tmp/test.txt
      aws ec2 attach-volume --region ${region} --volume-id $VOLUME_ID --instance-id $MY_INST_ID --device "/dev/xvdf" &> /tmp/error_out_ebs_$COUNTER_EBS.txt || VOLUME_ASSIGNATION_FAILED=1

      if [[ $VOLUME_ASSIGNATION_FAILED == 0 ]]; then
        DATA_STATE="unkown"
        until [ $DATA_STATE == "attached" ]; do
          DATA_STATE=$(aws ec2 describe-volumes --region ${region} --filters Name=attachment.instance-id,Values=$MY_INST_ID Name=attachment.device,Values=/dev/xvdf --query Volumes[].Attachments[].State --output text)
          echo "Not Attached" >> /tmp/trying_to_attach.txt
          sleep 5
        done
        VOLUME_ASSIGNED=1
        # format EBS volume
        if [ $(file -s /dev/xvdf | cut -d ' ' -f 2) == "data" ]; then
           echo "format EBS VOLUME GETS CALLED" >> /tmp/EBS_CALL.txt
           mkfs -t ext4 /dev/xvdf
        fi
        if ! grep /dev/xvdf /etc/mtab > /dev/null; then
          echo "mount the volume" >> /tmp/mount_volume.txt
          mount /dev/xvdf /var/lib/kafka
        fi
        # update fstab
        if ! grep /var/lib/kafka /etc/fstab > /dev/null; then
          echo "update fstab" >> /tmp/update_fstab.txt
          echo "/dev/xvdf /var/lib/kafka ext4 defaults,nofail 0 2" >> /etc/fstab
        fi
        if [ ! -d /var/lib/kafka/data ]; then
          mkdir -p /var/lib/kafka/data
          chown -R cp-kafka:confluent /var/lib/kafka
        fi
      fi
    fi
  fi

  echo "VOLUMES_ASSIGNED: $VOLUME_ASSIGNED + COUNTER_EBS: $COUNTER_EBS + EBS_I: $EBS_I + SERVER_I: $SERVER_I + MY_AZ: $MY_INST_AZ + VOLUME_AZ: $VOLUME_AZ + STATE: $STATE" >> /tmp/informations_ebs_debug.txt
  echo "I GET CALLED $COUNTER_EBS" >> /tmp/ebs_counter.txt
  COUNTER_EBS=$(($COUNTER_EBS+1))
 done
done

echo "zookeeper.connect=$ZOOKEEPER_CONNECT" >> /etc/kafka/server.properties
echo "$ZOOKEEPER_NODES" >> /etc/kafka/zookeeper.properties
echo "broker.id=$(($SERVER_I-1))" >> /etc/kafka/server.properties
echo "$SERVER_I" >> /var/lib/zookeeper/myid

KAFKA_HOSTNAME="$(hostname)"
echo "$${KAFKA_HOSTNAME}"

keytool -genkey -noprompt -alias localhost -dname "CN=$${KAFKA_HOSTNAME}, OU=Woodmark Cloud, O=Woodmark, L=München, S=Bayern, C=GB" -validity 356 -keystore /var/ssl/private/kafka.server.keystore.jks -storepass serpentes -keypass serpentes
keytool -noprompt -keystore /var/ssl/private/kafka.server.keystore.jks -alias localhost -certreq -file /var/ssl/private/cert-file -storepass serpentes
openssl x509 -req -CA /var/ssl/private/ca-cert -CAkey /var/ssl/private/ca-key -in /var/ssl/private/cert-file -out /var/ssl/private/cert-signed -days 356 -CAcreateserial -passin pass:serpentes
keytool -noprompt -keystore /var/ssl/private/kafka.server.keystore.jks -alias CARoot -import -file /var/ssl/private/ca-cert -storepass serpentes
keytool -noprompt -keystore /var/ssl/private/kafka.server.keystore.jks -alias localhost -import -file /var/ssl/private/cert-signed -storepass serpentes

ATTACHED=0
echo $enis > /tmp/enis.txt
while [ $ATTACHED == 0 ]; do
  enis=$(aws ec2 describe-network-interfaces --region ${region} --filter Name=tag-value,Values=$TAG)
  ATTACHED=1
  for eni in $(echo $enis | jq -rc '.NetworkInterfaces[]'); do
    echo $eni >> /tmp/eni.txt
     STATUS=$(echo $eni | jq -rc '.Attachment.Status')
     echo "$COUNTER + $STATUS" >> /tmp/logs.txt
     if [[ $STATUS != "attached" ]]; then
      ATTACHED=0
     fi
     COUNTER=$(($COUNTER+1))
  done
done

if [[ $ATTACHED == 1 ]]; then
  echo "I GET CALLED" >> /tmp/starts
  systemctl start confluent-zookeeper
  systemctl start confluent-kafka
fi