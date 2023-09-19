data "aws_vpc" "existing_vpc" { #다른 워크스페이스에 있는 VPC 정보를 가져오기 위함
  filter {
    name   = "tag:Name"
    values = ["TEST-VPC"] # 생성된 VPC 중 사용할 VPC 이름
  }
}

resource "aws_instance" "bastion" {
  ami                         = "ami-0c76973fbe0ee100c" # Amazon Linux 2
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  subnet_id = aws_subnet.pub_a.id
  depends_on                  = [aws_nat_gateway.natgw]
  tags = {
    Name = "Bastion"
  }
}
resource "aws_security_group" "bastion" {
  name        = "Bastion-SG"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.existing_vpc.id
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
