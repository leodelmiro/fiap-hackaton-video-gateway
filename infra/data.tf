data "aws_caller_identity" "current" {}

data "aws_lb" "nodegroupLb-usuario" {
  name = "ALB-usuario"
}

data "aws_lb" "nodegroupLb-recebe-video" {
  name = "ALB-recebe-video"
}

data "aws_lb" "nodegroupLb-gerencia-envio" {
  name = "ALB-gerencia-envio"
}

data "aws_iam_role" "LabRole" {
  name = "LabRole"
}