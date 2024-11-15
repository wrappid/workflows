# Create App Web Release Workflow

This reusable GitHub Actions workflow automates the process of creating releases for web applications, including build generation, artifact creation, and release publishing with optional email notifications.

## Overview

The workflow performs these main tasks:
1. Checks prerequisites and existing releases
2. Sets up the development environment (Node.js, Wrappid toolkit)
3. Builds the web application
4. Creates a GitHub release with build artifacts
5. Sends email notifications (optional)

## Usage

Create a workflow file (e.g., `.github/workflows/create-release.yml`) in your repository:

```yaml
name: Create Web Release

on:
  workflow_dispatch:
    inputs:
      tag-name:
        description: 'Tag name for release (optional)'
        required: false

jobs:
  create-release:
    uses: wrappid/workflows/.github/workflows/create-app-web-release.yml@main
    with:
      GIT_USER_NAME: "Your Name"
      TOOLKIT_VERSION: "1.0.0"
      EMAIL_NOTIFY: "true"
      EMAIL_SENDER_NAME: "CI/CD Pipeline"
    secrets:
      PAT: ${{ secrets.PAT }}
      GIT_USER_EMAIL: ${{ secrets.GIT_USER_EMAIL }}
      WRAPPID_REGISTRY_TOKEN: ${{ secrets.WRAPPID_REGISTRY_TOKEN }}
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
| `GIT_USER_NAME` | Yes | - | The name to use for Git operations |
| `TOOLKIT_VERSION` | Yes | - | Version of @wrappid/toolkit to use |
| `EMAIL_NOTIFY` | Yes | "true" | Enable/disable email notifications |
| `EMAIL_SENDER_NAME` | No | - | Name to use as email sender |

## Secrets

### Required Secrets
- `PAT`: GitHub Personal Access Token
- `GIT_USER_EMAIL`: Email for Git operations
- `WRAPPID_REGISTRY_TOKEN`: Token for Wrappid npm registry access

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
- Verifies if a tag exists
- Checks if a release already exists
- Outputs:
  - `tag-version`: Version tag to use
  - `release-exist`: Whether release exists

### 2. Create Release Job
- Runs only if release doesn't exist
- Sets up development environment
- Builds web application
- Creates release with artifacts:
  - Web build (ZIP)
  - Wrappid logs
- Generates and attaches release notes

## Release Artifacts

The workflow creates and uploads these artifacts:
1. `web-v{version}.zip`: Web application build
2. `wrappid-logs-v{version}.log`: Build process logs
3. `RELEASE_NOTES.md`: Auto-generated release notes

## Prerequisites

1. Node.js project with package.json
2. GitHub repository with proper permissions
3. Wrappid toolkit compatibility
4. Required secrets configured
5. SMTP server access (if email notifications enabled)

## Environment

- Runs on: Ubuntu latest
- Node.js version: 16
- Required permissions: write-all

## Future Enhancements (TODOs)

1. Separate build and artifact creation into different jobs
2. Implement parallel build jobs
3. Add options to skip particular builds
4. Re-enable Android build support (currently commented out)

## Notes

- The workflow automatically falls back to the latest tag if no tag name is provided
- Release creation is skipped if a release already exists for the tag
- Wrappid toolkit is installed globally for build operations
- Web builds are created with staging environment configuration
- Android build support is currently disabled but can be uncommented if needed

## Troubleshooting

1. Ensure all required secrets are properly configured
2. Verify Wrappid toolkit version compatibility
3. Check if the repository has sufficient permissions
4. Review wrappid-logs for build-related issues

