# Terraform

A GitHub Action for running [HashiCorp Terraform](https://www.terraform.io)
commands against a Terraform project in your repository.

## Inputs

| **Input** | **Description** | **Default** |
|----|----|----|
| `path` | Path to the Terraform project directory. | `.` |

## Example Usages

Validate a Terraform project in the repository root:

```yaml
name: CI
on: [push]

jobs:
  terraform:
    name: Terraform
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Validate
        uses: neatplatform/actions/terraform@main
        with:
          args: validate
```

Validate a Terraform project in a specific directory:

```yaml
name: CI
on: [push]

jobs:
  terraform:
    name: Terraform
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Validate
        uses: neatplatform/actions/terraform@main
        with:
          path: ./project
          args: validate
```
