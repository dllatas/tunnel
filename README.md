# FRP docker

Docker image for [FRP (Fast Reverse Proxy)](https://github.com/fatedier/frp)
Built for deployment in Kubernetes or local environments.

This image includes both `frps` (server) and `frpc` (client),
and is designed to be flexible, minimal, and production-ready.
The config is **not baked in** — you supply it at runtime
via volumes or Kubernetes ConfigMaps.

## Usage

### Run `frps` (server)

```bash
docker run --rm -v $(pwd)/frps.toml:/etc/frp/frps.toml \
  harbor.harokilabs.com/infra/frp:0.62.0 \
  -c /etc/frp/frps.toml
```

### Run `frpc` (client)

```bash
docker run --rm -v $(pwd)/frpc.toml:/etc/frp/frpc.toml \
  harbor.harokilabs.com/infra/frp:0.62.0 \
  /opt/frpc -c /etc/frp/frpc.toml
```

## Building the Image

> Requires Docker and internet access to GitHub.

```bash
docker build -t harbor.harokilabs.com/infra/frp:0.62.0 .
```

### Push to Harbor

```bash
docker login harbor.harokilabs.com
docker push harbor.harokilabs.com/infra/frp:0.62.0
```

## Included Tools

| Tool   | Path       | Description    |
|--------|------------|----------------|
| `frps` | `/opt/frps` | FRP Server     |
| `frpc` | `/opt/frpc` | FRP Client     |

## 🛠️ Kubernetes Deployment

This image is intended to be used with:

- A `ConfigMap` for the `.toml` config
- A `Deployment` (for frps) or `DaemonSet`/`Pod` (for frpc)

Override the entrypoint with:

```yaml
args: ["-c", "/etc/frp/frps.toml"]
```

## Resources

- [FRP GitHub](https://github.com/fatedier/frp)
- [FRP Config Reference](https://github.com/fatedier/frp/blob/dev/conf/frps_full.toml)
- [Releases](https://github.com/fatedier/frp/releases)

## 🔐 Security

- No config or secrets are baked into the image.
- Use secrets/configmaps to pass configuration at runtime.
- Keep your `frps` token secure!
