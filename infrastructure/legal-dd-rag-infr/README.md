# Legal Due-Diligence RAG Platform Infrastructure

This repository contains the OpenTofu (Terraform-compatible) infrastructure code for the Legal Due-Diligence RAG Platform. It supports both `dev` and `prod` environments.

## Prerequisites

- [OpenTofu](https://opentofu.org/) (or Terraform >= 1.3)
- AWS CLI configured with appropriate credentials
- **S3 bucket and DynamoDB table for state backend** (must be created before running any plan)
- **Lambda ECR image** (must be built and pushed before running the full plan)

## Initial Setup

### 1. Clone the repository
```sh
# Replace <repo-url> with your repository URL
git clone <repo-url>
cd infrastructure/legal-dd-rag-infr
```

### 2. Create S3 and DynamoDB for OpenTofu state backend
These resources must exist before you run any OpenTofu commands, as they store the state and lock files.

- **Create an S3 bucket** (e.g., `legal-dd-rag-tfstate`):
  ```sh
  aws s3api create-bucket --bucket legal-dd-rag-tfstate --region us-east-1
  ```
- **Create a DynamoDB table** (e.g., `legal-dd-rag-tfstate-lock`) with `LockID` as the primary key:
  ```sh
  aws dynamodb create-table --table-name legal-dd-rag-tfstate-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST
  ```

> **Note:** You only need to do this once per AWS account/region. If you destroy these resources, you will lose your state and may break future deployments.

### 3. Build and Push the Lambda ECR Image
Before running the full plan, you must build and push the Lambda Docker image to ECR:

```bash
# Set variables
AWS_REGION=us-east-1
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REPO_NAME=legal-dd-pdf-extractor

# Create ECR repository if it doesn't exist
aws ecr describe-repositories --repository-names $REPO_NAME --region $AWS_REGION || \
  aws ecr create-repository --repository-name $REPO_NAME --region $AWS_REGION

# Build and push the Docker image
docker build -t $REPO_NAME path/to/lambda/source

docker tag $REPO_NAME:latest $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:latest

eval $(aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com)

docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:latest
```

- **Copy the resulting ECR image URI** (e.g., `123456789012.dkr.ecr.us-east-1.amazonaws.com/legal-dd-pdf-extractor:latest`).
- **Edit `envs/dev/main.tf` and `envs/prod/main.tf`**: Replace `<REPLACE_WITH_ECR_IMAGE_URI>` with your actual ECR image URI.

### 4. Update `backend.tf`
Edit `envs/dev/backend.tf` and `envs/prod/backend.tf` to match your S3 bucket and DynamoDB table names if you used different names.

## Running OpenTofu

You can use the following commands for either environment by setting the `ENV` variable to `dev` or `prod`.

### Bash (recommended)
```bash
ENV=dev   # or ENV=prod
cd envs/$ENV
opentofu init
opentofu plan
opentofu apply
```
Or as a one-liner:
```bash
ENV=dev; cd envs/$ENV; opentofu init; opentofu plan; opentofu apply
```

### PowerShell
```powershell
$ENV="dev"  # or "prod"
cd envs/$ENV
opentofu init
opentofu plan
opentofu apply
```
Or as a one-liner:
```powershell
$ENV="dev"; cd envs/$ENV; opentofu init; opentofu plan; opentofu apply
```

> **Tip:** Replace `dev` with `prod` to target the production environment.

## Notes
- Some resources (e.g., Lambda deployment packages, ECR images) must be created and referenced before a successful apply.
- Ensure you have the necessary AWS permissions to create all resources.
- The environments are independent; changes in one do not affect the other unless explicitly synchronized.

## Troubleshooting
- If you see errors about missing S3, DynamoDB, or Lambda image, ensure you have created them as described above.
- For provider or module errors, check that all required variables are set and that you are using a supported OpenTofu/Terraform version.

---
For further details, see the `README.md` files in each module or the main project brief.
