# Kubernetes Lint

A GitHub Action that validates and scores [Kubernetes](https://kubernetes.io) YAML manifests,
catching configuration errors and security issues before they reach your cluster.

**Supported tools:**

  - [kubeconform](https://github.com/yannh/kubeconform) — validates manifests against the Kubernetes OpenAPI schema.
  - [kube-score](https://github.com/zegl/kube-score) — scores manifests against security and best-practice checks.

Both tools are enabled by default and can be toggled independently.

## Inputs

| **Input** | **Description** | **Default** |
|----|----|----|
| `path` | Path to a directory or file containing Kubernetes YAML manifests. | `.` |
| `enable_kubeconform` | Whether to run kubeconform schema validation. | `true` |
| `enable_kubescore` | Whether to run kube-score best-practice checks. | `true` |

## Example Usages

Lint all YAML files in the repository root with both tools enabled:

```yaml
name: CI
on: [push]

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Kubernetes Lint
        uses: neatplatform/actions/k8s-lint@main
```

Lint all YAML files in a specific directory with both tools enabled:

```yaml
name: CI
on: [push]

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Kubernetes Lint
        uses: neatplatform/actions/k8s-lint@main
        with:
          path: ./manifests
```

Run kube-score only (skip kubeconform):

```yaml
name: CI
on: [push]

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Kubernetes Lint
        uses: neatplatform/actions/k8s-lint@main
        with:
          enable_kubeconform: 'false'
```

Run kubeconform only (skip kube-score)

```yaml
name: CI
on: [push]

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Kubernetes Lint
        uses: gardenbed/actions/k8s-lint@main
        with:
          enable_kubescore: 'false'
```
