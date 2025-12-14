# Astrometry.net Dockerised Solver

A minimal, maintained Docker image for the [Astrometry.net](https://github.com/dstndstn/astrometry.net) plate solver - solver binaries only, no web app.

Built specifically for use with [astrometry-go-client](https://github.com/DiarmuidKelly/astrometry-go-client).

## Features

- **Multi-stage build** - small runtime image (~500MB vs 2GB+ with build tools)
- **Multi-arch support** - `linux/amd64` and `linux/arm64`
- **Release-aligned** - tracks upstream astrometry.net releases
- **Automated builds** - GitHub Actions builds and publishes to GHCR
- **Upstream monitoring** - auto-creates issues when new astrometry.net releases are published

## Quick Start

```bash
# Pull the latest image
docker pull ghcr.io/diarmuidkelly/astrometry-dockerised-solver:latest

# Show help
docker run --rm ghcr.io/diarmuidkelly/astrometry-dockerised-solver:latest solve-field --help

# Check version
docker run --rm ghcr.io/diarmuidkelly/astrometry-dockerised-solver:latest solve-field --version

# Solve an image (mount your index files and image directory)
docker run --rm \
  -v /path/to/index/files:/usr/local/astrometry/data:ro \
  -v /path/to/images:/data \
  ghcr.io/diarmuidkelly/astrometry-dockerised-solver:latest \
  solve-field /data/your-image.fits
```

## Usage with astrometry-go-client

This image is designed to work seamlessly with the [astrometry-go-client](https://github.com/DiarmuidKelly/astrometry-go-client):

```go
// Use the containerized solver instead of the web API
client := astrometry.NewClient(astrometry.Config{
    SolverType: astrometry.LocalDocker,
    DockerImage: "ghcr.io/diarmuidkelly/astrometry-dockerised-solver:latest",
    IndexPath: "/path/to/index/files",
})
```

## Index Files

The image includes one sample index file (`index-4119.fits`) covering ~20-30° field widths.

For complete coverage, download additional index files:

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
  ghcr.io/diarmuidkelly/astrometry-dockerised-solver:latest \
  solve-field /data/image.fits
```

## Available Tags

- `latest` - most recent build from `main` branch
- `0.97`, `0.96`, etc. - specific astrometry.net versions
- `main` - development builds

## Building Locally

```bash
# Build default version (0.97)
docker build -t astrometry-solver .

# Build specific version
docker build --build-arg ASTROMETRY_VERSION=0.97 -t astrometry-solver:0.97 .

# Multi-arch build
docker buildx build --platform linux/amd64,linux/arm64 -t astrometry-solver .
```

## Automated Builds

This repo uses GitHub Actions to:

1. **Build on push/tag** - `.github/workflows/build-and-push.yml`

   - Builds multi-arch images
   - Pushes to GHCR with appropriate tags
   - Triggered by pushes to `main` or new version tags

2. **Monitor upstream** - `.github/workflows/check-upstream-release.yml`
   - Runs daily to check for new astrometry.net releases
   - Creates GitHub issues when new versions are available
   - Provides instructions for building the new version

## Publishing a New Version

When a new astrometry.net release is published:

1. An issue will be automatically created
2. Review the upstream release notes
3. Tag and push to trigger the build:

```bash
git tag v0.98  # Use the upstream version
git push origin v0.98
```

The GitHub Action will automatically build and push the new version to GHCR.

## Supported Commands

All astrometry.net solver binaries are available:

- `solve-field` - main plate solving command
- `image2xy` - extract sources from images
- `fit-wcs` - fit WCS to xy lists
- `wcs-xy2rd`, `wcs-rd2xy` - coordinate conversions
- And more (see `/usr/local/bin/`)

## Contributing

Issues and PRs welcome! This repo is intentionally minimal - for solver functionality, contribute upstream to [dstndstn/astrometry.net](https://github.com/dstndstn/astrometry.net).

## License

This repo carries the same license as the upstream - kept up to date 14.12.2025. Astrometry.net has it's own License - see upstream repo for details.

## Related Projects

- [astrometry.net](https://github.com/dstndstn/astrometry.net) - upstream project
- [astrometry-go-client](https://github.com/DiarmuidKelly/astrometry-go-client) - Go client for using this solver

## Acknowledgments

- [Astrometry.net](https://github.com/dstndstn/astrometry.net) - The plate-solving engine
- [dam90/astrometry](https://github.com/dam90/astrometry) - Inspiration for the containerized approach
