# Contributing to astrometry-dockerised-solver

Thank you for considering contributing! This guide will help you understand the workflow.

## Quick Start

1. Fork the repository
2. Create a feature branch: `git checkout -b fix/my-fix`
3. Make your changes
4. Test locally: `docker build -t test .`
5. Commit with conventional commit format
6. Push and create a PR with appropriate prefix

## PR Title Format

PR titles control versioning and releases:

### Version Bumps

- `[MAJOR]` or `[major]` - New upstream astrometry.net version (e.g., 0.97 → 0.98)
  - Example: `[MAJOR] Update to astrometry.net 0.98`
  - Requires updating VERSION file to `0.98.0`

- `[PATCH]` or `[patch]` or `fix:` - Dockerfile fixes/optimizations
  - Example: `[PATCH] Optimize image layer caching`
  - Example: `fix: correct index file path`
  - Auto-increments patch: `0.97.0` → `0.97.1`

### Skip Release

- `[SKIP]` or `[skip]` - No release created
- `docs:` - Documentation changes only
- `chore:` - Repository maintenance (unless deps-related)

Add `skip-release` label to PR to skip release regardless of title.

## Conventional Commits

While not strictly required, conventional commits are encouraged:

```
feat: add new feature
fix: bug fix
docs: documentation only
chore: maintenance tasks
ci: CI/CD changes
refactor: code refactoring
```

## Development Workflow

### Testing Changes Locally

```bash
# Build the image
docker build -t test .

# Test basic functionality
docker run --rm test solve-field --version

# Test with an actual image (if you have index files)
docker run --rm \
  -v ~/astrometry-data:/usr/local/astrometry/data:ro \
  -v $(pwd):/data \
  test solve-field /data/test-image.fits
```

### Creating a PR

1. **Branch naming:**
   - `feat/description` - New features
   - `fix/description` - Bug fixes
   - `docs/description` - Documentation
   - `chore/description` - Maintenance

2. **PR title:** Use appropriate prefix (see above)

3. **PR description:** Explain what and why

4. **Request review:** PR must be approved by code owner

## Release Process

### Automated (Patch Releases)

When you merge a PR with `[PATCH]` or `fix:` title:

1. GitHub Actions automatically:
   - Bumps patch version in VERSION file
   - Creates git tag (e.g., `v0.97.1`)
   - Creates GitHub release
   - Triggers Docker image build

2. Docker image is published to:
   - GHCR: `ghcr.io/diarmuidkelly/astrometry-dockerised-solver:0.97.1`
   - DockerHub: `diarmuidk/astrometry-dockerised-solver:0.97.1`
   - Both also get `:latest` tag

### Manual (Major/Minor Releases)

When upstream astrometry.net releases a new version:

1. Automated monitoring creates an issue
2. Create PR titled `[MAJOR] Update to astrometry.net 0.98`
3. Update VERSION file: `0.98.0`
4. Update Dockerfile ARG if needed: `ARG ASTROMETRY_VERSION=0.98`
5. Merge PR → release `v0.98.0` is created

## Code Review

All PRs require:
- ✅ Approval from @DiarmuidKelly (code owner)
- ✅ Passing CI checks (Docker build must succeed)
- ✅ All conversations resolved

## Branch Protection

The `main` branch is protected:
- Direct pushes are blocked
- All changes must go through PRs
- Squash or rebase merging enforced (linear history)

See [BRANCH_PROTECTION.md](.github/BRANCH_PROTECTION.md) for full rules.

## Questions?

- Open an issue for bugs or feature requests
- Check [README.md](README.md) for usage documentation
- Review [existing issues](https://github.com/DiarmuidKelly/astrometry-dockerised-solver/issues)

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see [LICENSE](LICENSE)).
