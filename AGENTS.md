# FRP Tunnel Agent Guide

## Purpose

Docker image packaging [FRP (Fast Reverse Proxy)](https://github.com/fatedier/frp) for deployment in Kubernetes clusters. Used to create tunnels from k3s clusters to on-prem instances. CI publishes to `harbor.harokilabs.com/staging/tunnel`; README examples use `harbor.harokilabs.com/infra/frp` for manual/local builds.

## Stack

- Docker (Debian trixie-slim base)
- FRP v0.69.1 (server + client binaries)
- Harbor registry for image distribution
- Kubernetes for deployment (ConfigMaps for runtime config)
- Pipelines-as-Code (PaC) for CI — in-repo `.tekton/` PipelineRuns

## Repo Map

- `Dockerfile` — single-stage build that downloads FRP release binaries
- `README.md` — usage docs, build/push instructions, k8s deployment notes
- `.tekton/tunnel-master.yaml` — PaC PipelineRun for pushes to master (builds + pushes image)
- `.tekton/tunnel-pr.yaml` — PaC PipelineRun for pull requests (builds + pushes image tagged `pr-<number>`)

## Commands

### Build image

```bash
docker build --platform=linux/amd64 -t harbor.harokilabs.com/infra/frp:0.69.1 .
```

### Build with custom FRP version

```bash
docker build --platform=linux/amd64 --build-arg FRP_VERSION=0.69.2 -t harbor.harokilabs.com/infra/frp:0.69.2 .
```

### Push to Harbor

```bash
docker push harbor.harokilabs.com/infra/frp:<version>
```

## Runtime Behavior You Must Preserve

- Image contains both `frps` (server) and `frpc` (client) at `/opt/`
- Default entrypoint is `frps` — client usage overrides entrypoint to `/opt/frpc`
- **No config or secrets baked into the image** — always supplied at runtime via volumes or ConfigMaps
- Dependencies installed during build are cleaned up to keep the image minimal

## Netcup Deploy

- `ENV=staging`: ArgoCD app `tunnel-server`, netcup-apps branch `codex/tunnel-server`, path `chart`, release `tunnel-server`, namespace `tunnel`; verified from live ArgoCD app and netcup-apps branch on 2026-06-26.
- Image reference lives in `netcup-apps` branch `codex/tunnel-server` at `chart/values.yaml` under `tunnelDeployments.deployments[].spec.template.spec.containers[].image`.
- CI publishes deployable images to `harbor.harokilabs.com/staging/tunnel:<full-commit-sha>` on tunnel `master` pushes; prefer immutable SHA tags for GitOps deploys.

## Editing Rules

- Keep the Dockerfile single-stage and minimal
- Use Debian stable slim base unless a pinned dated image is required for reproducibility
- Build local images with `--platform=linux/amd64`; Dockerfile downloads `linux_amd64` FRP assets
- Always clean up apt lists and temp files in the same RUN layer
- Use `--no-install-recommends` for apt packages
- When bumping FRP version: update the `ARG FRP_VERSION` default, image tags in README, and all example commands

## Commit Style

- Conventional commits with scope: `docker:`, `readme:`, `k8s:`, `ci:`
- Lowercase descriptions: `docker: bump frp to 0.69.1`
