---
layout: implementors
title:  "How to contribute to the Development Container Specification"
shortTitle: "Contributing"
author: Microsoft
index: 8
---

We're excited for your contributions to the Dev Container Specification! This document outlines how you can get involved. 

## <a href="#contribution-approaches" name="contribution-approaches" class="anchor"> Contribution approaches </a>

- Propose the change via an [issue](https://github.com/devcontainers/spec/issues) in the [spec repo](https://github.com/devcontainers/spec). Try to get early feedback before spending too much effort formalizing it.
- More formally document the proposed change in terms of properties and their semantics. Look to format your proposal like our [devcontainer.json reference](../json_reference), which is a JSON with Comments (jsonc) format.

Here is a sample proposal:

| Property | Type  | Description |
|:------------------|:------------|:------------|
| `image`    | string      | **Required** when using an image. The name of an image in a container registry ([DockerHub](https://hub.docker.com), [GitHub Container Registry](https://docs.github.com/packages/guides/about-github-container-registry), [Azure Container Registry](https://azure.microsoft.com/services/container-registry/)) that VS Code and other `devcontainer.json` supporting services / tools should use to create the dev container. |
{: .table .table-bordered .table-responsive}

- PRs to the [schema](https://github.com/microsoft/vscode/blob/main/extensions/configuration-editing/schemas/devContainer.schema.src.json), i.e code or shell scripts demonstrating approaches for implementation.

Once there is discussion on your proposal, please also open and link a PR to update the [devcontainer.json reference doc](https://aka.ms/devcontainer.json). When your proposal is merged, the docs will be kept up-to-date with the latest spec.

### <a href="#tool-specific-support" name="tool-specific-support" class="anchor"> Contributing tool-specific support </a>

Tool-specific properties are contained in namespaces in the `"customizations"` property. For instance, VS Code specific properties are formated as:

```bash
// Configure tool-specific properties.
"customizations": {
     // Configure properties specific to VS Code.
     "vscode": {
          // Set *default* container specific settings.json values on container create.
          "settings": {},
			
          // Additional VS Code specific properties...
     }
},
```

You may propose adding a new namespace for a specific tool, and any properties specific to that tool.

## <a href="#review-process" name="review-process" class="anchor"> Review process </a>

We use the following [labels](https://github.com/devcontainers/spec/labels) in the spec repo:

- `proposal`: Issues under discussion, still collecting feedback.
- `finalization`: Proposals we intend to make part of the spec.

[Milestones](https://github.com/devcontainers/spec/milestones) use a "month year" pattern (i.e. January 2022). If a finalized proposal is added to a milestone, it is intended to be merged during that milestone.
