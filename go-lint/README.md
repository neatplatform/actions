# Go Lint

A GitHub Action for running static code analysis on Go code, surfacing errors,
warnings, and style issues using [GolangCI-Lint](https://golangci-lint.run).

This action wraps `golangci-lint` to integrate seamlessly into your CI pipeline. By default, it runs:

    golangci-lint run --new --deadline=5m

You can override these defaults using the `args` input.

## Inputs

| **Input** | **Description** | **Default** |
|----|----|----|
| `path` | Path to the directory containing `*.go` files. | `.` |
| `timeout` | Maximum time allowed for the lint run. | `5m` |
| `from_revision` | If set, only lines added or changed since this git revision will be checked. | `origin/main` |

## Example Usages

Lint all Go files in the repository root on every push:

```yaml
name: CI
on: [push]

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Lint
        uses: neatplatform/actions/go-lint@main
```

Useful when your Go code lives in a subdirectory:

```yaml
name: CI
on: [push]

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Lint
        uses: neatplatform/actions/go-lint@main
        with:
          path: ./project
```

Override the default `golangci-lint` arguments entirely:

```yaml
name: CI
on: [push]

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Lint
        uses: neatplatform/actions/go-lint@main
        with:
          args: run ./project
```

Check only the lines changed since `origin/main`, ideal for pull request workflows:

```yaml
name: PR
on: [pull_request]

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
        with:
          fetch-depth: 0
      - name: Lint
        uses: neatplatform/actions/go-lint@main
        with:
          from_revision: origin/main
```
