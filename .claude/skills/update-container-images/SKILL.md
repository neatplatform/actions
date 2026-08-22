---
name: update-container-images
description: >
  Update pinned base image tags in this repo's Dockerfiles to the
  latest version compatible with each image's current versioning scheme.
  Use when the user asks to bump, update, upgrade, refresh, or check Docker/container
  image versions in a Dockerfile, or asks "are our images up to date" for this repo.
---

# Update Dockerfile base images

This repo only contains `Dockerfile` files, one per action under `<action-name>/Dockerfile`
(e.g. `terraform/Dockerfile`, `go-lint/Dockerfile`).
The `FROM` lines may **not** documented with a source/registry comment above them.
Resolve source and registry from the image name itself (see step 2).

Only `FROM <image>:<tag>` lines are in scope.
Leave the tools installed using the `RUN` commands.
This skill only bumps the base container image tag(s).

## 1. Find the target(s)

  - If invoked with an argument that looks like a path, scope to that file only.
  - Otherwise, find every `Dockerfile` in the repo (`find . -iname 'Dockerfile*'`)
    and confirm the list with the user before touching more than one file.
  - If an argument contains `--dry-run`, do the full analysis and report but skip step 4 (no file edits).

## 2. Parse each FROM line

For every `FROM` instruction in a Dockerfile:

  - Skip a `FROM` line whose image name matches an earlier stage's `AS <name>` alias in the same file
    (e.g. `terraform/Dockerfile` has `FROM alpine:3.24.0 AS builder` then a second, independent
    `FROM alpine:3.24.0` for the final stage — both are real base images and both get checked;
    only a line like `FROM builder AS final` referencing the alias would be skipped).
    Multi-stage builds get every real `FROM` line checked independently,
    since stages commonly pin unrelated images.
  - Resolve source repo and registry from the image name, since there is no comment to read:
    - No namespace (`alpine`, `golang`, `ruby`) → Docker Official Image,
      registry is `hub.docker.com/_/<repo>`, source is that image's own GitHub project
      (e.g. `golang` → `github.com/docker-library/golang` for the Dockerfile itself,
      but for release/changelog context prefer the upstream project, e.g. `github.com/golang/go`).
    - `<ns>/<repo>` → registry is `hub.docker.com/r/<ns>/<repo>` unless the image is otherwise
      known to live elsewhere (e.g. `ghcr.io/...`, `quay.io/...` prefix in the image name itself).
  - Parse the current tag and infer its versioning scheme:
    the prefix (`v` or none), the number of numeric segments, and any suffix already in use.
    Match that scheme exactly on the way back out:
    - `alpine:3.24.0` → bare `MAJOR.MINOR.PATCH`, no prefix, no suffix.
    - `ruby:4.0.1-alpine` → `MAJOR.MINOR.PATCH-alpine` — the new tag must keep the `-alpine` suffix,
      not jump to a bare `ruby:4.x.x` tag or a different suffix like `-slim`.
    - `golang:1.26.0` → bare `MAJOR.MINOR.PATCH`.
      Whatever suffix is already pinned — or the absence of one — must carry over unchanged.

## 3. Find the latest matching tag

Prefer querying the registry directly over scraping the human-facing web page.
Use `curl` via Bash. Registry-specific list-tags calls:

  - **Docker Hub** (`docker.io`):

    ```
    curl -s "https://hub.docker.com/v2/repositories/<ns>/<repo>/tags?page_size=100" | jq -r '.results[].name'
    ```
    Paginate via the `next` field if needed. For a Docker Official Image (unnamespaced), use
    `library` as `<ns>` (e.g. `hub.docker.com/v2/repositories/library/alpine/tags`).

  - **Quay.io**:

    ```
    curl -s "https://quay.io/api/v1/repository/<ns>/<repo>/tag/?limit=100&onlyActiveTags=true" | jq -r '.tags[].name'
    ```

  - **GHCR / GitHub Packages**: GHCR's tag-list API needs auth even for public images,
    so use the OCI Distribution v2 API anonymously:

    ```
    TOKEN=$(curl -s "https://ghcr.io/token?scope=repository:<owner>/<repo>:pull" | jq -r .token)
    curl -s -H "Authorization: Bearer $TOKEN" "https://ghcr.io/v2/<owner>/<repo>/tags/list" | jq -r '.tags[]'
    ```

  - **Fallback** (registry API unreachable, unauthenticated, or the image's source is unclear):
    use the upstream GitHub repo's tags as a proxy, since most of these projects tag releases
    matching their published image tags:

    ```
    curl -s "https://api.github.com/repos/<owner>/<repo>/tags?per_page=100" | jq -r '.[].name'
    ```

    If `GITHUB_TOKEN` is set in the environment, pass it as
    `-H "Authorization: Bearer $GITHUB_TOKEN"` to avoid the unauthenticated rate limit.

Once you have a raw tag list:

  1. Filter to tags matching the current tag's shape from step 2
     (same prefix, same number of numeric segments, same suffix, only bare tags if it doesn't).
     Exclude `latest`, `main`, `nightly`, `-rc`/`-beta` and date-stamped tags
     unless the current tag already uses that kind of suffix.
  2. Sort the survivors as semantic versions
     (numeric major.minor.patch comparison, not string sort) and take the highest.
  3. If nothing survives the filter, don't guess — leave that `FROM` line untouched and
     note it in the report as needing manual review (the upstream project may have changed its tagging scheme).

## 4. Apply the change

Edit only the tag in the `FROM` line, in place, preserving indentation,
any trailing `AS <stage>`, and the rest of the file untouched.
Don't touch the `RUN` install commands, don't reorder stages, don't "clean up" unrelated lines.

If the new major version differs from the current major version, still apply it (that's genuinely the latest),
but flag it clearly in the report below — a major bump is more likely to need other changes in the same Dockerfile
and is worth the user reading the release notes for.

## 5. Report

Finish with a table like:

| File | Stage | Old tag | New tag | Notes |
|-----|-----|-----|-----|-----|
| terraform/Dockerfile | builder (alpine) | 3.24.0 | 3.24.1 | |
| terraform/Dockerfile | final (alpine) | 3.24.0 | 3.24.1 | |
| ruby-lint/Dockerfile | (ruby) | 4.0.1-alpine | 4.0.2-alpine | |
| go-lint/Dockerfile | (golang) | 1.26.0 | 2.0.0 | **major bump** — check release notes |
| shellcheck/Dockerfile | (alpine) | 3.24.0 | 3.24.0 | already latest |

Then run `git diff` in the affected repo so the changes are visible, and stop.
Don't commit, push, or open a PR unless the user explicitly asks for that next.
