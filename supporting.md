---
title: Supporting tools and services
layout: singlePage
sectionid: supporting
---

This page outlines tools and services that currently support the development container specification, including the `devcontainer.json` format. A `devcontainer.json` file in your project tells tools and services that support the dev container spec how to access (or create) a dev container with a well-defined tool and runtime stack.

While most [dev container properties](implementors/json_reference) apply to any `devcontainer.json` supporting tool or service, a few are specific to certain tools, which are outlined below.

## <a href="#editors" name="editors" class="anchor"> Editors </a>

### <a href="#visual-studio-code" name="visual-studio-code" class="anchor"> Visual Studio Code </a>

Visual Studio Code specific properties go under `vscode` inside `customizations`.

```json
"customizations": {
		// Configure properties specific to VS Code.
		"vscode": {
			// Set *default* container specific settings.json values on container create.
			"settings": {},
			"extensions": [],
		}
}
```

| Property | Type  | Description |
|:------------------|:------------|:------------|
| `extensions` | array | An array of extension IDs that specify the extensions that should be installed inside the container when it is created. Defaults to `[]`. |
| `settings` | object | Adds default `settings.json` values into a container/machine specific settings file. Defaults to `{}`. |
{: .table .table-bordered .table-responsive}

Please note that the [Dev Containers](#dev-containers) extension and [GitHub Codespaces](#github-codespaces) support these VS Code properties.

### <a href="#visual-studio" name="visual-studio" class="anchor"> Visual Studio </a>

Visual Studio added Dev Container support in Visual Studio 2022 17.4 for C++ projects using CMake Presets. It is part of the Linux and embedded development with C++ workload, so make sure it is selected in your VS installation. Visual Studio manages the lifecycle of Dev Containers it uses as you work, but it treats them as remote targets in a similar way to other Linux or WSL targets.

You may learn more in the [announcement blog post](https://devblogs.microsoft.com/cppblog/dev-containers-for-c-in-visual-studio/).

### <a href="#intellij" name="intellij" class="anchor"> IntelliJ IDEA </a>

IntelliJ IDEA has early support Dev Containers that can be run remotely via an SSH connection or locally using Docker.

You may learn more in the [announcement blog post](https://blog.jetbrains.com/idea/2023/06/intellij-idea-2023-2-eap-6/#SupportforDevContainers).

## <a href="#tools" name="tools" class="anchor"> Tools </a>

### <a href="#devcontainer-cli" name="devcontainer-cli" class="anchor"> Dev Container CLI </a>

The dev container command line interface (CLI) is a reference implementation for the Dev Container spec. It is in development in the [devcontainers/cli](https://github.com/devcontainers/cli) repo. It is intended both for use directly and by tools or services that want to support the spec.

The CLI can take a `devcontainer.json` and create and configure a dev container from it. It allows for prebuilding dev container definitions using a CI or DevOps product like GitHub Actions. It can detect and include dev container features and apply them at container runtime, and run [lifecycle scripts](implementors/json_reference/#lifecycle-scripts) like `postCreateCommand`, providing more power than a plain `docker build` and `docker run`.

#### <a href="#dev-containers-cli" name="dev-containers-cli" class="anchor"> VS Code extension CLI </a>

The [VS Code Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) includes a variation of the devcontainer CLI that adds the ability use the command line to open a dev container in VS Code. It is also automatically updated when the extension updates. 

Press <kbd>cmd/ctrl</kbd>+<kbd>shift</kbd>+<kbd>p</kbd> or <kbd>F1</kbd> and select the **Dev Containers: Install devcontainer CLI** command to install it.

### <a href="#cachix-devenv" name="cachix-devenv" class="anchor"> Cachix devenv </a>

Cachix's **[devenv](https://devenv.sh/)** now supports automatically generating a `.devcontainer.json` file. This gives you a more convenient and consistent way to use [Nix](https://nixos.org/) with any Dev Container spec supporting tool or service!

See [devenv documentation](https://devenv.sh/integrations/codespaces-devcontainer/) for detais. 

### <a href="#jetpack-io-devbox" name="jetpack-io-devbox" class="anchor"> Jetpack.io Devbox </a>

[Jetpack.io](https://jetpack.io) is a [Nix](https://nixos.org/)-based service for deploying applications. [DevBox](https://www.jetpack.io/devbox/) provides a way to use Nix to generate a development environment. [Jetpack.io's VS Code extension](https://marketplace.visualstudio.com/items?itemName=jetpack-io.devbox) allows you to quickly take advantage of DevBox in any Dev Container spec supporting tool or service. 

Press <kbd>cmd/ctrl</kbd>+<kbd>shift</kbd>+<kbd>p</kbd> or <kbd>F1</kbd> and select the **Generate Dev Container files** command to get started!

### <a href="#dev-containers" name="dev-containers" class="anchor"> VS Code Dev Containers extension </a>

The [Visual Studio Code Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) lets you use a [Docker container](https://docker.com) as a full-featured development environment. It allows you to open any folder inside (or mounted into) a container and take advantage of Visual Studio Code's full feature set. There is more information in the Dev Containers [documentation](https://code.visualstudio.com/docs/remote/containers).

> **Tip:** If you make a change to your dev container after having built and connected to it, be sure to run **Dev Containers: Rebuild Container** from the Command Palette (<kbd>cmd/ctrl</kbd>+<kbd>shift</kbd>+<kbd>p</kbd> or <kbd>F1</kbd>) to pick up any changes you make.

#### <a href="#product-specific-properties" name="product-specific-properties" class="anchor"> Product specific properties </a>

The Dev Containers extension implements the [VS Code properties](#visual-studio-code) specific properties.

#### <a href="#dev-containers-code-specific-limitations" name="dev-containers-specific-limitations" class="anchor"> Product specific limitations </a>

Some properties may also have certain limitations in the Dev Containers extension.

| Property or variable | Type  | Description |
|:------------------|:------------|:------------|
| `workspaceMount` | string | Not yet supported when using Clone Repository in Container Volume. |
| `workspaceFolder` | string | Not yet supported when using Clone Repository in Container Volume. |
| `${localWorkspaceFolder}`  | Any | Not yet supported when using Clone Repository in Container Volume. |
| `${localWorkspaceFolderBasename}` | Any | Not yet supported when using Clone Repository in Container Volume. |
{: .table .table-bordered .table-responsive}

## <a href="#services" name="services" class="anchor"> Services </a>

### <a href="#github-codespaces" name="github-codespaces" class="anchor"> GitHub Codespaces </a>

A [codespace](https://docs.github.com/en/codespaces/overview) is a development environment that's hosted in the cloud. Codespaces run on a variety of VM-based compute options hosted by GitHub.com, which you can configure from 2 core machines up to 32 core machines. You can connect to your codespaces from the browser or locally using Visual Studio Code.

> **Tip:** If you make a change to your dev container after having built and connected to your codespace, be sure to run **Codespaces: Rebuild Container** from the Command Palette (<kbd>cmd/ctrl</kbd>+<kbd>shift</kbd>+<kbd>p</kbd> or <kbd>F1</kbd>) to pick up any changes you make.

#### <a href="#codespaces-specific-properties" name="codespaces-specific-properties" class="anchor"> Product specific properties </a>
GitHub Codespaces works with a growing number of tools and, where applicable, their `devcontainer.json` properties. For example, connecting the Codespaces web editor or VS Code enables the use of [VS Code properties](#visual-studio-code).

If your Codespaces project needs additional permissions for other repositories, you can configure this through the `repositories` and `permissions` properties. You may learn more about this in the [Codespaces documentation](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-repository-access-for-your-codespaces). As with other tools, Codespaces specific properties are placed within a `codespaces` namespace inside the `customizations` property.

```json
"customizations": {
	// Configure properties specific to Codespaces.
	"codespaces": {
		"repositories": {
			"my_org/my_repo": {
				"permissions": {
					"issues": "write"
				}
			}
		}
	}
}
```

You can customize which files are initially opened when the codespace is created:
```json
"customizations": {
	// Configure properties specific to Codespaces.
	"codespaces": {
		"openFiles": [
			"README"
			"src/index.js"
		]
	}
}
```

The paths are relative to the root of the repository. They will be opened in order, with the first file activated.

Note that currently Codespaces reads these properties from devcontainer.json, not image metadata.

#### <a href="#codespaces-specific-limitations" name="codespaces-specific-limitations" class="anchor"> Product specific limitations </a>

Some properties may apply differently to Codespaces.

| Property or variable | Type | Description |
|----------|---------|----------------------|
| `mounts` | array | Codespaces ignores "bind" mounts with the exception of the Docker socket. Volume mounts are still allowed.|
| `forwardPorts` | array | Codespaces does not yet support the `"host:port"` variation of this property. |
| `portsAttributes` | object | Codespaces does not yet support the `"host:port"` variation of this property.|
| `shutdownAction` | enum | Does not apply to Codespaces. |
| `${localEnv:VARIABLE_NAME}` | Any | For Codespaces, the host is in the cloud rather than your local machine.|
| `customizations.codespaces` | object | Codespaces reads this property from devcontainer.json, not image metadata. |
| `hostRequirements` | object | Codespaces reads this property from devcontainer.json, not image metadata. |
{: .table .table-bordered .table-responsive}

### <a href="#devpod" name="devpod" class="anchor"> DevPod </a>

[DevPod](https://github.com/loft-sh/devpod) is a client-only tool to create reproducible developer environments based on a devcontainer.json on any backend. Each developer environment runs in a container and is specified through a devcontainer.json. Through DevPod providers these environments can be created on any backend, such as the local computer, a Kubernetes cluster, any reachable remote machine or in a VM in the cloud.

### <a href="#schema" name="schema" class="anchor"> Schema </a>

You can explore the [VS Code implementation](implementors/json_schema) of the dev container schema.
