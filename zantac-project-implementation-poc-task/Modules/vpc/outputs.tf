output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}


output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}
