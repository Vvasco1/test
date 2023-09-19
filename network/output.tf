output "vpc_id" {
	value = aws_vpc.test.id
}

output "nat_gw" {
	value = aws_nat_gateway.natgw
}

output "subnet_public_a" {
	value = aws_subnet.pub_a.id
}
