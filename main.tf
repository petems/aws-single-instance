data "aws_ami" "xenial_ami" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}

resource "aws_instance" "foobar" {
  ami                    = "${data.aws_ami.xenial_ami.image_id}"
  instance_type          = "t2.micro"


  tags {
    # Name = "foobar"
  }
  
  provisioner "chef" {
    attributes_json = <<-EOF
      {
        "key": "value",
        "app": {
          "cluster1": {
            "nodes": [
              "webserver1",
              "webserver2"
            ]
          }
        }
      }
    EOF

    environment     = "_default"
    run_list        = ["cookbook::recipe"]
    node_name       = "webserver1"
    server_url      = "https://chef.company.com/organizations/org1"
    recreate_client = true
    user_name       = "bork"
    version         = "12.4.1"
   }

}
