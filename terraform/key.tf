resource "aws_key_pair" "kubernetes_ec2_key" {
  key_name = "kubernetes_ec2_key"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}
