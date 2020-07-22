data "template_file" "user_data" {
  template = file("${path.module}/scripts/user_data.sh")
}

