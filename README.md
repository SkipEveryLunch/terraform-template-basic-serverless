# serverless-basic

Lambda + API Gateway を中心としたシンプルなサーバーレス構成のTerraformプロジェクト。

## 概要

機械学習推論APIのための最小構成サーバーレスアーキテクチャ。
MVP段階では単一AZ・プライベートサブネット1つのみの構成で、将来的なDB接続を見据えてVPC内に構築。

## 主要リソース

- **VPC**: 10.0.0.0/16
- **Subnet**: プライベートサブネット 10.0.0.0/24 (ap-northeast-1a)
- **Lambda**: 機械学習推論API (VPC内配置)
- **API Gateway**: HTTPSエンドポイント
- **Route53**: カスタムドメイン (skip-every-lunch-pg.click)
- **ACM**: SSL/TLS証明書

## ディレクトリ構造

```
serverless-basic/
├── modules/aws/          # 再利用可能なモジュール
│   ├── vpc/
│   ├── subnet/
│   ├── route_table/
│   ├── security_group/
│   ├── iam_role/
│   ├── s3/
│   ├── cloudwatch_log_group/
│   ├── lambda/
│   ├── api_gateway/
│   ├── route53/
│   └── acm/
└── prd/                  # 本番環境設定
    ├── backend.tf
    ├── versions.tf
    ├── variables.tf
    ├── aws.tf
    └── outputs.tf (optional)
```

## セットアップ

### 前提条件

- Terraform 1.11.3 (tenvで管理)
- AWS CLI設定済み (profile: serverless-basic-prd)
- S3バケット: fstate-serverless-basic-prd (tfstate保存用)
- ドメイン: skip-every-lunch-pg.click

### 初期化と適用

```bash
cd prd
terraform init
terraform plan
terraform apply
```

## 特徴

- **コスト最適化**: Lambda実行時間課金、常時起動コストなし
- **MVP構成**: 単一AZ構成（Multi-AZ冗長性なし）
- **外部通信なし**: NAT Gateway不要、機械学習推論のみ
- **CI/CDフレンドリー**: Terraformはインフラ管理のみ、コードデプロイはGitHub Actionsで実施

## CI/CD (GitHub Actions)

`main` ブランチへの `lambda/` 配下の変更pushで自動デプロイが実行される。

### GitHub Actions Variables の設定

リポジトリの **Settings > Secrets and variables > Actions > Variables** に以下を設定：

| Name                | Value              |
| ------------------- | ------------------ |
| `OIDC_IAM_ROLE_ARN` | 下記コマンドで取得 |

```bash
aws iam get-role --role-name <project_name>-github-actions-<env> --query 'Role.Arn' --output text --profile <profile>
```

### ローカル実行

Dockerで FastAPI をローカル起動できる。

```bash
cd lambda
docker build -t serverless-basic-api .
docker run -p 8000:8000 serverless-basic-api
```

### ローカルからの手動デプロイ

前提条件:

- AWS CLI設定済み（適切なprofileを設定済）
- Python 3.12
- zip コマンド

```bash
cd lambda
make deploy
```

### 自動デプロイフロー

1. `main` ブランチへpush（`lambda/**` の変更時のみ発火）
2. OIDC認証でAWSにアクセス
3. Lambdaコードをビルド & ZIP作成
4. S3へアップロード
5. `aws lambda update-function-code` でデプロイ
