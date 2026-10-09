# CI resource review status

This branch adds explicit resource budgets to the repository-owned build path. Sizing remains provisional until representative Tekton runs are measured.



2026-10-09 API review correction: Tekton v1 Step budgets use `computeResources`;
PVC storage keeps its Kubernetes `resources` field. The installed Task v1
Step schema rejected the previous Step key and accepts the corrected definitions.
Budgets remain provisional pending controlled runtime sampling. [skip tkn]

2026-10-09 node-capacity review: replace provisional 8Gi per-step memory limits with 4Gi. Each general node has only about 7.75Gi allocatable RAM; an 8Gi limit cannot contain a single build before node exhaustion. Keep requests, CPU and storage budgets unchanged. This interim ceiling has headroom over the representative observed Go/Buildah footprints; application-specific sizing remains pending, and these observations do not prove other build paths. Preserve existing lower bounds where already specified. [skip tkn]

2026-10-09 full v1 PipelineRun API check: preserve the configured CI service account under spec.taskRunTemplate.serviceAccountName. The legacy spec.serviceAccountName field is not part of the installed v1 schema. Complete PipelineRun specs now validate against the installed API, in addition to the strict Step resource check. [skip tkn]

Release update (2026-10-09): PaC v0.51.0 and all fourteen repository caps are live. Complete PipelineRun specs and inline Step budgets passed installed Tekton v1 schemas; resource keys are computeResources and service accounts use taskRunTemplate. These are interim containment budgets. Representative Go, frontend and Buildah classes passed in Amauta; this does not establish sizing or successful application tests for other repositories. CPU throttling was observed and ephemeral-storage peaks remain unavailable. Per-path runtime sizing stays pending after rollout.

Automatic publication uses [skip tkn] to avoid a build burst. A skipped status is not a passing test. Application-specific budgets precede shared remote-clone/helper defaults in netcup-apps #153. Pipeline triggers and security gates remain enabled.
