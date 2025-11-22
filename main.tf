###################################################
## SSH Keys
###################################################
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
##################################################
# Store private key in parameter store
##################################################
resource "aws_ssm_parameter" "ssh_key" {
  name      = "${var.environment}-ssh-key"
  type      = "String"
  value     = tls_private_key.key.private_key_pem
  overwrite = true
}
##################################################
# Create key pair in aws
##################################################
resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.environment}-ssh-key"
  public_key = trimspace(tls_private_key.key.public_key_openssh)
  #public_key = file("${path.module}/id_rsa.pub")
}

