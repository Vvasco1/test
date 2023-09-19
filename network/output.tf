output "vpc name" {
	value = aws_vpc.test.id
}

output "NAT GW" {
	value = aws_nat_gateway.natgw
}

out "subnet public a" {
	value = aws_subnet.pub_a.id
}
