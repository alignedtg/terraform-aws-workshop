data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5*"]
  }
}

module "ec2-instance" {
  source        = "terraform-aws-modules/ec2-instance/aws"
  version       = "4.3.0"
  name          = "devopsdays-workshop-instance"
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.instance_key_pair.key_name

  user_data = <<-EOT
  #!/bin/bash
  yum update -y
  yum install -y httpd
  systemctl start httpd
  systemctl enable httpd
  echo "<h1>Hello DevOpsDays Raleigh from $(hostname -f)</h1>" > /var/www/html/index.html
  EOT

  tags = {
    Name = "devopsdays-workshop-instance"
  }

}