/*
 terraform {
 backend "s3" {
    bucket         = "bucket_name"   
    key            = "envs/dev/terraform.tfstate"  
    region         = "ap-south-1"                  
    encrypt        = true
    dynamodb_table = "terraform-locks"             
  }
}
*/