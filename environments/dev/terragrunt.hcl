include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../.."
}

inputs = {
  environment = "dev"
  # أي متغيرات خاصة بالبيئة التطويرية (مثل حجم الـ instance أو عدد الـ replicas)
  instance_type = "t3.micro"
}
