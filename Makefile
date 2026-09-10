# ──────────────────────────────────────────────────────────────
# aws-infra-platform Makefile 
# Common operational targets for Terraform lifecycle & validation
# ──────────────────────────────────────────────────────────────

ENV ?= dev
TF_DIR = environments/$(ENV)

.PHONY: help fmt validate lint security plan apply destroy clean bootstrap

help: ## Show this help menu
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

bootstrap: ## Initialize remote state S3 bucket and DynamoDB table
	@echo "==> Bootstrapping backend state storage..."
	cd backend && terraform init && terraform apply

fmt: ## Check and format all Terraform files
	@echo "==> Formatting Terraform files..."
	terraform fmt -recursive

validate: ## Validate all modules and environments
	@echo "==> Validating modules..."
	@for d in modules/*/; do (cd "$$d" && terraform init -backend=false && terraform validate) || exit 1; done
	@echo "==> Validating environment $(ENV)..."
	cd $(TF_DIR) && terraform init -backend=false && terraform validate

lint: fmt validate ## Run fmt and validate

security: ## Run tfsec and checkov scans
	@echo "==> Running security scan with tfsec..."
	tfsec .
	@echo "==> Running checkov compliance scan..."
	checkov -d . --framework terraform

init: ## Initialize Terraform for specified environment (ENV=dev|staging|prod)
	@echo "==> Initializing $(ENV) environment..."
	cd $(TF_DIR) && terraform init

plan: init ## Generate Terraform execution plan (ENV=dev|staging|prod)
	@echo "==> Planning $(ENV) environment..."
	cd $(TF_DIR) && terraform plan -out=tfplan

apply: ## Apply Terraform changes for specified environment (ENV=dev|staging|prod)
	@echo "==> Applying $(ENV) environment..."
	cd $(TF_DIR) && terraform apply tfplan

destroy: init ## Destroy resources for specified environment (ENV=dev|staging|prod)
	@echo "==> Destroying $(ENV) environment..."
	cd $(TF_DIR) && terraform destroy

clean: ## Remove temporary plans and cache
	@echo "==> Cleaning plan files..."
	find . -name "tfplan" -delete
	find . -name ".terraform" -type d -prune -exec rm -rf {} +
