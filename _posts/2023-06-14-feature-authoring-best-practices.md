---
layout: post
title:  "Best Practices: Authoring a Dev Container Feature"
author: "@joshspicer"
authorUrl: https://github.com/joshspicer
---

Last November I wrote about the basics around [authoring a Dev Container Feature](/guide/author-a-feature). Since then, [hundreds](https://containers.dev/features) of Features have been written by the community. The flexibility of Features has enabled a wide variety of use cases, from installing a single tool to configuring a full development environment.  To that effect, many different patterns for Feature authorship have emerge and the core team has learned a lot about what works well and what doesn't.

## Feature idempotency

The most useful Features are idempotent. This means that if a Feature is installed multiple times with different options (something that will become more common with [Feature Dependencies](https://github.com/devcontainers/spec/blob/main/proposals/feature-dependencies.md)), the Feature should be able to handle this gracefully.  For many Features that install a versioned tool, this means that the Feature should be able to install multiple versions of the tool.  

For example, the [python Feature](https://github.com/devcontainers/features/blob/main/src/python/devcontainer-feature.json#L8-L22) has an option for which version of `python` to install. If the Feature is installed multiple times with different versions, a well-designed Feature should install each specified version into a separate directory. This allows the user (and subsequently installed Features) to select the correct version of `python` if they wish.

A pattern that many Features utlize successfully is writing each tool to a versioned folder and symlinking the "active" version to a well-known location on the PATH.

### Adding to the $PATH

Features are free to define their own semantics for when two conflicting versions of a tool are installed.  However, there are some best practices that should be followed to ensure that the user is able to use the version of the tool that they selected.  A reasonable fallback behavior is to update any references to an installed tool on the PATH to the install of the **last executed Feature**.

<!-- TODO: Introduce better tooling support for editing PATH https://github.com/devcontainers/spec/issues/251 -->

For example, if two python Features are installed with different versions, the Feature that was installed last should update the PATH to point to that version of `python` installed.  This ensures that the user is able to use the version of `python` that they selected, and not the version requested by an intermediately installed Feature.


<!-- ## Code reuse -->
<!-- TODO: https://github.com/devcontainers/spec/blob/main/proposals/features-library.md -->