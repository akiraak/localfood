variable "main" {
  default = {
    "aws_account_ids" = ["699938552441"]
    "name" = "localfood"
    "route53_zone_app_name" = "localfood.mspv2.com"
    "region" = "us-west-1"
    "az_1" = "us-west-1a"
    "az_2" = "us-west-1c"
    "acm_certificate_arn" = "arn:aws:acm:us-west-1:699938552441:certificate/d02ef539-ba6c-4a9b-8f8b-26a4f7890299"
    "instance_type_management" = "t3.nano"
    "instance_type_app" = "t3.micro"
    "public_key_path_management" = "../../key-localfood-management.pub"
    "public_key_path_app" = "../../key-localfood-app.pub"
    "db_instance_type_app" = "db.t3.micro"
  }
}
