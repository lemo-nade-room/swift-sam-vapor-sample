# syntax=docker/dockerfile:1.3

# ================================
# Build image
# ================================
FROM swift:6.2-noble AS build

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get install -y libjemalloc-dev

WORKDIR /build

RUN mkdir /staging

RUN --mount=type=bind,source=.,target=/build \
    --mount=type=cache,target=/spm-build \
    swift build -c release \
        --product App \
        --build-path /spm-build \
        --static-swift-stdlib \
        -Xlinker -ljemalloc && \
    cp "$(swift build -c release --build-path /spm-build --show-bin-path)/App" /staging


# ================================
# Run image
# ================================
FROM ubuntu:noble

COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.9.0 /lambda-adapter /opt/extensions/lambda-adapter

# Make sure all system packages are up to date, and install only essential packages.
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get -q install -y \
      libjemalloc2 \
      ca-certificates \
      tzdata \
    && rm -r /var/lib/apt/lists/*

WORKDIR /app

COPY --from=build /staging /app

EXPOSE 8080
ENTRYPOINT ["./App"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]