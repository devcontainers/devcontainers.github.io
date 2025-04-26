---
layout: implementors
title:  "How to contribute to the Development Container Specification"
shortTitle: "Contributing"
author: Microsoft
index: 9
---

We're excited for your contributions to the Dev Container Specification! This document outlines how you can get involved. We also welcome you to join our [community Slack channel](https://aka.ms/dev-container-community).

## <a href="#contribution-approaches" name="contribution-approaches" class="anchor"> Spec Contribution approaches </a>

If you'd like to contribute a change or addition to the spec, you may follow the guidance below:
- Propose the change via an [issue](https://github.com/devcontainers/spec/issues) in this repository. Try to get early feedback before spending too much effort formalizing it.
- More formally document the proposed change in terms of properties and their semantics. Look to format your proposal like our [devcontainer.json reference](https://aka.ms/devcontainer.json).

Here is a sample:

| Property | Type  | Description |
|:------------------|:------------|:------------|
| `image`    | string      | **Required** when using an image. The name of an image in a container registry ([DockerHub](https://hub.docker.com), [GitHub Container Registry](https://docs.github.com/packages/guides/about-github-container-registry), [Azure Container Registry](https://azure.microsoft.com/services/container-registry/)) that VS Code and other `devcontainer.json` supporting services / tools should use to create the dev container. |
{: .table .table-bordered}

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

### <a href="#formatting-guidelines" name="formatting-guidelines" class="anchor"> Formatting Guidelines </a>

When contributing an official doc or referencing dev containers in your projects, please consider the following guidelines:

- Refer to the spec as the "Development Container Specification"
     - All capital letters
     - Singular "Container" rather than plural "Containers"
- The term "dev container" shouldn't be capitalized on its own
     - It should only be capitalized when referring to an official tool title, like the VS Code Dev Containers extension 
- Signify `devcontainer.json` is a file type through backticks 
- Features and Templates should always be capitalized
- Refer to the CLI as the "Dev Container CLI" (note the caps)
- Use bolding for emphasis sprinkled throughout sections, rather than try to use it to always bold certain terms

## <a href="#review-process" name="review-process" class="anchor"> Review process </a>

We use the following [labels](https://github.com/devcontainers/spec/labels) in the spec repo:

- `proposal`: Issues under discussion, still collecting feedback.
- `finalization`: Proposals we intend to make part of the spec.

[Milestones](https://github.com/devcontainers/spec/milestones) use a "month year" pattern (i.e. January 2022). If a finalized proposal is added to a milestone, it is intended to be merged during that milestone.

## <a href="#community-engagement" name="community-engagement" class="anchor"> Community Engagement </a>

There are several additional options to engage with the dev container community, such as asking questions, providing feedback, or engaging on how your team may use or contribute to dev containers:
- [GitHub Discussions](https://github.com/devcontainers/spec/discussions): This is a great opportunity to connect with the community and maintainers of this project, without the requirement of contributing a change to the actual spec (which we see more in issues and PRs)
- [Community Slack channel](https://aka.ms/dev-container-community): This is a great opportunity to connect with the community and maintainers
- You can always check out the issues and PRs (and contribute new ones) across the repos in the [Dev Containers GitHub org](https://github.com/devcontainers) too!
- Community collections: You can contribute your own [Templates](https://containers.dev/implementors/templates-distribution/#distribution) and [Features](https://containers.dev/implementors/features-distribution/#distribution) to our [community index](https://containers.dev/collections)!