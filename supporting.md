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

Please note that [Remote - Containers](#remote-containers) and [GitHub Codespaces](#github-codespaces) support the VS Code properties.

## <a href="#tools" name="tools" class="anchor"> Tools </a>

## <a href="#devcontainer-cli" name="devcontainer-cli" class="anchor"> Dev container CLI </a>

A dev container command line interface (CLI) that implements this specification. It is in development in the [devcontainers/cli](https://github.com/devcontainers/cli) repo.

The CLI can take a `devcontainer.json` and create and configure a dev container from it. It allows for prebuilding dev container definitions using a CI or DevOps product like GitHub Actions. It can detect and include dev container features and apply them at container runtime, and run [lifecycle commands](implementors/json_reference/#lifecycle-scripts) like `postCreateCommand`, providing more power than a plain `docker build` and `docker run`.

### <a href="#remote-containers-cli" name="remote-containers-cli" class="anchor"> Remote - Containers CLI </a>

There is a Remote - Containers [`devcontainer` CLI](https://code.visualstudio.com/docs/remote/devcontainer-cli) which may be installed within Remote - Containers or through the command line.

### <a href="#remote-containers" name="remote-containers" class="anchor"> Visual Studio Code Remote - Containers </a>

The [**Visual Studio Code Remote - Containers** extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) lets you use a [Docker container](https://docker.com) as a full-featured development environment. It allows you to open any folder inside (or mounted into) a container and take advantage of Visual Studio Code's full feature set. There is more information in the Remote - Containers [documentation](https://code.visualstudio.com/docs/remote/containers).

> **Tip:** If you make a change to your dev container after having built and connected to it, be sure to run **Remote-Containers: Rebuild Container** from the Command Palette (`kbstyle(F1)`) to pick up any changes you make.

#### <a href="#product-specific-properties" name="product-specific-properties" class="anchor"> Product specific properties </a>

Remote containers implements the [VS Code properties](#visual-studio-code) specific properties.

#### <a href="#remote-containers-code-specific-limitations" name="remote-containers-specific-limitations" class="anchor"> Product specific limitations </a>

Some properties may also have certain limitations in the Remote - Containers extension.

| Property or variable | Type  | Description |
|:------------------|:------------|:------------|
| `workspaceMount` | string | Not yet supported when using Clone Repository in Container Volume. |
| `workspaceFolder` | string | Not yet supported when using Clone Repository in Container Volume. |
| `${localWorkspaceFolder}`  | Any | Not yet supported when using Clone Repository in Container Volume. |
| `${localWorkspaceFolderBasename}` | Any | Not yet supported when using Clone Repository in Container Volume. |
{: .table .table-bordered .table-responsive}

### <a href="#github-codespaces" name="github-codespaces" class="anchor"> GitHub Codespaces </a>

A [codespace](https://docs.github.com/en/codespaces/overview) is a development environment that's hosted in the cloud. Codespaces run on a variety of VM-based compute options hosted by GitHub.com, which you can configure from 2 core machines up to 32 core machines. You can connect to your codespaces from the browser or locally using Visual Studio Code.

> **Tip:** If you make a change to your dev container after having built and connected to your codespace, be sure to run **Codespaces: Rebuild Container** from the Command Palette (`kbstyle(F1)`) to pick up any changes you make.

#### <a href="#codespaces-specific-properties" name="codespaces-specific-properties" class="anchor"> Product specific properties </a>
GitHub Codespaces works with a growing number of tools and, where applicable, their `devcontainer.json` properties. For example, connecting the Codespaces web editor or VS Code enables the use of [VS Code properties](#visual-studio-code).

#### <a href="#codespaces-specific-limitations" name="codespaces-specific-limitations" class="anchor"> Product specific limitations </a>

Some properties may apply differently to Codespaces.

| Property or variable | Type  | Description |
|:------------------|:------------|:------------|
| `mounts` | array | Codespaces ignores "bind" mounts with the exception of the Docker socket. Volume mounts are still allowed.|
| `workspaceMount` | string | Not yet supported in Codespaces. |
| `workspaceFolder` | string | Not yet supported in Codespaces. |
| `forwardPorts` | array | Codespaces does not yet support the `"host:port"` variation of this property. |
| `portsAttributes` | object | Codespaces does not yet support the `"host:port"` variation of this property.|
| `shutdownAction` | enum | Does not apply to Codespaces. |
| `${localEnv:VARIABLE_NAME}` | Any | For Codespaces, the host is in the cloud rather than your local machine.|
{: .table .table-bordered .table-responsive}

### <a href="#schema" name="schema" class="anchor"> Schema </a>

You can explore the [VS Code implementation](implementors/json_schema) of the dev container schema.