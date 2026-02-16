.PHONY: help build deploy clean

FUNCTION_NAME := serverless-basic-api-prd
S3_BUCKET := serverless-basic-lambda-deploy-prd
S3_KEY := lambda-initial.zip
ZIP_FILE := lambda-initial.zip
AWS_REGION := ap-northeast-1
BUILD_DIR := package

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: clean ## Build Lambda deployment package
	@echo "Installing dependencies..."
	pip install fastapi mangum -t $(BUILD_DIR) --quiet --platform manylinux2014_x86_64 --only-binary=:all: --python-version 3.12
	@echo "Creating deployment package..."
	cd $(BUILD_DIR) && zip -r ../$(ZIP_FILE) . --quiet
	zip $(ZIP_FILE) main.py
	@echo "Build complete: $(ZIP_FILE)"

deploy: build ## Deploy Lambda function
	@echo "Uploading to S3..."
	aws s3 cp $(ZIP_FILE) s3://$(S3_BUCKET)/$(S3_KEY)
	@echo "Updating Lambda function..."
	aws lambda update-function-code \
		--function-name $(FUNCTION_NAME) \
		--s3-bucket $(S3_BUCKET) \
		--s3-key $(S3_KEY) \
		--region $(AWS_REGION) \
		--query 'LastUpdateStatus' \
		--output text
	@echo "Deployment complete!"

clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	rm -rf $(BUILD_DIR) $(ZIP_FILE)
	@echo "Clean complete!"
