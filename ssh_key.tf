resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "instance_key_pair" {
  key_name   = "workshop_demo"
  public_key = trimspace(tls_private_key.ssh_key.public_key_openssh)
}

resource "local_file" "private_key_pem" {
  filename = "workshop_demo.pem"
  content  = tls_private_key.ssh_key.private_key_openssh
}

resource "null_resource" "chmod" {
  depends_on = [
    local_file.private_key_pem
  ]

  provisioner "local-exec" {
    command = "chmod 400 ${local_file.private_key_pem.filename}"
  }
}
