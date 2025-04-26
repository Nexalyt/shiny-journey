resource "aws_sfn_state_machine" "main" {
  name     = "legal-dd-stepfuncs${var.environment}"
  role_arn = "arn:aws:iam::123456789012:role/StepFunctionsRole" # Placeholder
  definition = <<EOF
{
  "Comment": "Legal DD Extraction and Vectorization Pipeline",
  "StartAt": "ExtractPDF",
  "States": {
    "ExtractPDF": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:legal-dd-nlp${var.environment}",
      "Next": "Vectorize"
    },
    "Vectorize": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:legal-dd-vector${var.environment}",
      "End": true
    }
  }
}
EOF
  tags = merge(var.tags, { Name = "legal-dd-stepfuncs${var.environment}" })
}
