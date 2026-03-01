# Deployment Guide

Status: Draft v1  
Last updated: 2026-03-01

## Scope

Deploy identity bootstrap primitives for Azure OIDC federation and RBAC, then hand off outputs to consuming repos.

## Prerequisites

1. Azure tenant/subscription admin context for initial bootstrap.
2. GitHub org/repo subject definitions finalized.
3. Terraform configured with required provider auth.

## Deployment Steps

1. Prepare `terraform.tfvars` with tenant/subscription, repos, and scope mappings.
2. Run local bootstrap:
   - `terraform init`
   - `terraform plan`
   - `terraform apply`
3. Capture outputs (client ID, tenant ID, subscription ID, subject map).
4. Configure downstream repo variables/secrets.
5. Validate OIDC login in downstream CI workflow.

## Promotion Strategy

1. Pilot one repo first.
2. Roll out to additional repos in controlled batches.
3. Track onboarding completion in central project board.

## Rollback

1. Revert Terraform commit if trust/role regression introduced.
2. Remove unintended federated credentials/assignments.
3. Re-run downstream CI validation.

## Evidence

1. Plan/apply logs or run links.
2. Output handoff record.
3. Successful downstream OIDC-authenticated workflow run.
