# Multi-stage build for Astrometry.net solver (no web app)
# Build args for version pinning
ARG ASTROMETRY_VERSION=0.97
ARG UBUNTU_VERSION=24.04

###################
# Builder Stage
###################
FROM ubuntu:${UBUNTU_VERSION} AS builder

ARG ASTROMETRY_VERSION

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt -y update && apt install -y apt-utils && \
    apt install -y --no-install-recommends \
    build-essential \
    make \
    gcc \
    git \
    file \
    pkg-config \
    wget \
    curl \
    swig \
    netpbm \
    libnetpbm-dev \
    wcslib-dev \
    wcslib-tools \
    zlib1g-dev \
    libbz2-dev \
    libcairo2-dev \
    libcfitsio-dev \
    libcfitsio-bin \
    libgsl-dev \
    libjpeg-dev \
    libpng-dev \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    python3-pil \
    python3-numpy \
    python3-scipy \
    python3-matplotlib \
    python3-fitsio \
    python3-astropy \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Help astrometry.net find netpbm
RUN ln -s /usr/include /usr/local/include/netpbm

# python = python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# Set PYTHONPATH for astrometry libraries
ENV PYTHONPATH=/usr/local/lib/python

# Build directory
RUN mkdir /src
WORKDIR /src

# Clone and build specific version
RUN git clone --depth 1 --branch ${ASTROMETRY_VERSION} https://github.com/dstndstn/astrometry.net.git astrometry || \
    git clone https://github.com/dstndstn/astrometry.net.git astrometry

WORKDIR /src/astrometry

# Build astrometry.net (using GCC defaults for maximum portability)
RUN make -j$(nproc) && \
    make py -j$(nproc) && \
    make extra -j$(nproc) && \
    make install INSTALL_DIR=/usr/local

###################
# Runtime Stage
###################
FROM ubuntu:${UBUNTU_VERSION} AS runtime

ENV DEBIAN_FRONTEND=noninteractive

# Install only runtime dependencies (no build tools)
RUN apt -y update && \
    apt install -y --no-install-recommends \
    wget \
    curl \
    ca-certificates \
    netpbm \
    wcslib-tools \
    libcairo2 \
    libcfitsio-bin \
    libgsl27 \
    libjpeg-turbo8 \
    libpng16-16 \
    python3 \
    python3-pil \
    python3-numpy \
    python3-scipy \
    python3-matplotlib \
    python3-fitsio \
    python3-astropy \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# python = python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# Set PYTHONPATH
ENV PYTHONPATH=/usr/local/lib/python

# Copy built artifacts from builder
COPY --from=builder /usr/local /usr/local

# Create data directory for index files (compatible with dm90/astrometry path)
RUN mkdir -p /usr/local/astrometry/data

# Download one sample index file (covers ~20-30 degree field width)
# Users can mount more index files as needed
RUN cd /usr/local/astrometry/data && \
    wget -nv https://data.astrometry.net/4100/index-4119.fits

# Set working directory
WORKDIR /data

# Health check - verify solve-field is available
RUN solve-field --help > /dev/null 2>&1

# Default command shows usage (compatible with dm90/astrometry for drop-in replacement)
CMD ["solve-field", "--help"]
