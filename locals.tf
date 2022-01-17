
locals  {
  tf_vars = yamldecode(file("${path.root}/tableau-config-file.yaml"))["tf_vars"]
  ts_vars = yamldecode(file("${path.root}/tableau-config-file.yaml"))["ts_vars"]
  ssl_vars = yamldecode(file("${path.root}/tableau-config-file.yaml"))["ssl_vars"]
}
