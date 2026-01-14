---
title: Glossary
layout: singlePage
sectionid: glossary
---

This glossary provides definitions for key terms used throughout the Development Container Specification and related documentation.

## <a href="#dev-container" name="dev-container" class="anchor"> Dev Container (Development Container) </a>
A containerized development environment that provides a fully configured workspace with all necessary tools, runtimes, and dependencies. Dev containers enable consistent, reproducible development setups that work across different machines and team members.

## <a href="#devcontainer-json" name="devcontainer-json" class="anchor"> devcontainer.json </a>
A structured JSON with Comments (JSONC) configuration file that defines the settings, tools, and environment for a dev container. This file is typically located in a `.devcontainer` folder at the root of your project. See the [metadata reference](implementors/json_reference) for all available properties.

## <a href="#dev-container-feature" name="dev-container-feature" class="anchor"> Dev Container Feature </a>
A self-contained, shareable unit of installation code and configuration that adds specific tools, runtimes, or capabilities to a dev container. Features are composable—you can combine multiple features to build your ideal development environment. Browse [available features](features) or learn how to [author a feature](implementors/features).

## <a href="#dev-container-template" name="dev-container-template" class="anchor"> Dev Container Template </a>
A pre-configured starting point for creating a dev container. Templates provide initial `devcontainer.json` files (and optionally Dockerfiles or other supporting files) for common development scenarios. Browse [available templates](templates) or learn about [template distribution](implementors/templates-distribution).

## <a href="#collection" name="collection" class="anchor"> Collection </a>
A group of related dev container features or templates published together, typically in a container registry. Collections enable discovery and sharing of community-maintained features and templates. See [collections](collections) for registered collections.

## <a href="#lifecycle-scripts" name="lifecycle-scripts" class="anchor"> Lifecycle Scripts </a>
Commands that run at specific points during the dev container lifecycle. These include:

- **initializeCommand**: Runs on the host machine during initialization
- **onCreateCommand**: Runs inside the container when first created
- **updateContentCommand**: Runs when new content is available during creation
- **postCreateCommand**: Runs after the container is assigned to a user
- **postStartCommand**: Runs each time the container starts successfully
- **postAttachCommand**: Runs each time a tool attaches to the container

See the [lifecycle scripts reference](implementors/json_reference/#lifecycle-scripts) for details.

## <a href="#image" name="image" class="anchor"> Image </a>
A container image (typically Docker) that serves as the base for a dev container. Images can be specified directly in `devcontainer.json` using the `image` property, or built from a Dockerfile. Popular base images are available from registries like DockerHub, GitHub Container Registry, and Azure Container Registry.

## <a href="#dockerfile" name="dockerfile" class="anchor"> Dockerfile </a>
A text file containing instructions for building a container image. When referenced in `devcontainer.json` via the `build.dockerfile` property, the Dockerfile is used to create a custom base image for the dev container.

## <a href="#docker-compose" name="docker-compose" class="anchor"> Docker Compose </a>
A tool for defining and running multi-container applications. Dev containers can reference Docker Compose files to define complex development environments with multiple services (e.g., a web server, database, and cache).

## <a href="#workspacefolder" name="workspacefolder" class="anchor"> workspaceFolder </a>
The path inside the container where your project's source code is mounted and where development tools will focus. This is configured via the `workspaceFolder` property in `devcontainer.json`.

## <a href="#remote-user" name="remote-user" class="anchor"> remoteUser </a>
The user account under which dev container supporting tools run commands and processes inside the container. This can differ from the container's root user, allowing for better permission management. See the [remoteUser documentation](implementors/json_reference/#remoteuser).

## <a href="#container-user" name="container-user" class="anchor"> containerUser </a>
The user account that the container runs as by default for all operations. This is separate from `remoteUser`, which only affects tool-initiated processes.

## <a href="#customizations" name="customizations" class="anchor"> Customizations </a>
Product-specific configuration in `devcontainer.json` that allows different tools and services to add their own settings. For example, VS Code uses `customizations.vscode` for extensions and settings, while GitHub Codespaces uses `customizations.codespaces`. See [supporting tools](supporting) for tool-specific properties.

## <a href="#forward-ports" name="forward-ports" class="anchor"> forwardPorts </a>
An array of port numbers that should be forwarded from inside the container to the local machine. This enables access to services running in the container (like web servers) from your local browser or tools.

## <a href="#mounts" name="mounts" class="anchor"> Mounts </a>
Additional file system mounts attached to the container beyond the default workspace mount. Mounts can be bind mounts (linking to host directories) or volume mounts (using Docker volumes for persistent storage).

## <a href="#host-requirements" name="host-requirements" class="anchor"> hostRequirements </a>
Properties that specify minimum hardware requirements for the dev container, including CPU cores, memory, storage, and GPU capabilities. Cloud services use these to provision appropriate compute resources.

## <a href="#dev-container-cli" name="dev-container-cli" class="anchor"> Dev Container CLI </a>
The reference implementation command-line interface for building and managing dev containers. The CLI can create containers from `devcontainer.json` configurations, run lifecycle scripts, and execute commands inside containers. See the [CLI repository](https://github.com/devcontainers/cli).

## <a href="#prebuild" name="prebuild" class="anchor"> Prebuild </a>
The process of building a dev container image ahead of time, typically in CI/CD pipelines, to reduce container startup time. Prebuilds can run `onCreateCommand` and `updateContentCommand` so the container is ready faster when a developer connects.

## <a href="#image-labels" name="image-labels" class="anchor"> Image Labels </a>
Metadata stored in a container image that can include dev container configuration. The `devcontainer.metadata` label can contain JSON configuration that is automatically merged with `devcontainer.json` when creating a container, allowing features and base images to contribute configuration.

## <a href="#variables" name="variables" class="anchor"> Variables </a>
Placeholders in `devcontainer.json` that are replaced with dynamic values. Common variables include:

- **${localEnv:VAR_NAME}**: Environment variable from the host machine
- **${containerEnv:VAR_NAME}**: Environment variable inside the running container
- **${localWorkspaceFolder}**: Path to the project folder on the host
- **${containerWorkspaceFolder}**: Path to the project folder in the container
- **${devcontainerId}**: Unique, stable identifier for the dev container

See the [variables reference](implementors/json_reference/#variables-in-devcontainerjson) for the complete list.

## <a href="#port-attributes" name="port-attributes" class="anchor"> Port Attributes </a>
Configuration options that control how forwarded ports behave, including labels, protocols (HTTP/HTTPS), auto-forwarding behavior, and whether local port matching is required. Configured via `portsAttributes` and `otherPortsAttributes` properties.
