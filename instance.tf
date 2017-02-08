
resource "aws_instance" "kubernetes_controllers" {
  count=3
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.kubernetes_ec2_key.key_name}"
  associate_public_ip_address = "true"
  iam_instance_profile="${aws_iam_instance_profile.kubernetes-instance-profile.name}"
  vpc_security_group_ids=["${aws_security_group.kubernetes-securitygroup.id}"]
  private_ip="10.240.0.1${count.index}"
  subnet_id="${aws_subnet.kubernetes-public-1.id}"
  source_dest_check="false"

  tags {
      Name = "controller${count.index}"
  }
}
