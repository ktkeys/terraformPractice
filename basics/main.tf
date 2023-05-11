provider  "aws" {
    region = "us-east-1"
   

    shared_credentials_file = "~/.aws/credentials"
    #region = var.aws_region

}

#plan then execute 
resource "aws_s3_bucket" "my_s3_bucket"{
    bucket = "ktkeys-bucket-3"
    versioning {
        enabled=true
    }
}

resource "aws_iam_user" "kt_iam_user" {
    name = "kt_iam_user_xyz"
}

output "my_s3_output" {
    value = aws_s3_bucket.my_s3_bucket.versioning[0].enabled
}

output "my_iam_user_complete_details" {
    value = aws_iam_user.kt_iam_user
}
