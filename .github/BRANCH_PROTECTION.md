# Branch Protection Rules

This document describes the branch protection rules configured for this repository.

## Main Branch Protection

The `main` branch is protected with the following rules:

### Required Reviews
- **Require pull request reviews before merging**: Enabled
- **Required approving reviews**: 1
- **Dismiss stale pull request approvals when new commits are pushed**: Enabled
- **Require review from Code Owners**: Enabled (see [CODEOWNERS](CODEOWNERS))

### Status Checks
- **Require status checks to pass before merging**: Enabled
- **Required status checks**:
  - `Build and Push Docker Image` - Validates Dockerfile builds successfully

### Additional Restrictions
- **Require conversation resolution before merging**: Enabled
- **Require linear history**: Enabled (squash or rebase merges only)
- **Do not allow bypassing the above settings**: Enabled for administrators

### Allowed Merge Types
- ✅ **Squash merging** (recommended)
- ✅ **Rebase merging**
- ❌ **Merge commits** (disabled to maintain linear history)

### Auto-deletion
- **Automatically delete head branches**: Enabled

## Why These Rules?

### Pull Request Reviews
Ensures all changes are reviewed before merging, maintaining code quality.

### Status Checks
Automated build checks ensure the Dockerfile works before merging.

### Linear History
Squash or rebase merging creates a clean, linear git history.

### Conversation Resolution
Ensures all review feedback is addressed before merging.

## Release Process

Since tags trigger Docker image builds:

1. Create PR with changes
2. Get approval from code owner
3. Merge to `main`
4. Tag the commit: `git tag v0.XX && git push --tags`
5. GitHub Actions builds and pushes to GHCR + DockerHub

**Note**: You can only push to `main` via PR. Tags must be created locally and pushed.

## Setting Up Branch Protection

To configure these rules on GitHub:

1. Go to **Settings** → **Branches**
2. Click **Add rule** under "Branch protection rules"
3. Set **Branch name pattern**: `main`
4. Configure the following options:

```
☑ Require a pull request before merging
  ☑ Require approvals (1)
  ☑ Dismiss stale pull request approvals when new commits are pushed
  ☑ Require review from Code Owners

☑ Require status checks to pass before merging
  ☑ Require branches to be up to date before merging
  Required status checks:
    - Build and Push Docker Image

☑ Require conversation resolution before merging

☑ Require linear history

☑ Do not allow bypassing the above settings (includes administrators)
```

5. Click **Create** or **Save changes**

## Troubleshooting

### PR Can't Be Merged

**Issue**: "Required status checks have not been completed"
- **Solution**: Wait for build to complete. If it fails, fix the Dockerfile and push.

**Issue**: "Review required"
- **Solution**: Request review from a code owner. See [CODEOWNERS](CODEOWNERS).

**Issue**: "Conversation not resolved"
- **Solution**: Resolve all comment threads before merging.

## References

- [About branch protection rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches)
- [About code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [About status checks](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/about-status-checks)
