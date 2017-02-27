# Generate Certificates
data "template_file" "certificates" {
    template = "${file("${path.module}/certs/templates/kubernetes-csr.json.tpl")}"
    depends_on = ["aws_elb.kubernetes-elb","aws_instance.etcd_cluster_members","aws_instance.kubernetes_controllers","aws_instance.kubernetes_workers"]
    vars {
      kubernetes_api_elb_dns_name = "${aws_elb.kubernetes-elb.dns_name}"
      # TODO: Find out why this IP?
      kubernetes_cluster_dns = "10.32.0.1"

      # Unfortunately, variables must be primitives, neither lists nor maps
      etcd0_ip = "${aws_instance.etcd_cluster_members.0.private_ip}"
      etcd1_ip = "${aws_instance.etcd_cluster_members.1.private_ip}"
      etcd2_ip = "${aws_instance.etcd_cluster_members.2.private_ip}"
      controller0_ip = "${aws_instance.kubernetes_controllers.0.private_ip}"
      controller1_ip = "${aws_instance.kubernetes_controllers.1.private_ip}"
      controller2_ip = "${aws_instance.kubernetes_controllers.2.private_ip}"
      worker0_ip = "${aws_instance.kubernetes_workers.0.private_ip}"
      worker1_ip = "${aws_instance.kubernetes_workers.1.private_ip}"
      worker2_ip = "${aws_instance.kubernetes_workers.2.private_ip}"

      etcd0_dns = "${aws_instance.etcd_cluster_members.0.private_dns}"
      etcd1_dns = "${aws_instance.etcd_cluster_members.1.private_dns}"
      etcd2_dns = "${aws_instance.etcd_cluster_members.2.private_dns}"
      controller0_dns = "${aws_instance.kubernetes_controllers.0.private_dns}"
      controller1_dns = "${aws_instance.kubernetes_controllers.1.private_dns}"
      controller2_dns = "${aws_instance.kubernetes_controllers.2.private_dns}"
      worker0_dns = "${aws_instance.kubernetes_controllers.0.private_dns}"
      worker1_dns = "${aws_instance.kubernetes_controllers.1.private_dns}"
      worker2_dns = "${aws_instance.kubernetes_controllers.2.private_dns}"
    }
}
resource "null_resource" "certificates" {
  triggers {
    template_rendered = "${ data.template_file.certificates.rendered }"
  }

  provisioner "local-exec" {
    command = "mkdir -p certs/generated && echo '${ data.template_file.certificates.rendered }' > certs/generated/kubernetes-csr.json"
  }
  provisioner "local-exec" {
    command = "cd certs/generated; cfssl gencert -initca ../config/ca-csr.json | cfssljson -bare ca; cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=../config/ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes"
  }
}
