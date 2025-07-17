variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
  default     = "zantac-key"  # ✅ Change this to your actual key name
}

variable "user_data_path" {
  description = "Path to the user data script"
  type        = string
  default     = "../scripts/user_data.sh"
}