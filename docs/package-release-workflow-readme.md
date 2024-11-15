# Package Release Workflow

This reusable GitHub Actions workflow automates the process of creating releases for npm packages, including building, packaging, and publishing releases with optional email notifications.

## Overview

The workflow performs these main tasks:
1. Checks prerequisites and existing releases
2. Builds and packages the npm module
3. Creates a GitHub release with package artifacts
4. Sends email notifications (optional)

## Usage

Create a workflow file (e.g., `.github/workflows/create-package-release.yml`) in your repository:

```yaml
name: Create Package Release

on:
  workflow_dispatch:
    inputs:
      tag-name:
        description: 'Tag name for release (optional)'
        required: false

jobs:
  create-release:
    uses: wrappid/workflows/.github/workflows/create-package-release.yml@main
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
- Sets up Node.js environment
- Builds the package
- Creates npm package using `npm pack`
- Creates GitHub release with artifacts:
  - NPM package (.tgz)
  - Release notes
- Uploads release assets

### 3. Email Notification Jobs
Two separate email notification jobs are included:
- `call-send-email-released`: Sends success notification when release is created
- `call-send-email-failure`: Sends failure notification if the workflow fails

## Release Artifacts

The workflow creates and uploads these artifacts:
1. `{package-name}-{version}.tgz`: NPM package
2. `RELEASE_NOTES.md`: Auto-generated release notes

## Prerequisites

1. Node.js project with package.json
2. GitHub repository with proper permissions
3. NPM registry access configured
4. Required secrets configured
5. SMTP server access (if email notifications enabled)

## Environment

- Runs on: Ubuntu latest
- Node.js version: 16
- Required permissions: write-all
- NPM Registry: GitHub Package Registry (npm.pkg.github.com)

## Build Process

1. Project setup:
   - Installs dependencies (excluding dev dependencies)
   - Uses npm cache for faster installations
   
2. Build steps:
   - Runs the project's build script
   - Creates distribution package
   - Generates package archive

## Future Enhancements (TODOs)

1. Separate build and artifact creation into different jobs
2. Add support for different registry deployments
3. Implement package version validation
4. Add package testing before release

## Notes

- The workflow automatically falls back to the latest tag if no tag name is provided
- Release creation is skipped if a release already exists for the tag
- Package version is extracted from package.json
- Build artifacts are created in the dist directory

## Troubleshooting

1. Common Issues:
   - Build failures
     - Check build script configuration
     - Verify dependencies are installed correctly
     - Review Node.js version compatibility

   - Release creation failures
     - Verify PAT permissions
     - Check if version tag already exists
     - Ensure package.json version is correct

   - Package publishing issues
     - Verify registry authentication
     - Check package scope configuration
     - Review registry permissions

2. Debugging Steps:
   - Review workflow logs
   - Check package.json configuration
   - Verify secret configurations
   - Test build process locally

## Security Best Practices

1. Token Management:
   - Use restricted PATs
   - Regularly rotate credentials
   - Set appropriate token expiration

2. Registry Access:
   - Use scoped registry tokens
   - Implement least privilege access
   - Regular access review

## Additional Resources

1. Package Configuration:
   - Recommended package.json settings
   - Build script configuration
   - Version management

2. Related Documentation:
   - NPM packaging guidelines
   - GitHub release documentation
   - Node.js best practices
