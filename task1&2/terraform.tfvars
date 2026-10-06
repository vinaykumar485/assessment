instances = {

  dev-web = {
    instance_type    = "t2.nano"
    root_volume_type = "gp3"
    root_volume_size = 10
    iops             = 3000
    key_name         = "dev-web-key"
    environment      = "dev"
    owner            = "vinay"
    ami_id           = "ami-0045d7fc2ad003464"
  }

  dev-api = {
    instance_type    = "t2.micro"
    root_volume_type = "gp2"
    root_volume_size = 12
    key_name         = "dev-api-key"
    environment      = "dev"
    owner            = "vinay"
    ami_id           = "ami-0045d7fc2ad003464"
  }

  staging-db = {
    instance_type    = "t2.small"
    root_volume_type = "io1"
    root_volume_size = 20
    iops             = 100
    key_name         = "staging-db-key"
    environment      = "staging"
    owner            = "vinay"
    ami_id           = "ami-0045d7fc2ad003464"
  }

  prod-app = {
    instance_type    = "c7a.medium"
    root_volume_type = "io2"
    root_volume_size = 15
    iops             = 100
    key_name         = "prod-app-key"
    environment      = "prod"
    owner            = "vinay"
    ami_id           = "ami-0045d7fc2ad003464"
  }

  monitoring = {
    instance_type    = "m7a.medium"
    root_volume_type = "standard"
    root_volume_size = 25
    key_name         = "monitoring-key"
    environment      = "monitoring"
    owner            = "vinay"
    ami_id           = "ami-0045d7fc2ad003464"
  }
}
