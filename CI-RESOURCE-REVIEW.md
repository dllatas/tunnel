# CI resource review status

This branch adds explicit resource budgets to the repository-owned build path. The sizing remains provisional until representative Tekton runs are measured after cluster recovery.

Review validation: `git diff --check $(git merge-base origin/HEAD HEAD)..HEAD` passes locally. Tekton execution is intentionally deferred while cluster Kubernetes API reads are failing. A skipped or neutral PaC status is not a successful test. Before merge or rollout acceptance, run the repository pipeline individually and record duration, per-container CPU, memory and ephemeral-storage peaks, throttling, OOM/eviction and scheduling outcomes; revise budgets if measurements require it.

The final documentation commit carries `[skip tkn]` to defer this PR's automatic build. Pipeline definitions, trigger matching and security gates remain enabled.

2026-10-09 API review correction: Tekton v1 Step budgets use `computeResources`;
PVC storage keeps its Kubernetes `resources` field. The installed Task v1
Step schema rejected the previous Step key and accepts the corrected definitions.
Budgets remain provisional pending controlled runtime sampling. [skip tkn]

2026-10-09 node-capacity review: replace provisional 8Gi per-step memory limits with 4Gi. Each general node has only about 7.75Gi allocatable RAM; an 8Gi limit cannot contain a single build before node exhaustion. Keep requests, CPU and storage budgets unchanged. This interim ceiling has headroom over the representative observed Go/Buildah footprints; application-specific sizing remains pending, and these observations do not prove other build paths. Preserve existing lower bounds where already specified. [skip tkn]
