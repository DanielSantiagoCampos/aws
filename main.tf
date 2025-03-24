# 🔹 Obtener zonas de disponibilidad automáticamente
data "aws_availability_zones" "east" {
  provider = aws.east
  state    = "available"
}

data "aws_availability_zones" "west" {
  provider = aws.west
  state    = "available"
}

# 🔹 VPC en us-east-1
resource "aws_vpc" "vpc_east" {
  provider   = aws.east
  cidr_block = var.vpc_cidr_east
}

# 🔹 VPC en us-west-1
resource "aws_vpc" "vpc_west" {
  provider   = aws.west
  cidr_block = var.vpc_cidr_west
}

# 🔹 Subnet en us-east-1
resource "aws_subnet" "subnet_east" {
  provider          = aws.east
  vpc_id            = aws_vpc.vpc_east.id
  cidr_block        = var.subnet_east_cidr
  availability_zone = data.aws_availability_zones.east.names[0]
}

# 🔹 Subnet en us-west-1
resource "aws_subnet" "subnet_west" {
  provider          = aws.west
  vpc_id            = aws_vpc.vpc_west.id
  cidr_block        = var.subnet_west_cidr
  availability_zone = data.aws_availability_zones.west.names[0]
}

# 🔹 Grupo de seguridad en us-east-1
resource "aws_security_group" "allow_all_east" {
  name        = "common-firewall-east"
  description = "Allow SSH, RDP, and Ping"
  vpc_id      = aws_vpc.vpc_east.id
  provider    = aws.east

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 🔹 Grupo de seguridad en us-west-1
resource "aws_security_group" "allow_all_west" {
  name        = "common-firewall-west"
  description = "Allow SSH, RDP, and Ping"
  vpc_id      = aws_vpc.vpc_west.id
  provider    = aws.west

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 🔹 Obtener la AMI más reciente de Ubuntu en us-east-1
data "aws_ami" "ubuntu_east" {
  provider    = aws.east
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# 🔹 Obtener la AMI más reciente de Ubuntu en us-west-1
data "aws_ami" "ubuntu_west" {
  provider    = aws.west
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# 🔹 Instancia en us-east-1
resource "aws_instance" "instance_east" {
  provider               = aws.east
  ami                    = data.aws_ami.ubuntu_east.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_east.id
  vpc_security_group_ids = [aws_security_group.allow_all_east.id]

  tags = { Name = "Instance-East" }
}

# 🔹 Instancia en us-west-1
resource "aws_instance" "instance_west" {
  provider               = aws.west
  ami                    = data.aws_ami.ubuntu_west.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_west.id
  vpc_security_group_ids = [aws_security_group.allow_all_west.id]

  tags = { Name = "Instance-West" }
}
