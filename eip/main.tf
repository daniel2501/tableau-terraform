
variable "instance_id" {}
variable "associate_instance" {}

# Needs to be associated with domain DNS, either on Route 53 or other external DNS.
#resource "aws_eip" "ubuntu" {
#  count    = (var.associate_instance ? 1 : 0)
#  vpc      = true
#  instance = "${var.instance_id}"
#}

resource "aws_eip_association" "ubuntu_eip_assoc" {
  count         = (var.associate_instance ? 1 : 0)
  instance_id   = var.instance_id
  allocation_id = aws_eip.ubuntu.id
}

resource "aws_eip" "ubuntu" {
  vpc      = true
}


output "eip" {
  value = aws_eip.ubuntu.public_ip
}

# output "eip" {
#   value = (var.instance_id != "" ? aws_eip.ubuntu_associated[0].public_ip : aws_eip.ubuntu_unassociated[0].public_ip)
# }
# Not needed if using existing domain with DNS on Route 53.
#resource "aws_route53_zone" "ts-domain-zone" {
#  name = "tableau-dev.tk"
#}

# Needed if using existing Route 53 DNS.
#resource "aws_route53_record" "ts-routing-record" {
#
#  depends_on = [aws_eip.ubuntu]
#
#  count = "1"
#  name = "www"
#  records = [aws_eip.ubuntu.public_ip]
#  zone_id = aws_route53_zone.ts-domain-zone.id
#  type = "A"
#  ttl = "300"
#}

# Needed if creating a new DNS record on Route 53.
#resource "aws_route53_record" "ts-cname-record" {
#
#  depends_on = [aws_eip.ubuntu]
#
#  name = "www-cname"
#  records = ["tableau-dev.tk"]
#  zone_id = aws_route53_zone.ts-domain-zone.id
#  type = "CNAME"
#  ttl = "300"
#}
