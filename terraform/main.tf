provider "local" {}

resource "null_resource" "setup_iis" {
  provisioner "local-exec" {
    command = <<EOT
      powershell.exe -Command "& {
        Install-WindowsFeature -name Web-Server -IncludeManagementTools;
        Start-Service W3SVC;
      }"
    EOT
  }
}
