---
layout: post
title:  "Authoring a Dev Container Feature"
author: "@joshspicer"
authorUrl: https://github.com/joshspicer
---

When [creating a Dev Container Feature](https://containers.dev/guide/author-a-feature), the author is free to publish their Features to any container registry that implements the [Artifacts Specification](https://github.com/opencontainers/artifacts) (more info on that can be found from the [oras project](https://oras.land/implementors/))!

[Reference implementation Features](https://github.com/devcontainers/features) and the [starter template](https://github.com/devcontainers/features-starter) both publish to the GitHub Container Registry (GHCR).  


This guide will share some tip for publishing to, and consuming from, the Azure Container Registry.

## Creating your Azure CR


## Anonymous Access

To enable anonymous access (and unlock the ability to register your collection on our [index](https://containers.dev/features)), you'll want to run the following with the Azure CLI.

```bash
az acr update --name myregistry --anonymous-pull-enabled
```

More information can be found in the [container registry docs](https://learn.microsoft.com/en-us/azure/container-registry/anonymous-pull-access).

## Logging in

`az acr login -n devcontainercli`