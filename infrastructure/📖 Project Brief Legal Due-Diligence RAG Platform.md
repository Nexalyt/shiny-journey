# 📖 Project Brief: Legal Due-Diligence RAG Platform

### 1. High-Level Overview

A proof-of-concept service that lets authenticated lawyers:

1. **Upload** PDF filings → async extraction → Markdown
2. **Vectorize** each clause → store in Milvus (Zilliz Cloud)
3. **Search** semantically + BM25 hybrid via an HTTP API
4. **Retrieve** processed Markdown via pre-signed URLs
5. **Optional retraining** pipeline in SageMaker using LoRA

Built serverlessly on AWS, with a container-based PDF-reader worker running in Kubernetes (AKS or EKS), plumbed together by SQS + Step Functions, and fronted by Cognito + API Gateway.

------

### 2. Tasks for **Eraser** (Diagram Creation)

1. **Context Diagram**
   - Actors: Lawyer, Front-end SPA, Cognito, API Gateway, Extraction Worker, S3, SQS, Step Functions, Lambda/Vector Pipeline, Milvus, Callback.
   - Show federated login flow → hosted UI → JWT → API calls.
2. **Sequence Diagram**
   - Cover: Upload request → queue → worker extract → S3 put → Step Functions → vector Lambda → Milvus upsert → notification.
3. **Deployment Topology**
   - Two environments (dev / prod), each with:
     - VPC, Subnets (public/private)
     - EKS (or AKS) cluster for worker pods
     - S3 buckets (raw, processed), SQS FIFO + DLQ, Cognito User Pool, API Gateway, Step Functions, CloudWatch.

------

### 3. Tasks for **OpenTofu** (Infrastructure Setup)

#### 3.1 Environments & State

- **Dev** and **Prod** workspaces, isolated AWS accounts or prefixes
- Remote state stored in an `s3` backend (`tfstate-<env>`), with locking via DynamoDB

#### 3.2 Core Modules

1. **Identity**
   - `aws_cognito_user_pool` + federated IdPs (Google, Okta)
   - `aws_cognito_user_pool_client` & domain
2. **Networking**
   - VPC (public/private subnets), Internet Gateway, NAT Gateways
   - Security Groups for API, EKS nodes, Lambda
3. **Storage & Queue**
   - `aws_s3_bucket.raw_docs` (upload), `aws_s3_bucket.processed_md` (output)
   - `aws_sqs_queue.ingest_fifo` + `aws_sqs_queue.ingest_dlq`
4. **Compute**
   - **Kubernetes**: EKS (or AKS) cluster + node groups for PDF-reader service
   - **Serverless**: Step Functions state machine, Lambda functions for:
     - NLP + embedding
     - Search API
     - Callback notifications
5. **API & Gateway**
   - `aws_apigatewayv2_api` (HTTP API)
   - JWT authorizer tied to Cognito
   - Routes: `/upload`, `/status/{jobId}`, `/search`, `/docs/*`
6. **Observability**
   - CloudWatch Log Groups for all services
   - X-Ray / OTEL instrumentation on Lambdas & FastAPI
7. **Security & IAM**
   - Least-privilege roles for each module
   - KMS keys for S3 encryption & Secrets Manager
   - Secrets: Milvus API key, VirusTotal key, DB credentials
8. **Optional Add-Ons**
   - Terraform Module for CloudFront + Static SPA (Next.js)
   - SageMaker Pipeline resources for fine-tuning
   - Budget alerts (Textract, SageMaker, Zilliz usage)

------

### 4. Naming & Tagging Conventions

- Resource names suffixed by `-dev` or `-prod`
- Tags on every resource:
  - `Environment = dev|prod`
  - `Project = legal-dd`
  - `Owner = <team-email>`
  - `CostCenter = <code>`

## Diagram

```mermaid

```

## OpenTofu

Initial structure

```test
legal-dd-rag-infra/
├── envs/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf        # S3 + DynamoDB locking
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── backend.tf
├── modules/
│   ├── identity/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── networking/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── storage_queue/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── compute/
│   │   ├── eks/
│   │   │   ├── main.tf
│   │   │   └── variables.tf
│   │   ├── lambdas/
│   │   │   ├── main.tf
│   │   │   └── variables.tf
│   │   └── stepfunctions/
│   │       ├── main.tf
│   │       └── variables.tf
│   ├── api_gateway/
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── observability/
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── security/
│   │   ├── kms.tf
│   │   ├── iam_roles.tf
│   │   ├── secrets.tf
│   │   └── variables.tf
│   └── optional_addons/
│       ├── sagemaker/
│       ├── cloudfront_spa/
│       └── budget_alerts/
├── shared/
│   ├── provider.tf
│   ├── versions.tf
│   └── locals.tf             # Naming, tagging, global locals
├── README.md
└── Makefile (optional for automation)

```

