resource "aws_instance" "ec2_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ssm-role-profile1.name
  key_name      = var.key_name
  vpc_security_group_ids = [var.vpc_security_group_ids]
  subnet_id     = var.subnet_id

  user_data = <<-EOF
              #!/bin/bash
              cd /tmp
              sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
              sudo systemctl enable amazon-ssm-agent
              sudo systemctl start amazon-ssm-agent
              EOF

  tags = {
    Name                      = "my-ec2-instance"
    Team                      = "Andres Cavagliatto"
    InstanceScheduler         = "on"
    Component                 = "sandbox" 
    InstanceSchedulerAutoStart = "off"  
    QSConfigName-e1mns        = "scan"
    Role                      = "Andres Cavagliatto"
    env                       = "stg"
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo 'instance_id = ${aws_instance.ec2_instance.id}' > outputs.txt
      echo 'public_ip = ${aws_instance.ec2_instance.public_ip}' >> outputs.txt
      echo 'private_ip = ${aws_instance.ec2_instance.private_ip}' >> outputs.txt
      echo 'instance_arn = ${aws_instance.ec2_instance.arn}' >> outputs.txt
      echo 'ec2_instance_tags = ${jsonencode(aws_instance.ec2_instance.tags)}' >> outputs.txt
    EOT
    interpreter = ["bash", "-c"]
  }
}

output "instance_id" {
  value       = aws_instance.ec2_instance.id
  description = "ID of the EC2 instance"
}

output "public_ip" {
  value       = aws_instance.ec2_instance.public_ip
  description = "Public IP address of the EC2 instance"
}

output "private_ip" {
  value       = aws_instance.ec2_instance.private_ip
  description = "Private IP address of the EC2 instance"
}
output "instance_arn" {
  value       = aws_instance.ec2_instance.arn
  description = "ARN of the EC2 instance"
}

output "ec2_instance_tags" {
  value       = aws_instance.ec2_instance.tags
  description = "Tags associated with the EC2 instance"
}

output "ssm_role_profile_arn" {
  value       = aws_iam_instance_profile.ssm-role-profile1.arn
  description = "ARN of the IAM instance profile for SSM"
}
