include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../.."
}

inputs = {
  environment = "prod"
  # متغيرات البيئة الإنتاجية
  instance_type = "t3.medium"
}
