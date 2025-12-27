resource "local_file" "test" {
    content = "HELLO TERRAFORM........!"
    filename = "${path.module}/test.txt"
}