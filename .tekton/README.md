# Tunnel CI resource budgets

Both `tunnel-master.yaml` and `tunnel-pr.yaml` give their inline Buildah step
explicit CPU, memory, and ephemeral-storage requests and limits. These values
are provisional scheduling and containment budgets, not measured Tunnel CI
usage. No retained Tunnel PipelineRun metrics or representative local image
build measurements were available when they were selected. The image build
downloads prebuilt FRP binaries, but that alone does not establish its peak
resource use.

The `clone` task references the shared `git-clone` Task, and Tekton helper
containers are not defined here. Their coverage is pending the separate
`codex/tekton-bootstrap` shared Tasks/defaults change; this repository does
not claim those paths are bounded by these inline step settings.

## Runtime acceptance plan

After the shared Task and Operator defaults change is available and these
PipelineRuns have deployed, collect at least three successful master builds
and three successful pull-request builds. For each run, retain its PipelineRun
URL/UID and record the built revision, workload (image size/build inputs),
peak CPU and memory, ephemeral-storage use, CPU throttling, and any OOM,
eviction, or storage-pressure events. Compare observations with the configured
requests and limits, then adjust the provisional budgets if needed. Runtime
acceptance remains pending until that review is complete.
