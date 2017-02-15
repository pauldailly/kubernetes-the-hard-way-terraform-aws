# Internet VPC
resource "aws_vpc" "kubernetes" {
    cidr_block = "10.240.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "kubernetes"
    }
}

resource "aws_vpc_dhcp_options" "kubernetes" {
    domain_name = "eu-west-1.compute.internal"
    domain_name_servers = ["AmazonProvidedDNS"]

    tags {
        Name = "kubernetes"
    }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
    vpc_id = "${aws_vpc.kubernetes.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.kubernetes.id}"
}

# Subnets
resource "aws_subnet" "kubernetes-public-1" {
    vpc_id = "${aws_vpc.kubernetes.id}"
    cidr_block = "10.240.0.0/16"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-1a"

    tags {
        Name = "kubernetes-public-1"
    }
}

# Internet GW
resource "aws_internet_gateway" "kubernetes-gw" {
    vpc_id = "${aws_vpc.kubernetes.id}"

    tags {
        Name = "kubernetes"
    }
}

resource "aws_route_table" "kubernetes-public" {
    vpc_id = "${aws_vpc.kubernetes.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.kubernetes-gw.id}"
    }

    tags {
        Name = "kubernetes-public-1"
    }
}

resource "aws_route_table_association" "kubernetes-public-1" {
    subnet_id = "${aws_subnet.kubernetes-public-1.id}"
    route_table_id = "${aws_route_table.kubernetes-public.id}"
}
