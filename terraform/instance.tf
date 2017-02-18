
resource "aws_instance" "kubernetes_controllers" {

  count=3

  ami = "${lookup(var.AMIS, var.AWS_REGION)}"

  instance_type = "t2.micro"

  key_name = "${aws_key_pair.kubernetes_ec2_key.key_name}"

  associate_public_ip_address = "true"

  iam_instance_profile="${aws_iam_instance_profile.kubernetes-instance-profile.name}"

  vpc_security_group_ids=["${aws_security_group.kubernetes-securitygroup.id}"]

  private_ip="${cidrhost(aws_vpc.kubernetes.cidr_block, 10 + count.index)}"

  subnet_id="${aws_subnet.kubernetes-public-1.id}"

  source_dest_check="false"

  tags {
      Name = "controller-${count.index}"
      Role = "controller"
      AnsibleFilter = "${var.ANSIBLE_FILTER}"
      AnsibleNodeName = "controller${count.index}"
  }
}

resource "aws_instance" "kubernetes_workers" {

  count=3

  ami = "${lookup(var.AMIS, var.AWS_REGION)}"

  instance_type = "t2.micro"

  key_name = "${aws_key_pair.kubernetes_ec2_key.key_name}"

  associate_public_ip_address = "true"

  iam_instance_profile="${aws_iam_instance_profile.kubernetes-instance-profile.name}"

  vpc_security_group_ids=["${aws_security_group.kubernetes-securitygroup.id}"]

  private_ip="${cidrhost(aws_vpc.kubernetes.cidr_block, 20 + count.index)}"

  subnet_id="${aws_subnet.kubernetes-public-1.id}"

  source_dest_check="false"

  tags {
      Name = "worker-${count.index}"
      Role = "worker"
      AnsibleFilter = "${var.ANSIBLE_FILTER}"
      AnsibleNodeName = "worker${count.index}"
  }
}

resource "aws_instance" "etcd_cluster_members" {

  count=3

  ami = "${lookup(var.AMIS, var.AWS_REGION)}"

  instance_type = "t2.micro"

  key_name = "${aws_key_pair.kubernetes_ec2_key.key_name}"

  associate_public_ip_address = "true"

  iam_instance_profile="${aws_iam_instance_profile.kubernetes-instance-profile.name}"

  vpc_security_group_ids=["${aws_security_group.kubernetes-securitygroup.id}"]

  private_ip="${cidrhost(aws_vpc.kubernetes.cidr_block, 30 + count.index)}"

  subnet_id="${aws_subnet.kubernetes-public-1.id}"

  source_dest_check="false"

  tags {
      Name = "etcd-${count.index}"
      Role = "etcd"
      AnsibleFilter = "${var.ANSIBLE_FILTER}"
      AnsibleNodeName = "etcd${count.index}"
  }
}


output "controller_addresses" {
  value = ["Controller IPs: ${aws_instance.kubernetes_controllers.*.private_ip}"]
}

output "worker_addresses" {
  value = ["Worker IPs: ${aws_instance.kubernetes_workers.*.private_ip}"]
}

output "etcd_cluster_addresses" {
  value = ["Worker IPs: ${aws_instance.etcd_cluster_members.*.private_ip}"]
}
