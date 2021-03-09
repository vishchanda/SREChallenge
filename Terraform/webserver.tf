
data "aws_subnet_ids" "vpc_ids" {
  vpc_id = "${aws_vpc.demo_vpc.id}"
  filter {
    name   = "tag:Name"
    values = ["demo-pub-subnet-1"] # insert values here
  }
}
resource "aws_acm_certificate" "demo_cert" {
  private_key      = "${file(var.private_key)}"
  certificate_body = "${file(var.cert)}"
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
} 

resource "aws_instance" "demo_web_server" {
  count = "${var.num_webservers}"
  subnet_id = "${element(aws_subnet.demo_pub_subnet.*.id, count.index)}"
  ami           = "ami-057b5bb96e862d82e"
  instance_type = "t2.medium"
  key_name      = "${aws_key_pair.auth.id }"

  vpc_security_group_ids = ["${aws_security_group.demo_web_sg.id}"]


 connection {
   private_key = "${file(var.key_name)}"
   user        = "ec2-user"
  }

provisioner "remote-exec" {
    inline = ["yum-config-manager --save --setopt=<repoid>.skip_if_unavailable=true", "sudo yum clean all", "sleep 60",  "sudo yum update -y", "sleep 60", "sudo yum install python -y"]
  }

provisioner "local-exec" {
    command = <<EOF
      sleep 30;
	  >demo.ini;
	  echo "[demo]" | tee -a demo.ini;
	  echo "${aws_instance.demo_web_server.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.key_name}" | tee -a demo.ini;
      export ANSIBLE_HOST_KEY_CHECKING=False;
	  ansible-playbook -u ${var.ansible_user} --private-key ${var.key_name} -i demo.ini ../playbooks/nginx/main.yml
    EOF
  }
}
