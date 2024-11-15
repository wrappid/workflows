# Service Deploy Workflow

This reusable GitHub Actions workflow automates the deployment of services to a remote server with verification and optional email notifications.

## Overview

The workflow performs these main tasks:
1. Checkouts the repository and gets the current tag
2. Deploys the service to a remote server using SSH
3. Verifies the deployment by checking service availability
4. Sends email notifications for successful/failed deployments (optional)

## Usage

Create a workflow file (e.g., `.github/workflows/deploy-service.yml`) in your repository:

```yaml
name: Deploy Service

on:
  workflow_dispatch:

jobs:
  deploy:
    uses: wrappid/workflows/.github/workflows/service-deploy.yml@main
    with:
      EMAIL_NOTIFY: "true"
      EMAIL_SENDER_NAME: "CI/CD Pipeline"
      PROJECT_HOSTED_URL: "https://your-service-url.com"
    secrets:
      PAT: ${{ secrets.PAT }}
      REMOTE_HOST: ${{ secrets.REMOTE_HOST }}
      REMOTE_SSH_KEY: ${{ secrets.REMOTE_SSH_KEY }}
      REMOTE_SSH_USER: ${{ secrets.REMOTE_SSH_USER }}
      REMOTE_PATH_OF_PROJECT_DEPLOYMENT_PATH: ${{ secrets.REMOTE_PATH_OF_PROJECT_DEPLOYMENT_PATH }}
      EMAIL_SERVER_ADDRESS: ${{ secrets.EMAIL_SERVER_ADDRESS }}
      EMAIL_SERVER_PORT: ${{ secrets.EMAIL_SERVER_PORT }}
      EMAIL_USER_ID: ${{ secrets.EMAIL_USER_ID }}
      EMAIL_USER_PASSWORD: ${{ secrets.EMAIL_USER_PASSWORD }}
      EMAIL_TO: ${{ secrets.EMAIL_TO }}
      EMAIL_CC: ${{ secrets.EMAIL_CC }}
      EMAIL_BCC: ${{ secrets.EMAIL_BCC }}
```

## Inputs

| Name | Required | Default | Description |
|------|----------|---------|-------------|
| `EMAIL_NOTIFY` | Yes | "true" | Enable/disable email notifications |
| `EMAIL_SENDER_NAME` | No | - | Name to use as email sender |
| `PROJECT_HOSTED_URL` | Yes | - | URL where the service will be hosted |

## Secrets

### Required Secrets
- `PAT`: GitHub Personal Access Token
- `REMOTE_HOST`: Remote server hostname/IP
- `REMOTE_SSH_KEY`: SSH private key for server access
- `REMOTE_SSH_USER`: SSH username for server access
- `REMOTE_PATH_OF_PROJECT_DEPLOYMENT_PATH`: Deployment path on remote server

### Email Notification Secrets (Required if EMAIL_NOTIFY is true)
- `EMAIL_SERVER_ADDRESS`: SMTP server address
- `EMAIL_SERVER_PORT`: SMTP server port
- `EMAIL_USER_ID`: SMTP user ID
- `EMAIL_USER_PASSWORD`: SMTP user password
- `EMAIL_TO`: Recipient email address(es)

### Optional Email Notification Secrets
- `EMAIL_CC`: CC email address(es)
- `EMAIL_BCC`: BCC email address(es)

## Jobs and Steps

### 1. Service Deploy Job
- Checkouts the repository
- Gets the current tag version
- Deploys to remote server using SSH
- Verifies deployment by checking URL accessibility
- Outputs:
  - `tag-version`: Deployed version tag

### 2. Email Notification Jobs
Two separate email notification jobs are included:
- `call-send-email-deployed`: Sends success notification when deployment completes
- `call-send-email-failure`: Sends failure notification if deployment fails

## Prerequisites

1. Remote server with SSH access configured
2. Proper SSH key pair setup
3. GitHub repository with proper permissions
4. SMTP server access (if email notifications enabled)
5. Service build artifacts ready for deployment

## Environment

- Runs on: Ubuntu latest
- SSH Protocol: Version 2
- Required permissions: write-all

## Deployment Verification

The workflow includes an automated deployment verification step that:
1. Waits 10 seconds for service to start
2. Checks the provided URL for HTTP 200 response
3. Fails the workflow if service is not accessible

## Deployment Script

The workflow uses a deployment script (`service-deploy.sh`) from the workflows repository that:
1. Is executed on the remote server
2. Receives deployment path and repository information
3. Handles the actual service deployment process

## Notes

- The workflow uses SSH for secure remote server access
- Deployment verification ensures service is actually running
- Email notifications provide immediate feedback on deployment status
- The deployment script is fetched from the workflows repository

## Troubleshooting

1. Verify SSH access to remote server
2. Check deployment path permissions on remote server
3. Ensure service URL is correctly configured
4. Review SSH key configuration
5. Verify email server settings if notifications aren't being received

## Security Considerations

1. Use secrets for all sensitive information
2. Ensure SSH keys have appropriate restrictions
3. Limit deployment user permissions on remote server
4. Use specific deployment paths for each service
5. Regular rotation of access credentials

## Common Issues

1. SSH Connection Failures
   - Verify SSH key format and permissions
   - Check remote host firewall settings
   - Confirm SSH user access rights

2. Deployment Verification Failures
   - Check service startup time (may need to increase wait time)
   - Verify service port configuration
   - Check service logs on remote server

3. Email Notification Issues
   - Verify SMTP server settings
   - Check email credentials
   - Confirm recipient email addresses
