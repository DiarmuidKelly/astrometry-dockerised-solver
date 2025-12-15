# Astrometry.net Dockerised Solver

[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/diarmuidk/astrometry-dockerised-solver?sort=semver&label=dockerhub)](https://hub.docker.com/r/diarmuidk/astrometry-dockerised-solver)
[![ghcr.io](https://img.shields.io/badge/ghcr.io-latest-blue)](https://github.com/DiarmuidKelly/astrometry-dockerised-solver/pkgs/container/astrometry-dockerised-solver)
[![Docker Image Size](https://img.shields.io/docker/image-size/diarmuidk/astrometry-dockerised-solver/latest)](https://hub.docker.com/r/diarmuidk/astrometry-dockerised-solver)
[![Docker Pulls](https://img.shields.io/docker/pulls/diarmuidk/astrometry-dockerised-solver)](https://hub.docker.com/r/diarmuidk/astrometry-dockerised-solver)
[![License](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](LICENSE)

A minimal, maintained Docker image for the [Astrometry.net](https://github.com/dstndstn/astrometry.net) plate solver - solver binaries only, no web app.

**Available on:** [Docker Hub](https://hub.docker.com/r/diarmuidk/astrometry-dockerised-solver) • [GitHub Container Registry](https://github.com/DiarmuidKelly/astrometry-dockerised-solver/pkgs/container/astrometry-dockerised-solver)

**Source Code:** [GitHub Repository](https://github.com/DiarmuidKelly/astrometry-dockerised-solver)

Built specifically for use with [astrometry-go-client](https://github.com/DiarmuidKelly/astrometry-go-client).

## Features

- **Multi-stage build** - small runtime image (~500MB vs 2GB+ with build tools)
- **Multi-arch support** - `linux/amd64` and `linux/arm64`
- **Release-aligned** - tracks upstream astrometry.net releases
- **Automated builds** - GitHub Actions builds and publishes to GHCR
- **Upstream monitoring** - auto-creates issues when new astrometry.net releases are published

## Quick Start

```bash
# Pull from DockerHub
docker pull diarmuidk/astrometry-dockerised-solver:latest

# Show help
docker run --rm diarmuidk/astrometry-dockerised-solver:latest solve-field --help

# Check version
docker run --rm diarmuidk/astrometry-dockerised-solver:latest solve-field --version

# Solve an image (mount your index files and image directory)
docker run --rm \
  -v /path/to/index/files:/usr/local/astrometry/data:ro \
  -v /path/to/images:/data \
  diarmuidk/astrometry-dockerised-solver:latest \
  solve-field /data/your-image.fits
```

## Available Commands

All astrometry.net solver binaries are included. Simply replace `solve-field` with any command:

```bash
# Main plate solving command
docker run --rm diarmuidk/astrometry-dockerised-solver:latest solve-field --help

# Other available commands:
docker run --rm diarmuidk/astrometry-dockerised-solver:latest image2xy --help
docker run --rm diarmuidk/astrometry-dockerised-solver:latest fit-wcs --help
docker run --rm diarmuidk/astrometry-dockerised-solver:latest wcs-xy2rd --help
docker run --rm diarmuidk/astrometry-dockerised-solver:latest wcs-rd2xy --help
```

**Available binaries:**

- `solve-field` - main plate solving command
- `image2xy` - extract sources from images
- `fit-wcs` - fit WCS to xy lists
- `wcs-xy2rd`, `wcs-rd2xy` - coordinate conversions
- And more...

For detailed usage and command documentation, see the [upstream Astrometry.net solving documentation](https://github.com/dstndstn/astrometry.net/tree/main/doc#solving).

## Usage with astrometry-go-client

This image is designed to work seamlessly with the [astrometry-go-client](https://github.com/DiarmuidKelly/astrometry-go-client):

```go
// Use the containerized solver instead of the web API
client := astrometry.NewClient(astrometry.Config{
    SolverType: astrometry.LocalDocker,
    DockerImage: "diarmuidk/astrometry-dockerised-solver:latest",
    IndexPath: "/path/to/index/files",
})
```

## Index Files

The image includes one sample index file (`index-4119.fits`) covering ~20-30° field widths.

For complete coverage, download additional index files ([available here at astrometry.net](http://data.astrometry.net/)):

```bash
# Download to a local directory
mkdir -p ./index-files
cd ./index-files

# Download index files for your field of view
# See: http://data.astrometry.net/
wget http://data.astrometry.net/4100/index-41{19,18,17}.fits
```

Then mount this directory when running:

```bash
docker run --rm \
  -v $(pwd)/index-files:/usr/local/astrometry/data:ro \
  -v $(pwd):/data \
  diarmuidk/astrometry-dockerised-solver:latest \
  solve-field /data/image.fits
```

## Available Tags

Available on both [DockerHub](https://hub.docker.com/r/diarmuidk/astrometry-dockerised-solver/tags) and [GHCR](https://github.com/DiarmuidKelly/astrometry-dockerised-solver/pkgs/container/astrometry-dockerised-solver):

- `latest` - most recent build from `main` branch
- `0.97`, `0.96`, etc. - specific astrometry.net versions
- `main` - development builds

## Versioning

This project follows a **semantic versioning scheme aligned with upstream**:

**Format:** `MAJOR.MINOR.PATCH`

- `MAJOR.MINOR` - Matches upstream astrometry.net version (e.g., `0.97`)
- `PATCH` - Increments for Dockerfile fixes/improvements

**Examples:**

- `0.97.0` - Initial build of astrometry.net 0.97
- `0.97.1` - Dockerfile optimization for 0.97
- `0.98.0` - New upstream astrometry.net 0.98 release

### Release Process

**For Dockerfile changes (patch bump):**

1. Create PR with changes
2. Title PR with `[PATCH]` prefix (or `fix:`)
3. Merge PR → auto-bumps to next patch version (e.g., `0.97.0` → `0.97.1`)

**For new upstream releases (major/minor bump):**

1. Upstream monitoring creates an issue
2. Create PR with `[MAJOR]` title and update VERSION file to `0.98.0`
3. Merge PR → creates `v0.98.0` release

**Skip release:**

- Use `[SKIP]` prefix or `docs:`/`chore:` for non-release changes

## Contributing

Issues and PRs welcome! This repo is intentionally minimal - for solver functionality, contribute upstream to [dstndstn/astrometry.net](https://github.com/dstndstn/astrometry.net).

### Building Locally

```bash
# Build default version (0.97)
docker build -t astrometry-solver .

# Build specific version
docker build --build-arg ASTROMETRY_VERSION=0.97 -t astrometry-solver:0.97 .

# Multi-arch build
docker buildx build --platform linux/amd64,linux/arm64 -t astrometry-solver .
```

### Automated Builds

This repo uses GitHub Actions for automated builds and upstream monitoring:

- **Build pipeline** (`.github/workflows/build-and-push.yml`) - Builds multi-arch images and pushes to both GHCR and DockerHub on version tags
- **Upstream monitoring** (`.github/workflows/check-upstream-release.yml`) - Runs daily to check for new astrometry.net releases and creates issues

See the [Versioning](#versioning) section for the release process.

## License

This repo carries the same license as the upstream - kept up to date 14.12.2025. Astrometry.net has it's own License - see upstream repo for details.

## Related Projects

- [astrometry.net](https://github.com/dstndstn/astrometry.net) - upstream project
- [astrometry-go-client](https://github.com/DiarmuidKelly/astrometry-go-client) - Go client for using this solver

## Acknowledgments

- [dam90/astrometry](https://github.com/dam90/astrometry) - Inspiration for the containerized approach
- Reference original DockerFile [dstndstn/astrometry.net](https://github.com/dstndstn/astrometry.net/tree/main/docker)
