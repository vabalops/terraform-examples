output "instance_id_name_map" {
  description = "Map of instance IDs to their Name tags"
  value = {
    for instance in aws_instance.example_2 :
    instance.id => instance.tags["Name"]
  }
}