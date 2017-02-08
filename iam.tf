resource "aws_iam_role" "kubernetes-ec2-role" {
    name = "kubernetes-ec2-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "kubernetes-iam-policy-document" {
    statement {
        sid = "1"
        actions = [
            "ec2:*",
            "elasticloadbalancing:*",
            "route53:*",
            "ecr:*"
        ]
        resources = [
            "*",
        ]
    }
}

resource "aws_iam_policy" "kubernetes-iam-policy" {
    name = "kubernetes"
    path = "/"
    policy = "${data.aws_iam_policy_document.kubernetes-iam-policy-document.json}"
}

resource "aws_iam_instance_profile" "kubernetes-instance-profile" {
    name = "kubernetes"
    roles = ["${aws_iam_role.kubernetes-ec2-role.name}"]
}

resource "aws_iam_policy_attachment" "kubernetes-policy-attach" {
    name = "kubernetes"
    roles = ["${aws_iam_role.kubernetes-ec2-role.name}"]
    policy_arn = "${aws_iam_policy.kubernetes-iam-policy.arn}"
}
