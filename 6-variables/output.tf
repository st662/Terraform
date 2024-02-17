output printfirst {
  value = "first user is ${(var.users[1])}"
}

output "printvariable" {
  value = "Hello ${var.username} and your age is ${var.age}"
}