output "vpc_id" {
    value = aws_vpc.main.id

}

output "subnet_private_1a" {
    value = aws_subnet.private_1a.id

}
output "subnet_private_1b" {
    value = aws_subnet.private_1b.id

}
output "subnet_public_1a" {
    value = aws_subnet.public_1a.id

}
output "subnet_public_1b" {
    value = aws_subnet.public_1b.id

}
output "eip" {
    value = aws_eip.main.public_ip

}

