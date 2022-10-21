---
layout: implementors
title:  "Create a Feature"
shortTitle: "Create a Feature"
author: Microsoft
index: 7
---

> Note: This section provides information on a currently active proposal. See the [Features proposal in the spec repo](https://github.com/devcontainers/spec/issues/61) for input and links to other proposed improvements.

Development container ['Features'](../features) are self-contained, shareable units of installation code and development container configuration. We [define a pattern](../features-distribution) for authoring and self-publishing Features. 

In this document, we'll outline a "quickstart" to help you get up-and-running with creating and sharing your first Feature. You may review an example along with guidance in our [devcontainers/feature-template](https://github.com/devcontainers/feature-template) repo as well. 

> Note: While this walkthrough will illustrate the use of GitHub and the GitHub Container Registry, you can use your own source control system and publish to any [OCI Artifact supporting](https://oras.land/implementors/#registries-supporting-oci-artifacts) container registry instead.

## <a href="#create-repo" name="create-repo" class="anchor"> Create a repo </a>

Start off by creating a repository to host your Feature. In this guide, we'll use a public GitHub repository. 

For the simplest getting started experience, you may use our example [feature-template](https://github.com/devcontainers/feature-template) repo. You may select the green `Use this template` button on the repo's page.

You may also [create your own repo on GitHub](https://docs.github.com/en/get-started/quickstart/create-a-repo) if you'd prefer.

## <a href="#create-folder" name="create-folder" class="anchor"> Create a folder </a>

Once you've forked the feature-template repo (or created your own), you'll want to create a folder for your Feature. You may create one within the [`src`](https://github.com/devcontainers/feature-template/tree/main/src) folder.

If you'd like to create multiple Features, you may add multiple folders within `src`.

## <a href="#add-files" name="add-files" class="anchor"> Add files </a>

At a minimum, a Feature will include a `devcontainer-feature.json` and an `install.sh` entrypoint script.

There are many possible properties for `devcontainer-feature.json`, which you may review in the [Features spec](../features#devcontainer-feature-json-properties).

Below is a hello world example `devcontainer-feature.json` and `install.sh`. You may review the [devcontainers/features](https://github.com/devcontainers/features/blob/main/src) repo for more examples.

[devcontainer-feature.json](https://github.com/devcontainers/feature-template/blob/main/src/hello/devcontainer-feature.json):

```json
{
    "name": "Hello, World!",
    "id": "hello",
    "version": "1.0.2",
    "description": "A hello world feature",
    "options": {
        "greeting": {
            "type": "string",
            "proposals": [
                "hey",
                "hello",
                "hi",
                "howdy"
            ],
            "default": "hey",
            "description": "Select a pre-made greeting, or enter your own"
        }
    }
}
```

[install.sh](https://github.com/devcontainers/feature-template/blob/main/src/hello/install.sh):

```bash
#!/bin/sh
set -e

echo "Activating feature 'hello'"

GREETING=${GREETING:-undefined}
echo "The provided greeting is: $GREETING"

cat > /usr/local/bin/hello \
<< EOF
#!/bin/sh
RED='\033[0;91m'
NC='\033[0m' # No Color
echo "\${RED}${GREETING}, \$(whoami)!\${NC}"
EOF

chmod +x /usr/local/bin/hello
```

## <a href="#publishing" name="publishing" class="anchor"> Publishing </a>

The feature-template repo contains a GitHub Action [workflow](https://github.com/devcontainers/feature-template/blob/main/.github/workflows/release.yaml) that will publish each feature to GHCR. By default, each feature will be prefixed with the `<owner/<repo>` namespace. Using the hello world example from above, it can be referenced in a `devcontainer.json` with: `ghcr.io/devcontainers/feature-template/color:1`.

> Note: You can use the `devcontainer features publish` command from the [Dev Container CLI](https://github.com/devcontainers/cli) if you are not using GitHub Actions.

The provided GitHub Action will also publish a third "metadata" package with just the namespace, eg: `ghcr.io/devcontainers/feature-template`, which is known as the Feature collection namespace.

By default, GHCR packages are marked as private. To stay within the free tier, Features need to be marked as public.

This can be done by navigating to the Feature's "package settings" page in GHCR, and setting the visibility to `public`. The URL may look something like:

```
https://github.com/users/<owner>/packages/container/<repo>%2F<featureName>/settings
```

<img alt="Changing package visibility to public" src="/img/make-package-public.png"/>

## <a href="#add-to-index" name="add-to-index" class="anchor"> Adding Features to the Index </a>

If you'd like your Features to appear in our [public index](https://containers.dev/features) so that other community members can find them, you can do the following:

* Go to [github.com/devcontainers/devcontainers.github.io](github.com/devcontainers/devcontainers.github.io), which is the GitHub repo backing [containers.dev](https://containers.dev/)
* Open a PR to modify the [collection-index.yml](https://github.com/devcontainers/devcontainers.github.io/blob/gh-pages/_data/collection-index.yml) file
* Features housed in other OCI Artifact container registries can be included as long as they can be downloaded without a login.

Feature collections are scanned to populate a Feature index on the [containers.dev site](../../features) and allow them to appear in Dev Container creation UX in [supporting tools](https://containers.dev/supporting) like [VS Code Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) and [GitHub Codespaces](https://github.com/features/codespaces).