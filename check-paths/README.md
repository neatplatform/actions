# Check Paths

A GitHub Action for detecting whether files matching the given glob patterns changed between two git revisions.

It supports `push`, `pull_request`, and `merge_group` events.

## Inputs

| **Input** | **Description** | **Default** |
|----|----|----|
| `paths` | A newline-separated list of glob patterns to check for changes.<br/>Each pattern is passed to `git diff --name-only -- <pattern>`. | |

## Outputs

| **Output** | **Description** |
|----|----|
| `changed` | `true` if any files matching the given glob patterns changed between the two commits, `false` otherwise. |
| `changed_files` | A newline-separated list of files that changed and matched at least one of the provided glob patterns.<br>Empty string if no files matched. |
| `base_sha` | The base commit SHA used for the diff. |
| `head_sha` | The head commit SHA used for the diff. |

## Example Usages

### Conditional job execution

Skip a job entirely when no relevant files have changed:

```yaml
name: CI
on: [push]

jobs:
  check-paths:
    runs-on: ubuntu-latest
    outputs:
      changed: ${{ steps.check.outputs.changed }}
    steps:
      - uses: actions/checkout@v6
        with:
          fetch-depth: 0
      - uses: neatplatform/actions/check-paths@main
        id: check
        with:
          paths: |
            src/**
            package.json
            package-lock.json

  build:
    needs: check-paths
    if: needs.check-paths.outputs.changed == 'true'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Source changed, running build ..."
```

### Inspecting the changed files

Access the list of matched files in a downstream step:

```yaml
name: CI
on: [push]

jobs:
  inspect:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
        with:
          fetch-depth: 0
      - uses: neatplatform/actions/check-paths@main
        id: check
        with:
          paths: |
            terraform/**
      - if: steps.check.outputs.changed == 'true'
        run: |
          echo "Changed files:"
          echo "${{ steps.check.outputs.changed_files }}"
```

### Multiple independent path checks

Run separate checks for different parts of the codebase:

```yaml
name: CI
on: [push]

jobs:
  check-paths:
    runs-on: ubuntu-latest
    outputs:
      first-service-changed: ${{ steps.first-service.outputs.changed }}
      second-service-changed: ${{ steps.second-service.outputs.changed }}
    steps:
      - uses: actions/checkout@v6
        with:
          fetch-depth: 0
      - uses: neatplatform/actions/check-paths@main
        id: first-service
        with:
          paths: |
            first-service/**
      - uses: neatplatform/actions/check-paths@main
        id: second-service
        with:
          paths: |
            second-service/**

  build-first-service:
    needs: check-paths
    if: needs.check-paths.outputs.first-service-changed == 'true'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building first-service ..."

  build-second-service:
    needs: check-paths
    if: needs.check-paths.outputs.second-service-changed == 'true'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building second-service ..."
```
