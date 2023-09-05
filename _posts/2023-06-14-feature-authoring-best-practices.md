---
layout: post
title:  "Best Practices: Authoring a Dev Container Feature"
author:
  - "@joshspicer"
authorUrl:
  - https://github.com/joshspicer
---

Last November I wrote about the basics around [authoring a Dev Container Feature](/guide/author-a-feature). Since then, [hundreds](https://containers.dev/features) of Features have been written by the community. The flexibility of Features has enabled a wide variety of use cases, from installing a single tool to setting up specific aspects of a project's development environment that can be shared across repositories.  To that effect, many different patterns for Feature authorship have emerged, and the core team has learned a lot about what works well and what doesn't.

## Utilize the `test` command

Bundled with the [devcontainer cli](https://github.com/devcontainers/cli) is the `devcontainer features test` command.  This command is designed to help Feature authors test their Feature in a variety of scenarios.  It is highly recommended that Feature authors use this command to test their Feature before publishing. Some documentation on the `test` command can be found [here](https://github.com/devcontainers/cli/blob/main/docs/features/test.md), and an example can be found in the [Feature quick start repo](https://github.com/devcontainers/feature-starter). This repo is updated periodically as new functionality is added to the reference implementation.

## Feature idempotency

The most useful Features are idempotent. This means that if a Feature is installed multiple times with different options (something that will come into play with [Feature Dependencies](https://github.com/devcontainers/spec/blob/main/proposals/feature-dependencies.md)), the Feature should be able to handle this gracefully. This is especially important for option-rich Features that you anticipate others may depend on in the future.

> 🔧 There is an open spec proposal for installing the same Feature twice in a given `devcontainer.json` [(devcontainers/spec#44)](https://github.com/devcontainers/spec/issues/44).  While the syntax to do so in a given `devcontainer.json` is not yet defined, Feature dependencies will effectively allow for this.

For Features that install a versioned tool (eg: version x of `go` and version y of `ruby` ), a robust Feature should be able to install multiple versions of the tool.  If your tool has a version manager (java's `SDKMAN`, ruby's `rvm`) it is usually as simple as installing the version manager and then running a command to install the desired version of that tool.

For instances where there isn't an existing version manager available, a well-designed Feature should consider installing distict versions of itself to a well known location.  A pattern that many Features utilize successfully is writing each version of each tool to a central folder and symlinking the "active" version to a folder on the PATH.

Features can redefine the PATH variable with `containerEnv`, like so:

```bash
# devcontainer-feature.json
"containerEnv": {
    "PATH": "/usr/local/myTool/bin:${PATH}"
}
```

> 🔧 A spec proposal is open for simplifying the process of adding a path to the $PATH variable: [(devcontainers/spec#251)](https://github.com/devcontainers/spec/issues/251).

To make testing for idempotency easy, [this change to the reference implementation](https://github.com/devcontainers/cli/pull/553) introduces a new mode to the `devcontainer features test` command that will attempt to install a Feature multiple times.  This is useful for testing that a Feature is idempotent, and also for testing that a Feature is able to logically "juggle" multiple versions of a tool.

## Writing your install script


> 🔧 Many of the suggestions in this section may benefit from the [Feature library/code reuse proposal](https://github.com/devcontainers/spec/blob/main/proposals/features-library.md).

This section includes some tips for the contents of the `install.sh` entrypoint script.

### Detect Platform/OS

> 🔧 A spec proposal is open for detecting the platform/OS and providing better warnings [(devcontainers/spec#58)](https://github.com/devcontainers/spec/issues/58).

Features are often designed to work on a subset of possible base images.  For example, the majority of Features in the [`devcontainers/features`](https://github.com/devcontainers/features) repo are designed to work broadly with debian-derived images.  The limitation is often simply due to the wide array of base images available, and the fact that many Features will use an OS-specific package manager.  To make it easy for users to understand which base images a Feature is designed to work with, it is recommended that Features include a check for the OS and provide a helpful error message if the OS is not supported.

One possible way to implement this check is shown below.

```bash
# Source /etc/os-release to get OS info
# Looks something like:
#     PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
#     NAME="Debian GNU/Linux"
#     VERSION_ID="11"
#     VERSION="11 (bullseye)"
#     VERSION_CODENAME=bullseye
#     ID=debian
#     HOME_URL="https://www.debian.org/"
#     SUPPORT_URL="https://www.debian.org/support"
#     BUG_REPORT_URL="https://bugs.debian.org/"
. /etc/os-release
# Store host architecture
architecture="$(dpkg --print-architecture)"

DOCKER_MOBY_ARCHIVE_VERSION_CODENAMES="buster bullseye focal bionic xenial"
if [[ "${DOCKER_MOBY_ARCHIVE_VERSION_CODENAMES}" != *"${VERSION_CODENAME}"* ]]; then
    print_error "Unsupported  distribution version '${VERSION_CODENAME}'. To resolve, either: (1) set feature option '\"moby\": false' , or (2) choose a compatible OS distribution"
    print_error "Supported distributions include:  ${DOCKER_MOBY_ARCHIVE_VERSION_CODENAMES}"
    exit 1
fi
```

If you are targeting distros that may not have your desired scripting language installed (eg: `bash` is often not installed on `alpine` images), you can either use plain `/bin/sh` - which is available virtually everywhere - or you can verify (and install) the scripting language in a small bootstrap script as shown below.

```sh
#!/bin/sh 

# ... 
# ...

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# If we're using Alpine, install bash before executing
. /etc/os-release
if [ "${ID}" = "alpine" ]; then
    apk add --no-cache bash
fi

exec /bin/bash "$(dirname $0)/main.sh" "$@"
exit $?
```

Validating functionality against several base images can be done by using the `devcontainer features test` command with the `--base-image` flag, or with a [scenario](https://github.com/devcontainers/cli/blob/main/docs/features/test.md#scenarios).  For example,  one could add a [workflow like this to their repo](https://github.com/devcontainers/features/blob/d934503a050ba84e6b42a006aacd891c4088eb62/.github/workflows/test-all.yaml#L9-L52).

```yaml
name: "Test Features matrixed with a set of base images"
on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest
    continue-on-error: true
    strategy:
      matrix:
        features: [
            "anaconda",
            "aws-cli",
            "azure-cli",
            # ...
        ]
        baseImage:
          [
            "ubuntu:bionic",
            "ubuntu:focal",
            "ubuntu:jammy",
            "debian:11",
            "debian:12",
            "mcr.microsoft.com/devcontainers/base:ubuntu",
            "mcr.microsoft.com/devcontainers/base:debian",
          ]
    steps:
      - uses: actions/checkout@v3

      - name: "Install latest devcontainer CLI"
        run: npm install -g @devcontainers/cli
        {% raw %}
      - name: "Generating tests for '${{ matrix.features }}' against '${{ matrix.baseImage }}'"
        run: devcontainer features test  --skip-scenarios -f ${{ matrix.features }} -i ${{ matrix.baseImage }}
        {% endraw %} 
```

### Detect the non-root user

Feature installation scripts are run as `root`.  In contrast, many dev containers have a `remoteUser` set (either implicitly through [image metadata](https://containers.dev/implementors/spec/#image-metadata) or directly in the `devcontainer.json`).  In a Feature's installation script, one should be mindful of the final user and account for instances where the user is not `root`.

Feature authors should take advantage of the [`_REMOTE_USER` and similar variables](https://containers.dev/implementors/features/#user-env-var) injected during the build.

```bash
# Install tool in effective remoteUser's bin folder
mkdir -p "$_REMOTE_USER_HOME/bin"
curl $TOOL_DOWNLOAD_LINK -o "$_REMOTE_USER_HOME/bin/$TOOL"
chown $_REMOTE_USER:$_REMOTE_USER "$_REMOTE_USER_HOME/bin/$TOOL"
chmod 755 "$_REMOTE_USER_HOME/bin/$TOOL"
```

### Implement redundant paths/strategies

Most Features in [the index today](https://containers.dev/features) have some external/upstream dependency.  Very often these upstream dependencies can change (ie: versioning pattern, rotated GPG key, etc...) that may cause a Feature to fail to install.  To mitigate this, one strategy is to implement multiple paths to install a given tool (if available).  For example, a Feature that installs `go` might try to install it from the upstream package manager, and if not fall back to a GitHub release.

Writing several [scenario tests](https://github.com/devcontainers/cli/blob/main/docs/features/test.md#scenarios) that force the Feature to go down distinct installation paths will help you catch cases where a given path no longer works.