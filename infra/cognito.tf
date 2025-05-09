resource "aws_cognito_user_pool" "userpool" {
  name = "${var.projectName}-UP"

  email_verification_subject = "Your Verification Code"
  email_verification_message = "Please use the following code: {####}"
  alias_attributes           = ["email"]
  auto_verified_attributes   = ["email"]

  password_policy {
    minimum_length    = 6
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  username_configuration {
    case_sensitive = false
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 7
      max_length = 256
    }
  }
}

resource "aws_cognito_user_pool_client" "userpool_client" {
  name                                 = "${var.projectName}-UP-Client"
  user_pool_id                         = aws_cognito_user_pool.userpool.id
  callback_urls                        = ["https://example.com"]
  explicit_auth_flows                  = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["openid", "email"]
  supported_identity_providers         = ["COGNITO"]

  generate_secret = true
}

resource "aws_cognito_user" "test_user" {
  user_pool_id = aws_cognito_user_pool.userpool.id
  username     = "johndoe"
  password     = "Test123!"
  attributes = {
    email = "johndoe@example.com"
  }

  enabled = true
}
