output "userage" {
    value = "my name is ${var.username} and my age is ${lookup(var.usersage, "${var.username}")}"
}