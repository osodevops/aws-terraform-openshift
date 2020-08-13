# Find the latest RHEL image NOTE: ensure subscription is in place.
data "aws_ami" "rhel_base" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-7.?*GA*"]
  }

  owners = ["309956199498"]
}
