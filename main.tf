resource "aws_vpc" "nir-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name ="cust_vpc"
    }
  
}
resource "aws_subnet" "nir-sub" {
    vpc_id = aws_vpc.nir-vpc.id
    cidr_block = "10.0.0.0/24"
    tags = {
      Name="pubSubnet"
    }
  
}
resource "aws_internet_gateway" "nir-ig"{
    vpc_id = aws_vpc.nir-vpc.id
}
resource "aws_route_table" "nir-RT" {
    vpc_id = aws_vpc.nir-vpc.id
    tags = {
      Name="PubRT"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.nir-ig.id
    }
 
}
resource "aws_route_table_association" "rt_association" {
    subnet_id = aws_subnet.nir-sub.id
    route_table_id = aws_route_table.nir-RT.id
  
}
resource "aws_security_group" "nir-sg" {
    name = "allow-tls"
    description = "allow tls inbound traffic and all outbound traffic"
    vpc_id = aws_vpc.nir-vpc.id
    tags = {
      Name="allow-tls"

    }
    ingress {
        description = "Allow tls from vpc"
  #  security_group_id = aws_security_group.nir-sg.id
   # cidr_ipv4 = aws_vpc.nir-vpc.cidr_block
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_vpc_security_group_egress_rule" "egress" {
    security_group_id = aws_security_group.nir-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1" #semantically equivalent to all ports
  
}
resource "aws_instance" "nir-ec2" {
    ami=var.ami_id
    instance_type = var.instancetype
    key_name = var.keyname
    subnet_id = aws_subnet.nir-sub.id
    #security_groups=[aws_security_group.nir-sg.id]
    vpc_security_group_ids = [aws_security_group.nir-sg.id]
    tags = {
      Name="new-ec2"
    }
}