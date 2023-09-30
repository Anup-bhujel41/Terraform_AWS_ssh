provider "aws" {
   #region = "ap-south-1" if you nned only one region
    region = var.region   #if you need amid_id as per region
   access_key  = var.access_key
   secret_key = var.secret_key

}