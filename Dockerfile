FROM debian:bookworm-20250407-slim

# Set version as build arg (optional override for later updates)
ARG FRP_VERSION=0.62.0
ENV FRP_VERSION=${FRP_VERSION}

# Set working directory
WORKDIR /opt

# Download and extract the Linux AMD64 release
RUN apt-get update && apt-get install -y --no-install-recommends curl tar ca-certificates \
  && curl -L -o frp.tar.gz https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz \
  && tar -xzf frp.tar.gz --strip-components=1 \
  && chmod +x /opt/frps /opt/frpc \
  && rm frp.tar.gz \
  && apt-get purge -y curl tar && apt-get autoremove -y && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# By default run frps, override in Kubernetes if needed
ENTRYPOINT ["/opt/frps"]
