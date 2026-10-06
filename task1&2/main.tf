resource "aws_instance" "normal" {
  for_each = {
    for name, config in var.instances :
    name => config
    if name != "staging-db"
  }

  ami           = each.value.ami_id
  instance_type = each.value.instance_type
  key_name      = each.value.key_name

  root_block_device {
    volume_type = each.value.root_volume_type
    volume_size = each.value.root_volume_size
    iops        = try(each.value.iops, null)
  }

  tags = {
    Name        = each.key
    Environment = each.value.environment
    Owner       = each.value.owner
  }
}

resource "aws_instance" "protected" {
  for_each = {
    for name, config in var.instances :
    name => config
    if name == "staging-db"
  }

  ami           = each.value.ami_id
  instance_type = each.value.instance_type
  key_name      = each.value.key_name

  root_block_device {
    volume_type = each.value.root_volume_type
    volume_size = each.value.root_volume_size
    iops        = try(each.value.iops, null)
  }

  tags = {
    Name        = each.key
    Environment = each.value.environment
    Owner       = each.value.owner
  }

  lifecycle {
    prevent_destroy = true
  }
}
