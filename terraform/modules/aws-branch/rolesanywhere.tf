resource "aws_rolesanywhere_trust_anchor" "o3b_mgmt" {
  count = var.enable_o3b_mgmt_rolesanywhere ? 1 : 0

  name    = var.o3b_mgmt_rolesanywhere_trust_anchor_name
  enabled = true

  source {
    source_type = "CERTIFICATE_BUNDLE"

    source_data {
      x509_certificate_data = var.o3b_rolesanywhere_ca_certificate_pem
    }
  }

  tags = merge(var.common_tags, {
    Name      = var.o3b_mgmt_rolesanywhere_trust_anchor_name
    Phase     = "O3b"
    Role      = "RolesAnywhereTrustAnchor"
    Component = "AzureManagementHostRuntimeAWSAccess"
  })
}

resource "aws_iam_role" "o3b_mgmt_ssm_reader" {
  count = var.enable_o3b_mgmt_rolesanywhere ? 1 : 0

  name = var.o3b_mgmt_ssm_reader_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowIamRolesAnywhereAssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rolesanywhere.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession",
          "sts:SetSourceIdentity"
        ]
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_rolesanywhere_trust_anchor.o3b_mgmt[0].arn
          }
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name      = var.o3b_mgmt_ssm_reader_role_name
    Phase     = "O3b"
    Role      = "RuntimeSSMReader"
    Component = "AzureManagementHostRuntimeAWSAccess"
  })
}

resource "aws_iam_role_policy" "o3b_mgmt_ssm_reader" {
  count = var.enable_o3b_mgmt_rolesanywhere ? 1 : 0

  name = "pol-o3b-mgmt-ssm-read-runtime-secrets"
  role = aws_iam_role.o3b_mgmt_ssm_reader[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadOnlySpecificO3bRuntimeParameters"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = var.o3b_mgmt_ssm_parameter_arns
      }
    ]
  })
}

resource "aws_rolesanywhere_profile" "o3b_mgmt" {
  count = var.enable_o3b_mgmt_rolesanywhere ? 1 : 0

  name             = var.o3b_mgmt_rolesanywhere_profile_name
  enabled          = true
  role_arns        = [aws_iam_role.o3b_mgmt_ssm_reader[0].arn]
  duration_seconds = 3600

  tags = merge(var.common_tags, {
    Name      = var.o3b_mgmt_rolesanywhere_profile_name
    Phase     = "O3b"
    Role      = "RolesAnywhereProfile"
    Component = "AzureManagementHostRuntimeAWSAccess"
  })
}