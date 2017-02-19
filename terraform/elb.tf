resource "aws_elb" "kubernetes-elb" {
  name = "kubernetes"
  subnets = ["${aws_subnet.kubernetes-public-1.id}"]
  security_groups = ["${aws_security_group.kubernetes-securitygroup.id}"]
 listener {
    instance_port = 6443
    instance_protocol = "tcp"
    lb_port = 6443
    lb_protocol = "tcp"
  }

  instances = ["${aws_instance.kubernetes_controllers.*.id}"]
  tags {
    Name = "kubernetes"
  }
}
