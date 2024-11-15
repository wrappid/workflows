# Create Tag Workflow

This reusable GitHub Actions workflow automates the process of creating new version tags for your repository. It handles version bumping, tag creation, and optional email notifications for successful or failed runs.

## Overview

The workflow performs the following tasks:
1. Sets up the Node.js environment
2. Configures Git and GitHub credentials
3. Processes version type inputs
4. Updates package version
5. Creates and pushes tags
6. Sends email notifications (optional)

## Usage

To use this workflow in your repository, create a new workflow file (e.g., `.github/workflows/create-tag.yml`) and call this reusable workflow:

```yaml
name: Create New Tag

on:
  workflow_dispatch:
    inputs:
      version_type:
        description: 'Version type (patch/minor/major)'
        required: false
        default: 'patch'

jobs:
  create-tag:
    uses: wrappid/workflows/.github/workflows/create-tag.yml@main
    with:
      GIT_USER_NAME: "Your Name"
      VERSION_TYPE_REPOSITORY_DEFAULT: "-r patch"
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
| `GIT_USER_NAME` | Yes | - | The name to use for Git commits |
| `VERSION_TYPE_REPOSITORY_DEFAULT` | No | - | Default version increment type ("-r patch", "-r minor", "-r major") |
| `EMAIL_NOTIFY` | Yes | "true" | Enable/disable email notifications |
| `EMAIL_SENDER_NAME` | No | - | Name to use as email sender |

## Secrets

### Required Secrets
- `PAT`: GitHub Personal Access Token
- `GIT_USER_EMAIL`: Email to use for Git commits
- `WRAPPID_REGISTRY_TOKEN`: Token for accessing Wrappid npm registry

### Required Email Notification Secrets (if EMAIL_NOTIFY is true)
- `EMAIL_SERVER_ADDRESS`: SMTP server address
- `EMAIL_SERVER_PORT`: SMTP server port
- `EMAIL_USER_ID`: SMTP user ID
- `EMAIL_USER_PASSWORD`: SMTP user password
- `EMAIL_TO`: Recipient email address(es)

### Optional Email Notification Secrets
- `EMAIL_CC`: CC email address(es)
- `EMAIL_BCC`: BCC email address(es)

## Outputs

| Name | Description |
|------|-------------|
| `tag-version` | The version number of the created tag |

## Special Behaviors

### Version Type Processing
- If no version type is specified, defaults to patch version increment
- Supports major, minor, and patch version increments
- Custom repository defaults can be set via `VERSION_TYPE_REPOSITORY_DEFAULT`

### Template Version Updates
Special handling for specific repositories:
- wrappid/wrappid-app
- wrappid/wrappid-service
- wrappid/wrappid-module

### Email Notifications
The workflow can send emails for:
- Successful tag creation
- Workflow failures

## Prerequisites

1. Node.js project with a package.json file
2. GitHub repository with proper permissions
3. Required secrets configured in repository settings
4. SMTP server access (if email notifications enabled)

## Notes

- The workflow runs on Ubuntu latest
- Requires write-all permissions
- Uses Node.js version 18
- Automatically pushes tags to the development branch
- Email notifications are optional but require additional configuration if enabled

## Future Enhancements

TODO items marked in the workflow:
- Add attribution trigger
- Check for attribution changes
- Implement attribution commit logic if changes found
