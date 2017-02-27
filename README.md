# Kubernetes the hard way - Terraform AWS

An attempt to implement Kelsey Hightower's [kubernetes-the-hard-way tutorial](https://github.com/kelseyhightower/kubernetes-the-hard-way) on AWS using [Terraform](https://www.terraform.io) and [Ansible](https://www.ansible.com/).

## Installation

The following steps are required to setup and run this project:

1. Clone the repo
2. Generate an SSH key which can be used to SSH to the Kubernetes EC2 instances which will be created. The generated public/private key pair should be generated in a folder matching the path(s) found in the respective variables ```PATH_TO_PRIVATE_KEY``` and ```PATH_TO_PUBLIC_KEY``` which are declared in the [Terraform variables file](terraform/vars.tf). An example of generating such a public/private key pair is given below:

```bash
ssh-keygen -t rsa -b 4096 -C "kubernetes-the-hard-way" -f kubernetes_ec2_key
```
3. Ensure that the AWS credentials profile that you wish to use to run this project is specified correctly in the ```AWS_PROFILE``` variable in the [Terraform variables file](terraform/vars.tf).
4. Install [Terraform](https://www.terraform.io/intro/getting-started/install.html).
5. Install (go)[https://golang.org/doc/install].
6. Install the following [cfssl](https://github.com/cloudflare/cfssl) tools:

```bash
go get -u github.com/cloudflare/cfssl/cmd/cfssl
go get -u github.com/cloudflare/cfssl/cmd/cfssljson
go get -u github.com/cloudflare/cfssl/cmd/mkbundle
```

7. From the [terraform](terraform) directory execute the following to ensure that the expected resources will be created:

```bash
terraform plan
```

and then to actually create the required AWS resources:

```bash
terraform apply
```
8. Install [Ansible](https://www.ansible.com/):

```bash
pip install ansible
```

9. Install (boto)[https://boto3.readthedocs.io/en/latest/]
```bash
pip install boto
```

10. From the [ansible](ansible) directory run

```bash
./infrastructure.sh
```
11. Install [kubectl](https://kubernetes.io/docs/user-guide/prereqs/)
11. From project root run:
```bash
./configure-kubectl.sh  <URL OF LOADBALANCER>
```
