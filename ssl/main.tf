
variable "os_username" {}
variable "private_key_file_name" {}
variable "eip" {}
variable "cb_ssl_email" {}
variable "install_certbot" {}
variable "ts_url" {}
variable "ts_webroot" {}
 
resource "null_resource" "ssl" {

    connection {
      type        = "ssh"
      user        = "${var.os_username}"
      private_key = file("${var.private_key_file_name}")
      host        = "${var.eip}"
    }

    provisioner "file" {
        destination       = "/home/ubuntu/ssl.sh"
        content           = templatefile("${path.module}/ssl.sh.tftpl", {
          cb_ssl_email    = "${var.cb_ssl_email}"
          install_certbot = "${var.install_certbot}"
          ts_url          = "${var.ts_url}"
          ts_webroot      = "${var.ts_webroot}"
      })
    }

    provisioner "remote-exec" {
      inline      = [
        "chmod +x /home/ubuntu/ssl.sh",
        "/home/ubuntu/ssl.sh > install-log.log 2>&1"
      ]
    }
 }
