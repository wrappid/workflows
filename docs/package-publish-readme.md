# Package Publish Workflow

This reusable GitHub workflow automates the process of publishing npm packages to GitHub's package registry. It handles package downloading, publishing, and sends email notifications upon completion.

## Workflow Overview

The workflow is designed to:
1. Download the latest package release
2. Publish it to the GitHub package registry
3. Send email notifications about the publishing status

## Usage

To use this workflow in your repository, create a workflow file with the following structure:

```yaml
jobs:
  publish:
    uses: wrappid/workflows/.github/workflows/package-publish.yml@main
    with:
      EMAIL_NOTIFY: "true"
      EMAIL_SENDER_NAME: "CI Bot"
    secrets:
      PAT: ${{ secrets.PAT }}
      WRAPPID_PUBLISH_TOKEN: ${{ secrets.WRAPPID_PUBLISH_TOKEN }}
      EMAIL_SERVER_ADDRESS: ${{ secrets.EMAIL_SERVER_ADDRESS }}
      EMAIL_SERVER_PORT: ${{ secrets.EMAIL_SERVER_PORT }}
      EMAIL_USER_ID: ${{ secrets.EMAIL_USER_ID }}
      EMAIL_USER_PASSWORD: ${{ secrets.EMAIL_USER_PASSWORD }}
      EMAIL_TO: ${{ secrets.EMAIL_TO }}
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `EMAIL_NOTIFY` | Enable email notifications | Yes | "true" |
| `EMAIL_SENDER_NAME` | Name of the email sender | No | - |

## Required Secrets

### Authentication
- `PAT`: GitHub Personal Access Token
- `WRAPPID_PUBLISH_TOKEN`: Token for publishing to GitHub package registry

### Email Configuration (Required if EMAIL_NOTIFY is true)
- `EMAIL_SERVER_ADDRESS`
- `EMAIL_SERVER_PORT`
- `EMAIL_USER_ID`
- `EMAIL_USER_PASSWORD`
- `EMAIL_TO`
- `EMAIL_CC` (Optional)
- `EMAIL_BCC` (Optional)

## Jobs

### package-publish
- **Environment**: Ubuntu latest with Node.js 18
- **Steps**:
  1. Checkout repository
  2. Setup Node.js with GitHub package registry
  3. Get current tag version
  4. Download latest release package
  5. Publish package to registry
- **Outputs**:
  - `tag-version`: The current tag version

### call-send-email-deployed
- Sends email notification after successful package publish
- Only runs if EMAIL_NOTIFY is set to true
- Uses the send-email-publish workflow

## Environment Variables

The workflow uses the following environment variables:
- `GITHUB_TOKEN`: For GitHub API authentication
- `NODE_AUTH_TOKEN`: For npm package registry authentication

## Prerequisites

1. Node.js package with valid package.json
2. `publish` script defined in package.json
3. GitHub repository with appropriate permissions
4. Required secrets configured in repository settings

## Example package.json publish script

```json
{
  "scripts": {
    "publish": "npm publish *.tgz"
  }
}
```

## Working with Tags

The workflow automatically:
1. Detects the latest tag
2. Uses 1.0.0 as fallback if no tag exists
3. Passes the tag version to email notification job

## Outputs

The workflow provides the following outputs that can be used by dependent workflows:
- `tag-version`: The version tag of the published package

## Error Handling

The workflow will fail if:
- Required secrets are not provided
- Package download fails
- Publishing process encounters errors
- Package version already exists in registry

## Limitations

1. Only supports GitHub package registry
2. Requires Node.js package structure
3. Must have appropriate npm scripts configured
4. Limited to Ubuntu runner environment

## Security Considerations

1. Use secure tokens with minimum required permissions
2. Keep email credentials secure
3. Protect GitHub PAT with appropriate scopes
4. Store sensitive data only in secrets

## Support

If you encounter issues:
1. Check workflow logs for error messages
2. Verify all secrets are properly configured
3. Ensure package.json is properly configured
4. Validate publishing permissions

For additional support, please open an issue in the workflows repository with:
- Workflow run logs (sanitized)
- Package.json configuration
- Error messages received
- Steps to reproduce the issue

