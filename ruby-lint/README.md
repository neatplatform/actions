# Ruby Lint

A GitHub Action for running static code analysis on Ruby code,
surfacing errors, warnings, and style issues using [RuboCop](https://rubocop.org).

## Inputs

| **Input** | **Description** | **Default** |
|----|----|----|
| `path` | Path to the directory containing `*.rb` files. | `.` |

## Example Usages

Lint all Ruby files in the repository root:

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
        uses: neatplatform/actions/ruby-lint@main
```

Useful when your Ruby code lives in a subdirectory:

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
        uses: neatplatform/actions/ruby-lint@main
        with:
          path: ./project
```

Use RuboCop's `--auto-correct` flag to automatically fix issues where possible:

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
        uses: neatplatform/actions/ruby-lint@main
        with:
          args: --auto-correct
```
