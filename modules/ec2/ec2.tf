resource "aws_instance" "this" {
  ami                     = "ami-0a94c8e4ca2674d5a"
  instance_type           = "t2.micro"
 
}

resource "aws_instance" "import" {
  ami                     = "ami-0a94c8e4ca2674d5a"
  instance_type           = var.instance_type
   tags = {
      Name = "terraform-import"
    }
 
}