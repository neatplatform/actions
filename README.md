# actions

A monorepo containing all shared GitHub Actions used across the organization.

## CI Checks

CI checks run on `pull_request` and `merge_queue` events, but only when the target branch is `main`.

**Why not on push to main?**

This repo uses merge queue, so all PRs land on `main` through the queue — running checks at that point would be redundant.

**Why not on other branches?**

Branches not targeting `main` skip CI checks entirely to reduce unnecessary runner usage.

## Resources

  - **Actions & Workflows**
    - [Metadata syntax reference](https://docs.github.com/en/actions/reference/workflows-and-actions/metadata-syntax)
    - [Workflow syntax for GitHub Actions](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax)
    - [Workflow commands for GitHub Actions](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands)
    - [Variables reference](https://docs.github.com/en/actions/reference/workflows-and-actions/variables)
    - [Contexts reference](https://docs.github.com/en/actions/reference/workflows-and-actions/contexts)
    - [Running variations of jobs in a workflow](https://docs.github.com/en/enterprise-server@3.19/actions/how-tos/write-workflows/choose-what-workflows-do/run-job-variations)
    - [Reuse workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)
    - [Reusing workflow configurations](https://docs.github.com/en/actions/reference/workflows-and-actions/reusing-workflow-configurations)
  - **CodeQL**
    - [Code scanning](https://docs.github.com/en/code-security/concepts/code-scanning)
    - [Workflow configuration options for code scanning](https://docs.github.com/en/code-security/reference/code-scanning/workflow-configuration-options)
    - [CodeQL code scanning for compiled languages](https://docs.github.com/en/code-security/how-tos/scan-code-for-vulnerabilities/manage-your-configuration/codeql-code-scanning-for-compiled-languages)
  - **Misc**
    - [OCI Image Format Specification](https://github.com/opencontainers/image-spec)
