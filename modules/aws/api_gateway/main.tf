resource "aws_api_gateway_rest_api" "api" {
  name                         = "${var.project_name}-${var.env}"
  disable_execute_api_endpoint = true
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

// リソース: /{proxy+}
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

// メソッド: ANY /{proxy+}
resource "aws_api_gateway_method" "proxy_any" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = "ANY"
  request_parameters = {
    "method.request.path.proxy" = true
  }
  authorization = "NONE"
}

// Lambda関数とのProxy統合: ANY /{proxy+}
resource "aws_api_gateway_integration" "proxy_any" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_any.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  content_handling        = "CONVERT_TO_TEXT"
  uri                     = var.lambda_invoke_arn
}

// ステージ: default
resource "aws_api_gateway_stage" "default" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "default"
  deployment_id = aws_api_gateway_deployment.api.id
}

// デプロイ
resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.proxy.id,
      aws_api_gateway_method.proxy_any.id,
      aws_api_gateway_integration.proxy_any.id,
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
}

// カスタムドメイン
resource "aws_api_gateway_domain_name" "api" {
  domain_name              = var.custom_domain_name
  regional_certificate_arn = var.certificate_arn
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

// カスタムドメインとAPIのマッピング
resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = aws_api_gateway_rest_api.api.id
  domain_name = aws_api_gateway_domain_name.api.domain_name
  stage_name  = aws_api_gateway_stage.default.stage_name
}

// Lambda呼び出し権限
resource "aws_lambda_permission" "api_gateway" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}
