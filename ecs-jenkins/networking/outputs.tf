output "public_subnet_ids" {
  value = aws_subnet.ecs_public_subnet[*].id
}

output "vpc_id" {
  value = aws_vpc.ecs_vpc.id
}
