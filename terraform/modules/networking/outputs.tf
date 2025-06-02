output "vpc_id" {
  description = "ID of the main VPC"
  value       = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public_sub1.id, aws_subnet.public_sub2.id]
}

output "private_sub_vote_id" {
  value = aws_subnet.private_sub_vote.id
}

output "private_sub_result_id" {
  value = aws_subnet.private_sub_result.id
}

output "private_sub_worker_id" {
  value = aws_subnet.private_sub_worker.id
}

output "private_sub_db_id" {
  value = aws_subnet.private_sub_db.id
}


output "igw_id" {
  description = "ID of the internet gateway"
  value       = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}
