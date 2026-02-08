import json


def lambda_handler(event, context):
    """
    API Gatewayからのリクエストを処理する簡単なLambda関数
    """
    # リクエストパスとメソッドを取得
    path = event.get('path', '/')
    method = event.get('httpMethod', 'GET')

    # レスポンスボディ
    response_body = {
        'message': 'Hello from serverless-basic Lambda!',
        'path': path,
        'method': method,
        'request_id': context.aws_request_id
    }

    # API Gateway Proxy統合用のレスポンス形式
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(response_body, ensure_ascii=False)
    }
