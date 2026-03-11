# ShellCheck

A GitHub Action for linting shell scripts and surfacing potential bugs,
portability issues, and style problems using [ShellCheck](https://github.com/koalaman/shellcheck).

## Inputs

| **Input** | **Description** | **Default** |
|----|----|----|
| `path` | Path to a directory or file containing shell scripts. | `.` |

## Example Usages

Scan all shell scripts in the repository root:

```yaml
name: CI
on: [push]

jobs:
  lint:
    name: Lint Scripts
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: ShellCheck
        uses: neatplatform/actions/shellcheck@main
```

Lint all shell scripts in a specific directory:

```yaml
name: CI
on: [push]

jobs:
  lint:
    name: Lint Scripts
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: ShellCheck
        uses: neatplatform/actions/shellcheck@main
        with:
          path: ./scripts
```
