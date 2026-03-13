# Go Test

A GitHub Action that runs `go test`, generates coverage reports,
and optionally uploads them to third-party coverage services.

**Supported coverage services:**

  - [Codecov](https://codecov.io)
  - [Code Climate](https://codeclimate.com)

## Inputs

| **Input** | **Description** | **Default** |
|----|----|----|
| `path` | Path to the directory containing `*.go` and `*_test.go` files. | `.` |
| `timeout` | Maximum time allowed for the tests to run. | `10m` |
| `codecov_token` | If set, uploads the coverage report to [Codecov](https://codecov.io). | |
| `codeclimate_reporter_id` | If set, uploads the coverage report to [Code Climate](https://codeclimate.com). | |

## Outputs

| **Output** | **Description** |
|----|----|
| `coverage_profile_file` | Path to the machine-readable coverage profile. |
| `coverage_report_file` | Path to the human-readable coverage report. |

## Example Usages

Run tests and generate a coverage report:

```yaml
name: CI
on: [push]

jobs:
  test:
    name: Test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Test
        uses: neatplatform/actions/go-test@main
```

Run tests, generate a coverage report, an upload it to Codecov:

```yaml
name: CI
on: [push]

jobs:
  test:
    name: Test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Test
        uses: neatplatform/actions/go-test@main
        with:
          codecov_token: ${{ secrets.CODECOV_TOKEN }}
```

Run tests, generate a coverage report, an upload it to Code Climate:

```yaml
name: CI
on: [push]

jobs:
  test:
    name: Test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Test
        uses: neatplatform/actions/go-test@main
        with:
          codeclimate_reporter_id: ${{ secrets.CODECLIMATE_REPORTER_ID }}
```

### Archive the coverage report as a CI artifact

Use the `coverage_report_file` output to upload the human-readable report for later inspection:

```yaml
name: CI
on: [push]

jobs:
  test:
    name: Test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - name: Test
        id: test
        uses: neatplatform/actions/go-test@main
      - name: Upload Coverage Report
        uses: actions/upload-artifact@v7
        with:
          name: coverage-report
          path: ${{ steps.test.outputs.coverage_report_file }}
```
