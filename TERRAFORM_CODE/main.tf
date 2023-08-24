Como descargar TERRAFORM:
wget -c https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip #ejemplo
unzip terraform_0.13.4_linux_amd64.zip

sudo mv terraform /usr/sbin/ #mover
terraform version

export TF_LOG=TRACE #Habilitar el registro de salida detallado para los comandos de Terraform
export TF_LOG= #Puede desactivar el registro detallado en cualquier momento

#PARA Iniciar TERRAFORM, ubicarse en el directorio donde se encuentra main
#TERRAFORM init
#TERRAFORM plan
#TERRAFORM apply
#TERRAFORM destroy . para eliminar todo.

###########################################################################

main.tf 1
provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "vm" {
  ami           = "DUMMY_VALUE_AMI_ID"
  subnet_id     = "DUMMY_VALUE_SUBNET_ID"
  instance_type = "t3.micro"
  tags = {  
    Name = "my-first-tf-node"
  }
resource "null_resource" "provisioner" {
  triggers = {
    instance_id = aws_instance.ec2_instance.id
  }

  provisioner "local-exec" {
    command = "sh ./dependencies.sh"  # Ruta al script que instala dependencias
  }
}

}

###########################################################################

main.tf 
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}


resource "aws_sns_topic" "topic-us-east" {
  provider = aws.us-east-1
  name     = "topic-us-east"
}

resource "aws_sns_topic" "topic-us-west" {
  provider = aws.us-west-2
  name     = "topic-us-west"
}
###########################################################################
