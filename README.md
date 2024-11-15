# Wrappid Workflows Documentation

This repository contains a collection of reusable GitHub Actions workflows designed for the Wrappid ecosystem. These workflows automate various CI/CD processes across different types of Wrappid projects.

## Table of Contents

1. [Overview](#overview)
2. [Common Workflow](#common-workflow)
3. [Application Workflows](#application-workflows)
4. [Service Workflows](#service-workflows)
5. [Package Workflows](#package-workflows)
6. [Common Requirements](#common-requirements)
7. [Usage Guidelines](#usage-guidelines)

## Overview

The Wrappid workflow system is organized into three main categories:
- Application workflows (for wrappid-app projects)
- Service workflows (for wrappid-service projects)
- Package workflows (for wrappid packages)

Each category has specific workflows for building, releasing, and deploying.

## Common Workflow

### [Create Tag Workflow](./docs/create-tag-workflow-readme.md)
- **File:** `util-create-tag.yml`
- **Purpose:** Version management and tag creation
- **Used By:** All Wrappid projects
- **Key Features:**
  - Automated version bumping
  - Tag creation
  - Email notifications
  - Git management

## Application Workflows

### [Create App Web Release](./docs/create-app-web-release-readme.md)
- **File:** `util-create-app-web-release.yml`
- **Purpose:** Build and create releases for web applications
- **Key Features:**
  - Web build generation
  - Release creation
  - Asset management
  - Build artifact handling

### [App Deploy](./docs/app-deploy-workflow-readme.md)
- **File:** `util-app-deploy.yml`
- **Purpose:** Deploy web applications to AWS EC2
- **Key Features:**
  - AWS EC2 deployment
  - Environment configuration
  - Server setup
  - Deployment validation

## Service Workflows

### [Create Service Release](./docs/service-release-workflow-readme.md)
- **File:** `util-create-service-release.yml`
- **Purpose:** Build and create releases for backend services
- **Key Features:**
  - Service build generation
  - Release management
  - Dependency handling
  - Build configuration

### [Service Deploy](./docs/service-deploy-workflow-readme.md)
- **File:** `util-service-deploy.yml`
- **Purpose:** Deploy services to AWS EC2
- **Key Features:**
  - AWS EC2 deployment
  - Service configuration
  - Database setup
  - Environment management

## Package Workflows

### [Create Package Release](./docs/package-release-workflow-readme.md)
- **File:** `util-create-package-release.yml`
- **Purpose:** Create releases for Wrappid packages
- **Key Features:**
  - Package bundling
  - Release creation
  - Documentation generation
  - Version management

### [Package Publish](./docs/package-publish-readme.md)
- **File:** `util-package-publish.yml`
- **Purpose:** Publish packages to GitHub Package Registry
- **Key Features:**
  - Package publishing
  - Registry management
  - Version control
  - Publication verification

## Common Requirements

### Authentication
- GitHub Personal Access Token (PAT)
- AWS Credentials (for deployments)
- Registry tokens

### Environment Variables
```yaml
env:
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  NODE_AUTH_TOKEN: ${{ secrets.WRAPPID_REGISTRY_TOKEN }}
```

### Email Configuration
```yaml
secrets:
  EMAIL_SERVER_ADDRESS: ${{ secrets.EMAIL_SERVER_ADDRESS }}
  EMAIL_SERVER_PORT: ${{ secrets.EMAIL_SERVER_PORT }}
  EMAIL_USER_ID: ${{ secrets.EMAIL_USER_ID }}
  EMAIL_USER_PASSWORD: ${{ secrets.EMAIL_USER_PASSWORD }}
  EMAIL_TO: ${{ secrets.EMAIL_TO }}
```

## Usage Guidelines

### Workflow Selection
1. **For Applications:**
   ```mermaid
   graph TD
      A[Start] --> B{New Version?}
      B -->|Yes| C[Create Tag]
      C --> D[Create Release]
      D --> E[Deploy]
   ```

2. **For Services:**
   ```mermaid
   graph TD
      A[Start] --> B{New Version?}
      B -->|Yes| C[Create Tag]
      C --> D[Create Service Release]
      D --> E[Deploy Service]
   ```

3. **For Packages:**
   ```mermaid
   graph TD
      A[Start] --> B{New Version?}
      B -->|Yes| C[Create Tag]
      C --> D[Create Package Release]
      D --> E[Publish Package]
   ```

### Example Usage

```yaml
name: Complete CI/CD Pipeline

on:
  push:
    branches: [ main ]

jobs:
  create-tag:
    uses: wrappid/workflows/.github/workflows/util-create-tag.yml@main
    with:
      GIT_USER_NAME: ${{ github.actor }}
    secrets: inherit

  create-release:
    needs: create-tag
    uses: wrappid/workflows/.github/workflows/util-create-app-web-release.yml@main
    with:
      TOOLKIT_VERSION: "1.0.0"
    secrets: inherit

  deploy:
    needs: create-release
    uses: wrappid/workflows/.github/workflows/util-app-deploy.yml@main
    with:
      AWS_REGION: "us-east-1"
    secrets: inherit
```

### Best Practices

1. Version Management
   - Use semantic versioning
   - Document version changes
   - Keep release notes updated

2. Security
   - Secure secret management
   - Minimal permission scopes
   - Regular token rotation

3. Deployment
   - Environment-specific configurations
   - Backup before deployment
   - Rollback plans

4. Monitoring
   - Watch workflow executions
   - Monitor deployments
   - Check email notifications

## Support and Maintenance

### Troubleshooting
- Check workflow run logs
- Verify secret configurations
- Validate input parameters
- Review environment setup

### Contributing
- Fork the repository
- Create feature branch
- Submit pull request
- Follow coding standards

### Getting Help
- Open GitHub issues
- Provide reproduction steps
- Include error logs
- Specify workflow version