resource "aws_instance" "bastion" {
  ami                         = "ami-0c76973fbe0ee100c" # Amazon Linux 2
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  subnet_id = data.terraform_remote_state.network.outputs.subnet_public_a
  depends_on                  = [data.terraform_remote_state.network.outputs.nat_gw]
  tags = {
    Name = "Bastion"
  }
}
resource "aws_security_group" "bastion" {
  name        = "Bastion-SG"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
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
