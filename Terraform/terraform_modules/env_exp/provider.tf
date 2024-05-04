terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  backend "s3" {
    bucket = "training-bucket-hjkldsahjklasd"
    key    = "test-environment/tf.state"
    region = "us-east-1"
    /* dynamodb_table = "terraform_state" */
  }
}

