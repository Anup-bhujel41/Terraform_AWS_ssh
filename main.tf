# Main Configuration of the EC2 instance
resource "aws_instance" "Terraform_ssh" {
    ami = lookup(var.ami_id, "ap-south-1")
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.Terraform_ssh.id]
    tags = {
        Name = "terraform+ssh_suth+remote_exec"
    }

    key_name = aws_key_pair.rem_exec.key_name
    
#this if for remote connection to the server and execution 
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "D:\\Anup\\vscode\\Terraform_ssh\\rem_exec.pem"
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt upgrade -y",
      "sudo apt install docker.io -y",
      "sudo apt update",
      "sudo apt install openjdk-11-jre -y",
      "sudo apt-get update",
      "sudo apt-get install jenkins -y "

    ]
  }
    
}


#generating aws key pair so that we can use it for instance provisioning
resource "aws_key_pair" "rem_exec" {
  key_name   = "rem_exec"
  public_key = tls_private_key.rem_exec.public_key_openssh
}


#generating pair of keys  by terraform itself
resource "tls_private_key" "rem_exec" {
  algorithm   = "RSA"
  rsa_bits    = 2048
}


#saving the private key file to the local host 
resource "local_file" "private_key" {
  filename = "D:\\Anup\\vscode\\Terraform_ssh\\rem_exec.pem"
  content  = tls_private_key.rem_exec.private_key_pem
}



output "instance_public_ip" {
  value = aws_instance.Terraform_ssh.public_ip
}

#Security Groups as per reguirement to be added here...
resource "aws_security_group" "Terraform_ssh" {
    name = "rem_exec-group"
    description = "Added ingress rules on the instance"


    #define inbound rules
    ingress {

        from_port = var.http_port       #defined in variable.tf file
        to_port = var.http_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = var.https_port
        to_port = var.https_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = var.jenkins_port
        to_port = var.jenkins_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        
    }



    egress {
        from_port = 0 # indicates all ports
        to_port =  0 # indicates all ports
        protocol = "-1" # indicates all protocols
        cidr_blocks = ["0.0.0.0/0"]
    }
}

