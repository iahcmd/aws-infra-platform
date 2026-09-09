output "vpc_id"              { value = aws_vpc.this.id }
output "vpc_cidr"            { value = aws_vpc.this.cidr_block }
output "public_subnet_ids"   { value = aws_subnet.public[*].id }
output "private_subnet_ids"  { value = aws_subnet.private[*].id }
output "isolated_subnet_ids" { value = aws_subnet.isolated[*].id }
output "nat_gateway_ids"     { value = aws_nat_gateway.this[*].id }
output "igw_id"              { value = aws_internet_gateway.this.id }
