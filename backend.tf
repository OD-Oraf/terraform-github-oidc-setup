# S3 Bucket to hold TF State File
resource "aws_s3_bucket" "terraform_state_s3_bucket" {
  bucket = "od-orafgithub-actions-terraform-state-bucket"

  tags = {
    Name = "github-actions-terraform-state"
  }
}
