resource "aws_api_gateway_rest_api" "app" {
  name = "${var.projectName}-api"
  binary_media_types = [
    "multipart/form-data",
    "application/octet-stream",
    "video/mp4"
  ]

  body = templatefile("${path.module}/openapi.yaml", {
    userPoolId         = aws_cognito_user_pool.userpool.id
    region             = var.regionDefault
    usuario_url        = data.aws_lb.nodegroupLb-usuario.dns_name
    recebe-video_url   = data.aws_lb.nodegroupLb-recebe-video.dns_name
    gerencia-envio_url = data.aws_lb.nodegroupLb-gerencia-envio.dns_name
    audience           = aws_cognito_user_pool_client.userpool_client.id
    accountId          = data.aws_caller_identity.current.id
    role               = data.aws_iam_role.LabRole.arn
  })

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "app" {
  depends_on  = [aws_api_gateway_rest_api.app, aws_cognito_user_pool_client.userpool_client]
  rest_api_id = aws_api_gateway_rest_api.app.id
  description = "${var.projectName} Deployment"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "app" {
  depends_on = [aws_api_gateway_rest_api.app, aws_cognito_user_pool_client.userpool_client]

  deployment_id = aws_api_gateway_deployment.app.id
  rest_api_id   = aws_api_gateway_rest_api.app.id
  stage_name    = "v1"
}
