
variable "key_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "security_group_id" {}
variable "device_name" {}
variable "volume_type" {}
variable "volume_size" {}
variable "os_username" {}
variable "private_key_file_name" {}
variable "ts_download_url_path" {}
variable "ts_file_name" {}
variable "tsm_path_prefix" {}
variable "ts_build_number" {}
variable "initial_user_username" {}
variable "ts_version" {}
variable "license_keys" {}
variable "activate_trial" {}


# resource "null_resource" "terraform-debug" {
#   provisioner "local-exec" {
#     command = "echo $VARIABLE1 >> debug.txt"
#
#     environment = {
#         VARIABLE1 = jsonencode("${path.module}/${var.private_key_file_name}")
#     }
#   }
# }


resource "aws_instance" "ubuntu" {
      key_name      = "${var.key_name}"
      ami           = "${var.ami_id}"

      instance_type = "${var.instance_type}"

      tags = {
              Name = "ubuntu"
        }

      vpc_security_group_ids = [
              "${var.security_group_id}"
        ]

      ebs_block_device {
          device_name = "${var.device_name}"
          volume_type = "${var.volume_type}"
          volume_size = "${var.volume_size}"
        }


      connection {
          type        = "ssh"
          user        = "${var.os_username}"
          private_key = file("${path.module}/${var.private_key_file_name}")
          host        = self.public_ip
        }

      provisioner "file" {
          destination = "/home/ubuntu/install-tableau-server.sh"
          content     = templatefile("${path.module}/install-tableau-server.sh.tftpl", {
            ts_download_url       = format("%s%s", "${var.ts_download_url_path}", "${var.ts_file_name}"),
            tsm_path              = format("%s%s", "${var.tsm_path_prefix}", "${var.ts_build_number}"),
            ts_build_number       = "${var.ts_build_number}",
            initial_user_username = "${var.initial_user_username}",
            ts_version            = "${var.ts_version}",
            licenses              = "${var.license_keys}",
            activate_trial        = "${var.activate_trial}"
        })
      }

      provisioner "file" {
            destination = "/home/ubuntu/reg.json"
            source      = "${path.module}/reg.json"
      }

      provisioner "file" {
            destination = "/home/ubuntu/initial-tsm-settings.json"
            source      = "${path.module}/initial-tsm-settings.json"
      }

}


output "instance_id" {
  value = aws_instance.ubuntu.id
}
