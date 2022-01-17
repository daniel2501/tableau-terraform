
provider "aws" {
    # profile            = "default"
    region               = "us-east-1"
}


module "base" {
  count                  = (local.tf_vars.run_base ? 1 : 0)
  source                 = "./base"
  public_key_file_name   = local.tf_vars.public_key_file_name
}


module "cluster" {
  depends_on             = [module.base]
  count                  = (local.tf_vars.run_cluster ? 1 : 0)
  source                 = "./cluster"
  key_name               = module.base[0].key_name # (local.tf_vars.run_base ? module.base[0].key_name : "")
  ami_id                 = local.tf_vars.ami_id
  instance_type          = local.tf_vars.instance_type
  security_group_id      = (local.tf_vars.run_base ? module.base[0].security_group_id : "")
  device_name            = local.tf_vars.hdd.device_name
  volume_type            = local.tf_vars.hdd.volume_type
  volume_size            = local.tf_vars.hdd.volume_size_in_gb
  os_username            = local.tf_vars.os_username
  private_key_file_name  = local.tf_vars.private_key_file_name
  ts_download_url_path   = local.ts_vars.ts_download_url_path
  ts_file_name           = local.ts_vars.ts_file_name
  tsm_path_prefix        = local.ts_vars.tsm_path_prefix
  ts_build_number        = local.ts_vars.ts_build_number
  initial_user_username  = local.ts_vars.initial_user_username
  ts_version             = local.ts_vars.ts_version
  license_keys           = local.ts_vars.license_keys
  activate_trial         = local.ts_vars.activate_trial
}


module "eip" {
  count                  = (local.tf_vars.run_eip ? 1 : 0)
  source                 = "./eip"
  instance_id            = (local.tf_vars.run_cluster ? module.cluster[0].instance_id : "")
  associate_instance     = local.tf_vars.associate_instance
}


module "install_tableau_server" {
  count                  = (local.tf_vars.run_install_tableau_server ? 1 : 0)
  source                 = "./install-tableau-server"
  depends_on             = [module.eip, module.cluster]
  os_username            = local.tf_vars.os_username
  private_key_file_name  = local.tf_vars.private_key_file_name
  eip                    = (local.tf_vars.run_eip ? module.eip[0].eip : "")
  os_user_password       = var.os_user_password
  ts_admin_password      = var.ts_admin_password
}


module "ssl" {
  count                  = (local.tf_vars.run_ssl ? 1 : 0)
  source                 = "./ssl"
  os_username            = local.tf_vars.os_username
  private_key_file_name  = local.tf_vars.private_key_file_name
  eip                    = (local.tf_vars.run_eip ? module.eip[0].eip : "")
  cb_ssl_email           = local.ssl_vars.cb_ssl_email
  install_certbot        = local.ssl_vars.install_certbot
  ts_url                 = local.ssl_vars.ts_url
  ts_webroot             = local.ssl_vars.ts_webroot

}
