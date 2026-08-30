Purpose
Provide focused, repository-specific guidance to Copilot sessions so suggestions and edits respect build, test, and release flows for this repo.

Build / Run / Test / Lint (how to run locally)
- Dev site (Jekyll): inside the devcontainer or any environment with Ruby and Bundler installed:
  - Install gems: bundle install
  - Build & serve locally: bundle exec jekyll serve
  - Open: http://localhost:4000/containers.dev/

- YAML lint used in CI for the collection index:
  - Run locally: yamllint -c .github/lint-config.yaml _data/collection-index.yml

- Images smoke tests & helpers (images/):
  - Smoke/test script: images/.github/actions/smoke-test/test.sh <image-name> [size-threshold-gb]
  - Image linting helpers live under images/.github/linters (shellcheck, hadolint, eslint configs).

High-level architecture (big picture)
- Static website (Jekyll): root holds site pages, layouts, _data, _config.yml and publishes to GitHub Pages.
- images/ (dev container images): a sibling project with reusable Docker-based development images under images/src/*, manifests, test-projects, and CI workflows to build/publish images.
- CI: .github/workflows contains checks for linting the collection index and publish workflows. images/ contains many image-specific workflows (smoke tests, release/push workflows).

Key conventions and patterns
- Image manifests: images/src/*/manifest.json is authoritative for image versions and variant metadata. Any image change must bump manifest.json using semantic versioning.
  - Major bump: breaking changes (e.g., base OS change).
  - Minor bump: new non-breaking features.
  - Patch bump: bug/security fixes.
  - When adding a variant, update manifest.json: add variant to variants and build.architectures, update variantTags, and set build.latest to the appropriate tag unless the variant is a preview.
- README sync: when manifest or default tags change, update the image README and variant tables to match manifest.json.
- Dockerfile authoring: prefer combining steps in RUN with && and cleanup in the same RUN to reduce image layer size (see images/ README and docs/TIPS.md).
- Devcontainer usage: many images include a .devcontainer and test-project/ to validate the image via devcontainer exec; smoke-test scripts expect test-project/test.sh.
- collection-index.yml is strictly linted in CI; follow .github/lint-config.yaml rules.

Where to look for more context
- README.md at repo root for local dev/Jekyll instructions.
- images/README.md and images/src/* for image-specific guidance, manifests and test-project layouts.
- images/.github/linters and images/.github/actions for scripts and linter configs used by CI.

Notes for Copilot agents
- For edits that change an image, ensure manifest.json version bump and README update are included in the same PR.
- For changes to _data/collection-index.yml, run yamllint with .github/lint-config.yaml and aim to keep CI yamllint output clean.
- When suggesting Dockerfile changes, prefer consolidated RUN lines and avoid introducing unnecessary layers.

Files consulted while authoring these instructions
- README.md
- images/README.md
- images/.github/copilot-instructions.md
- .github/workflows/lint.yml
- .github/lint-config.yaml
- images/.github/actions/smoke-test/test.sh

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>