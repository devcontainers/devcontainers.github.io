---
title: Overview
layout: singlePage
sectionid: overview
---

## <a href="#overview" name="overview" class="anchor"> What are development containers? </a>
As containerizing production workloads becomes commonplace, more developers are using containers for scenarios beyond deployment, including continuous integration, test automation, and even full-featured coding environments.

Each scenario’s needs can vary between simple single container environments to complex, orchestrated multi-container setups. Rather than attempting to create another orchestrator format, the Development Containers Specification (or Dev Containers Spec for short) seeks to find ways to enrich existing formats with metadata for common development specific settings, tools, and configuration.

### <a href="#metadata-format" name="metadata-format" class="anchor">  A structured metadata format </a>

Like the [Language Server Protocol](https://microsoft.github.io/language-server-protocol/) before it, the first format in the specification, [`devcontainer.json`](implementors/json_reference), was born out of necessity. It is a structured JSON with Comments (jsonc) metadata format that tools can use to store any needed configuration required to develop inside of local or cloud-based containerized coding. 

Since the spec was initally published, Dev Container metadata can now be stored in [image labels](../implementors/spec/#image-metadata) and in reusable chunks of metadata and install scripts known as [Dev Container Features](../features). We envision that this same structured data can be embedded in other formats -- all while retaining a common object model for consistent processing.

### <a href="#Development-vs-production" name="Development-vs-production" class="anchor"> Development vs production </a>

A Development Container defines an environment in which you develop your application before you are ready to deploy. While deployment and development containers may resemble one another, you may not want to include tools in a deployment image that you use during development.

<img alt="Diagram of inner and outer loop of container-based development" src="img/dev-container-stages.png"/>

### <a href="#build-and-test" name="build-and-test" class="anchor">  Build and test </a>

Beyond repeatable setup, these same development containers provide consistency to avoid environment specific problems across developers and centralized build and test automation services. The open-source [CLI reference implementation](https://github.com/devcontainers/cli) can either be used directly or integrated into product experience to use the structured metadata to deliver these benefits. It currently supports integrating with Docker Compose and a simplified, un-orchestrated single container option – so that they can be used as coding environments or for continuous integration and testing.

A GitHub Action and an Azure DevOps Task are available in [devcontainers/ci](https://github.com/devcontainers/ci) for running a repository's dev container in continuous integration (CI) builds. This allows you to reuse the same setup that you are using for local development to also build and test your code in CI.

### <a href="#supporting" name="supporting" class="anchor">  Supporting tools </a>

You can [learn more](/supporting.md) about how other tools and services support the Development Container Specification.
