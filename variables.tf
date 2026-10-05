variable "instances" {
  description = "EC2 instances to provision"

  type = map(object({
    instance_type    = string
    root_volume_type = string
    root_volume_size = number
    iops             = optional(number)
    key_name         = string
    environment      = string
    owner            = string
    ami_id           = string
  }))

  validation {
    condition = alltrue([
      for instance in var.instances :
      contains(
        ["gp2", "gp3", "io1", "io2", "standard"],
        instance.root_volume_type
      )
    ])

    error_message = "root_volume_type must be gp2, gp3, io1, io2, or standard."
  }

  validation {
    condition = length([
      for instance in var.instances :
      instance
      if contains(["io1", "io2"], instance.root_volume_type)
    ]) >= 1

    error_message = "At least one instance must use io1 or io2 storage."
  }
}
