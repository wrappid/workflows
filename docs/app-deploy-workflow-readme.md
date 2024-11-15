# App Deploy Workflow

This reusable GitHub Actions workflow automates the deployment process of applications to a remote server with health checks and email notifications.

## Overview

The workflow handles:
1. Pre-deployment validation
2. Remote server deployment
3. Deployment verification
4. Status management
5. Email notifications for success/failure

## Usage

Create a workflow file (e.g., `.github/workflows/deploy.yml`) in your repository:

```yaml
name: Deploy Application

on:
  workflow_dispatch:

jobs:
  deploy:
    uses: wrappid/workflows/.github/workflows/app-deploy.yml@main
    with:
      EMAIL_NOTIFY: "true"
      EMAIL_SENDER_NAME: "Deployment Pipeline"
      PROJECT_HOSTED_URL: "https://your-app-url.com"
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
| `PROJECT_HOSTED_URL` | Yes | - | URL where the application will be hosted |

## Secrets

### Required Deployment Secrets
- `PAT`: GitHub Personal Access Token
- `REMOTE_HOST`: Remote server hostname/IP
- `REMOTE_SSH_KEY`: SSH private key for remote access
- `REMOTE_SSH_USER`: SSH username for remote access
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

### 1. Check Pre-requisites Job
- Gets current tag version
- Generates environment variables
- Validates deployment conditions
- Outputs:
  - `tag-version`: Version to be deployed
  - `environment-variable`: Generated environment variable

### 2. App Deploy Job
- Performs deployment to remote server
- Verifies deployment success
- Handles deployment status updates
- Includes health check verification

### 3. Email Notification Jobs
- Sends success notification emails
- Sends failure notification emails
- Triggered based on deployment outcomes

## Deployment Process

1. **Pre-deployment Check**
   - Validates current state
   - Checks deployment prerequisites
   - Determines if deployment should proceed

2. **Deployment**
   - Executes remote deployment script
   - Updates environment variables
   - Sets deployment version

3. **Verification**
   - Performs health check
   - Verifies application accessibility
   - Response code validation (expects 200)

4. **Status Management**
   - Updates deployment status
   - Handles failure scenarios
   - Maintains deployment state

## Prerequisites

1. SSH access to deployment server
2. Proper permissions on deployment path
3. Valid SSL certificate (for HTTPS URLs)
4. Required secrets configured
5. SMTP server access (if email notifications enabled)

## Environment Requirements

- Remote server with SSH access
- Proper user permissions
- Bash shell environment
- curl utility installed
- sudo access for deployment user

## Error Handling

The workflow includes several error handling mechanisms:
1. Deployment decision validation
2. Health check verification
3. Status rollback on failure
4. Failure notification system

## Notes

- Deployment verification waits 10 seconds before checking
- Expects HTTP 200 response from deployed application
- Uses SSH for all remote operations
- Supports environment variable management
- Includes automatic rollback on failure

## Troubleshooting

1. **SSH Connection Issues**
   - Verify SSH key configuration
   - Check remote host accessibility
   - Confirm user permissions

2. **Deployment Failures**
   - Check remote server logs
   - Verify deployment path permissions
   - Review environment variables

3. **Health Check Failures**
   - Confirm application startup
   - Check URL accessibility
   - Verify SSL certificate validity

4. **Email Notification Issues**
   - Verify SMTP configuration
   - Check email credentials
   - Confirm recipient addresses

