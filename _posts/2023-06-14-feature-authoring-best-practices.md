---
layout: post
title:  "Best Practices: Authoring a Dev Container Feature"
author: "@joshspicer"
authorUrl: https://github.com/joshspicer
---

Last November I wrote about the basics around [authoring a Dev Container Feature](/guide/author-a-feature). Since then, [hundreds](https://containers.dev/features) of Features have been written by the community. The flexibility of Features has enabled a wide variety of use cases, from installing a single tool to configuring a full development environment.  To that effect, many different patterns for Feature authorship have emerged, and the core team has learned a lot about what works well and what doesn't.

## Utilize the `test` command

Bundled with the `devcontainer` cli is the `devcontainer features test` command.  This command is designed to help Feature authors test their Feature in a variety of scenarios.  It is highly recommended that Feature authors use this command to test their Feature before publishing. Some docuemntation on the `test` command can be found [here](https://github.com/devcontainers/cli/blob/main/docs/features/test.md), and an example can be found in the [Feature quick start repo](https://github.com/devcontainers/feature-starter).

## Feature idempotency

The most useful Features are idempotent. This means that if a Feature is installed multiple times with different options (something that will become more common with [Feature Dependencies](https://github.com/devcontainers/spec/blob/main/proposals/feature-dependencies.md)), the Feature should be able to handle this gracefully.  This could mean a couple things:

> There is an open spec proposal for installing the same Feature twice in a given `devcontainer.json`: https://github.com/devcontainers/spec/issues/44.  While the syntax to do so in a given `devcontainer.json` is not yet defined, Feature dependencies will effectively allow for this.

For Features that install a versioned tool (eg: version x of `go` and version y of `ruby` ), a robust Feature should be able to install multiple versions of the tool.  If your tool has a version manager (java's `SDKMAN`, ruby's `rvm`) it is usually as simple as installing the version manager and then running a command to install the desired version of that tool.

For example, the [python Feature](https://github.com/devcontainers/features/blob/main/src/python/devcontainer-feature.json#L8-L22) has an option for which version of `python` to install. If the Feature is installed multiple times with different versions, a well-designed Feature should install each specified version into a separate directory. This allows the user (and subsequently installed Features) to select the correct version of `python` if they wish.

A pattern that many Features utlize successfully is writing each version of each tool to a central folder and symlinking the "active" version to a well-known location on the PATH.

To make testing for idempotency easy, [this change to the reference implementation](https://github.com/devcontainers/cli/pull/553) introduces a new mode to the `devcontainer features test` command that will attempt to install a Feature multiple times.  This is useful for testing that a Feature is idempotent, and also for testing that a Feature is able to logically juggle multiple versions of a tool.

### Adding to the $PATH

Features are free to define their own semantics for when two conflicting tools are installed.  Reasonable behavior is to update any references to an installed tool on the PATH to the assets installed from the **last executed Feature**.

> A spec proposal is open for simplifying the process of adding a path to the $PATH variable: https://github.com/devcontainers/spec/issues/251 

For example, if two python Features are installed with different versions, the Feature that was installed last should update the PATH to point to that version of `python` installed.  This ensures that the user is able to use the version of `python` that they selected, and not the version requested by an intermediately installed Feature.

## Writing your install script

> Many of the suggestions in this section may benefit from the 'Feature library'/'code reuse' proposal here https://github.com/devcontainers/spec/blob/main/proposals/features-library.md


### Detect Platform/OS

> A spec proposal is open for detecting the platform/OS and providing better warnings: https://github.com/devcontainers/spec/issues/58

Features are often designed to work on a subset of possible base images.  For example, the majority of Features in the [`devcontainers/features` repo](https://github.com/devcontainers/features) repo are designed to work broadly with debian-derived images.  The distinction is often simply due to the wide array of base images available, and the fact that many Features will use an OS-specific package manager.

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

### Detect the non-root user

Feature installation scripts are run as `root`.  In contrast, many dev containers have a `remoteUser` set (either implicitly through [image metadata](https://containers.dev/implementors/spec/#image-metadata) or directly in the `devcontainer.json`).  In a Feature's installation script, one should be mindful of the final user and account for instances where the user is not `root`.

Feature authors should take advantage of the [`_REMOTE_USER` and similar variables](https://containers.dev/implementors/features/#user-env-var)  injected by conformant implementations.

```bash

# _REMOTE_USER is passed in 
USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"

if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

# ...
# ...

# Install tool and make sure the non-root user has permission to use it
# ...
# chmod -R $USERNAME $TOOL_PATH

```

### Implement redundant paths/strategies

Most Features in [the index today](https://containers.dev/features) have some external/upstream dependency.  Very often these upstream dependencies can change (ie: versioning pattern, rotated GPG key, etc...) that may cause a Feature to fail to install.  To mitigate this, one strategy is to implement multiple paths to install a given tool (if available).  For example, a Feature that installs `go` might try to install it from the upstream package manager, and if not fall back to a GitHub release.

Writing several [scenario tests](https://github.com/devcontainers/cli/blob/main/docs/features/test.md#scenarios) will help you catch instances where a given path no longer works.  