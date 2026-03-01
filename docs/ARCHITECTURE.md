# Architecture

Status: Draft v1  
Last updated: 2026-03-01

## Purpose

`waterapps-10-bootstrap-oidc-rbac-azure` establishes Azure identity bootstrap for GitHub Actions using OIDC federation and baseline RBAC.

This repo is a foundational control-plane layer for downstream Azure repositories.

## System Context

1. GitHub Actions requests OIDC token during CI/CD.
2. Entra federated credential validates subject trust.
3. Service principal receives scoped RBAC permissions.
4. Downstream workflows deploy/operate Azure resources without static secrets.

## Components

1. Entra application + service principal.
2. Federated identity credentials for GitHub subject patterns.
3. Azure role assignments at configured scopes.
4. Terraform module/config for bootstrap lifecycle.
5. CI workflows for validation and controlled apply.

## Control Flow

1. Bootstrap applied once with admin context.
2. Downstream repos consume emitted client/tenant/subscription identifiers.
3. CI workflows authenticate via OIDC and execute scoped actions.

## Dependencies

1. Azure subscription and tenant admin privileges for initial setup.
2. GitHub organization/repo metadata for subject binding.
3. Terraform runtime and provider support.

## Risks

1. Over-broad RBAC assignments.
2. Subject misconfiguration allowing unintended workflow trust.
3. Drift between bootstrap outputs and consuming repos.

## Mitigations

1. Least-privilege roles and explicit scope boundaries.
2. Explicit subject patterns and periodic trust review.
3. Versioned output contracts and CI validation.
