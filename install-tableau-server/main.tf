
variable "os_username" {}
variable "private_key_file_name" {}
variable "eip" {}
variable "os_user_password" {}
variable "ts_admin_password" {}


resource "null_resource" "install_tableau_server" {

    connection {
      type        = "ssh"
      user        = "${var.os_username}"
      private_key = file("${var.private_key_file_name}")
      host        = "${var.eip}"
    }

    provisioner "remote-exec" {
      inline      = [
        "chmod +x /home/ubuntu/install-tableau-server.sh",
        "HISTCONTROL=ignorespace",
        <<EOT
         OS_USER_PASSWORD=${var.os_user_password}\
        TS_ADMIN_PASSWORD=${var.ts_admin_password}\
        /home/ubuntu/install-tableau-server.sh > install-log.log 2>&1
        EOT
      ]
    }
 }
