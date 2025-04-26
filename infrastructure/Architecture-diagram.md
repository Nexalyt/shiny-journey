# Mermaid

```
flowchart TD
    %% Nodes
    L(Lawyer)
    CBE(Callback Endpoint)
    SPA(Front-end SPA)

    Cognito[AWS Cognito]
    APIGW[API Gateway]

    RawDocs[Raw Docs Bucket]
    ProcMD[Processed MD Bucket]
    IngestQ[SQS aka. Ingest]
    DLQ[SQS DLQ]
    StepFunc[Step Functions]
    Worker[PDF Extraction Worker aka. K8s]
    VecLambda[Vector Lambda]
    SearchLambda[Search Lambda]
    NotifyLambda[Notification Lambda]

    Milvus[Milvus aka. Zilliz Cloud]
    SageMaker[SageMaker Pipeline aka. Retraining]

    %% Auth flow
    L -->|Open app| SPA
    SPA -->|Hosted UI / OIDC| Cognito
    Cognito -->|ID & Access tokens| SPA

    %% Upload / Ingest
    SPA -->|POST /upload aka. JWT| APIGW
    APIGW -->|Validate JWT| Cognito
    APIGW -->|PUT PDF aka. pre-signedaka. | RawDocs
    APIGW -->|Enqueue job| IngestQ

    %% Extraction & Vectorization
    IngestQ -->|Deliver job| Worker
    Worker -->|Upload Markdown| ProcMD
    Worker -->|Trigger vectorization| StepFunc
    StepFunc -->|Invoke embeddings| VecLambda
    VecLambda -->|Upsert vectors| Milvus

    %% Search
    SPA -->|GET /search?q=… aka. JWT| APIGW
    APIGW -->|Validate JWT| Cognito
    APIGW -->|Invoke search| SearchLambda
    SearchLambda -->|Hybrid search| Milvus
    SearchLambda -->|Fetch clause| ProcMD

    %% Callback
    StepFunc -->|Invoke callback| NotifyLambda
    NotifyLambda -->|POST result| CBE

    %% Error handling
    IngestQ -->|On failure| DLQ

    %% Optional retraining
    ProcMD -->|Ingest data| SageMaker
    SageMaker -->|Deploy fine-tuned model| VecLambda

```

# Ereaser

```
title Legal Due-Diligence RAG Platform – System Overview

// External Actors
Lawyer [icon: user]
Callback Endpoint [icon: globe]

// Frontend
SPA [icon: monitor, label: "Front-end SPA"]

// AWS Platform Boundary
Legal DD Platform [icon: aws-cloud] {
  Cognito [icon: aws-cognito]
  APIGateway [icon: aws-api-gateway, label: "API Gateway"]

  S3 Buckets [icon: aws-s3] {
    Raw Docs Bucket [icon: aws-s3, label: "Raw Docs"]
    Processed MD Bucket [icon: aws-s3, label: "Processed MD"]
  }

  IngestQueue [icon: aws-sqs, label: "SQS (Ingest)"]
  DLQ [icon: aws-sqs, label: "SQS DLQ"]
  StepFuncs [icon: aws-step-functions, label: "Step Functions"]
  Worker [icon: k8s-pod, label: "PDF Extraction Worker (K8s)"]
  VectorLambda [icon: aws-lambda, label: "Vector Lambda"]
  SearchLambda [icon: aws-lambda, label: "Search Lambda"]
  NotifyLambda [icon: aws-lambda, label: "Notification Lambda"]
}

// External Vector DB
Milvus [icon: zilliz, label: "Milvus (Zilliz Cloud)"]

// Optional retraining
SageMaker Pipeline [icon: aws-sagemaker, label: "SageMaker Pipeline (Retraining)"]

// Connections

// Auth flow
Lawyer > SPA: Open app
SPA > Cognito: Hosted UI / OIDC
Cognito > SPA: ID & Access tokens

// Upload / Ingest
SPA > APIGateway: "POST /upload (JWT)"
APIGateway > Cognito: Validate JWT
APIGateway > Raw Docs Bucket: PUT PDF (pre-signed)
APIGateway > IngestQueue: Enqueue job

// Extraction & Vectorization
IngestQueue > Worker: Deliver job
Worker > Processed MD Bucket: Upload Markdown
Worker > StepFuncs: Trigger vectorization
StepFuncs > VectorLambda: Invoke embeddings
VectorLambda > Milvus: Upsert vectors

// Search
SPA > APIGateway: "GET /search?q=… (JWT)"
APIGateway > Cognito: Validate JWT
APIGateway > SearchLambda: Invoke search
SearchLambda > Milvus: Hybrid search
SearchLambda > Processed MD Bucket: Fetch clause

// Callback
StepFuncs > NotifyLambda: Invoke callback
NotifyLambda > Callback Endpoint: POST result

// Error handling
IngestQueue > DLQ: On failure

// Optional retraining
Processed MD Bucket > SageMaker Pipeline: Ingest data
SageMaker Pipeline > VectorLambda: Deploy fine-tuned model
```

