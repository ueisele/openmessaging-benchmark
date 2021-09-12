# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "main" {
  ami                    = data.aws_ami.main.id
  instance_type          = "t3.micro"
  subnet_id              = tolist(data.aws_subnet_ids.public.ids)[0]
  vpc_security_group_ids = concat(data.aws_security_groups.public.ids,data.aws_security_groups.web.ids)
  iam_instance_profile   = data.aws_iam_instance_profile.default.name

  tags = {
    Name = "${var.environment}-${var.module}"
    Environment = var.environment
    Module = var.module
    Terraform = "true"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "instance" {
  instance = aws_instance.main.id
  vpc   = true

  tags = {
    Name = "${var.environment}-${var.module}"
    Environment = var.environment
    Module = var.module
    Terraform = "true"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "instance_public_ipv4" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "${var.module}.${data.aws_route53_zone.public.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.main.public_ip]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "instance_public_ipv6" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "${var.module}.${data.aws_route53_zone.public.name}"
  type    = "AAAA"
  ttl     = "300"
  records = aws_instance.main.ipv6_addresses
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "instance_private_ipv4" {
  zone_id = data.aws_route53_zone.private.zone_id
  name    = "${var.module}.${data.aws_route53_zone.private.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.main.private_ip]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "instance_private_ipv6" {
  zone_id = data.aws_route53_zone.private.zone_id
  name    = "${var.module}.${data.aws_route53_zone.private.name}"
  type    = "AAAA"
  ttl     = "300"
  records = aws_instance.main.ipv6_addresses
}