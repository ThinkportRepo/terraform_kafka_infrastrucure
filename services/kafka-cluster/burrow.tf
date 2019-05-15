resource "aws_instance" "burrow" {
  provider = "aws.app"
  ami = "${var.burrow_ami}"
  instance_type = "t2.large"
  subnet_id = "${var.subnets[0]}"
  key_name = "bastion-bmw-key2"

  vpc_security_group_ids = [
    "${aws_security_group.ssh-security-group.id}",
    "${aws_security_group.internal-security-group.id}"
  ]

  tags {
    Name = "burrow-ec2"
  }
}

resource "null_resource" "kafka-nodes" {
  connection {
    host = "${aws_instance.burrow.public_dns}"
    user = "ec2-user"
    private_key = "${file("${path.cwd}/kafka-cluster/keys/bastion-bmw-key2.pem")}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y golang",
      "export GOROOT=/usr/lib/golang",
      "export GOPATH=$HOME/projects",
      "export PATH=$PATH:$GOROOT/bin",
      "echo 'export GOROOT=/usr/lib/golang' >>  ~/.bash_profile",
      "echo 'export GOPATH=$HOME/projects' >>  ~/.bash_profile",
      "echo 'export PATH=$PATH:$GOROOT/bin' >>  ~/.bash_profile",
      "sudo yum install git -y",
      "go get github.com/linkedin/Burrow",
      "cd $GOPATH/src/github.com/linkedin/Burrow",
      "curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh",
      "/home/ec2-user/projects/bin/dep ensure",
      "go install"
    ]
  }
}
