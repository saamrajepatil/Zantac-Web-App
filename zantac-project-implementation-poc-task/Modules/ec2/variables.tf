variable "subnet_ids" {
  type = list(string)
}
variable "sg_id" {}
variable "user_data_path" {}
variable "key_name" {
  description = "The name of the key pair to use for the instance"
  type        = string
  default = "zantec-key"  # ✅ Change this to your actual key name
}
variable "target_group_arns" {
  type = list(string)
}


