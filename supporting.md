---
title: Supporting tools and services
layout: singlePage
sectionid: supporting
---

This page outlines tools and services that currently support the development container specification, including the `devcontainer.json` format.

While most [dev container properties](implementors/json_reference) apply to any `devcontainer.json` supporting tool or service, a few are specific to certain tools, which are outlined below.

## <a href="#devcontainer-cli" name="devcontainer-cli" class="anchor"> devcontainer CLI </a>

There will be a dev container command line interface (CLI) that can take a `devcontainer.json` and create and configure a dev container from it. The CLI allows for prebuilding dev container definitions using a CI or DevOps product like GitHub Actions. It can detect and include dev container features and apply them at container runtime, and run [lifecycle commands](implementors/json_reference/#lifecycle-scripts) like `postCreateCommand`, providing more power than a plain `docker build` and `docker run`.

The publishing of this CLI is being discussed in a [dev-container-spec issue](https://github.com/microsoft/dev-container-spec/issues/9) and will be available on the [reference page](implementors/reference) of this site.

## <a href="#github-codespaces" name="github-codespaces" class="anchor"> GitHub Codespaces </a>

A [codespace](https://docs.github.com/en/codespaces/overview) is a development environment that's hosted in the cloud. Codespaces run on a variety of VM-based compute options hosted by GitHub.com, which you can configure from 2 core machines up to 32 core machines. You can connect to your codespaces from the browser or locally using Visual Studio Code.

> **Tip:** If you make a change to your dev container after having built and connected to your codespace, be sure to run **Codespaces: Rebuild Container** from the Command Palette (`kbstyle(F1)`) to pick up any changes you make.

### <a href="#codespaces-specific-properties" name="codespaces-specific-properties" class="anchor"> Product specific properties </a>
GitHub Codespaces works with a growing number of tools and, where applicable, their `devcontainer.json` properties. For example, connecting the Codespaces web editor or VS Code enables the use of [VS Code properties](#visual-studio-code-specific-properties).

### <a href="#codespaces-specific-limitations" name="codespaces-specific-limitations" class="anchor"> Product specific limitations </a>

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

## <a href="#visual-studio-code-remote-containers" name="visual-studio-code-remote-containers" class="anchor"> Visual Studio Code Remote - Containers </a>

The [**Visual Studio Code Remote - Containers** extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) lets you use a [Docker container](https://docker.com) as a full-featured development environment. It allows you to open any folder inside (or mounted into) a container and take advantage of Visual Studio Code's full feature set. There is more information in the Remote - Containers [documentation](https://code.visualstudio.com/docs/remote/containers).

> **Tip:** If you make a change to your dev container after having built and connected to it, be sure to run **Remote-Containers: Rebuild Container** from the Command Palette (`kbstyle(F1)`) to pick up any changes you make.

### <a href="#visual-studio-code-specific-properties" name="visual-studio-code-specific-properties" class="anchor"> Product specific properties </a>

Some properties are specific to VS Code. Please note that Codespaces supports these VS Code properties.

| Property | Type  | Description |
|:------------------|:------------|:------------|
| `extensions` | array | An array of extension IDs that specify the extensions that should be installed inside the container when it is created. Defaults to `[]`. |
| `settings` | object | Adds default `settings.json` values into a container/machine specific settings file. Defaults to `{}`. |
{: .table .table-bordered .table-responsive}

### <a href="#visual-studio-code-specific-limitations" name="visual-studio-code-specific-limitations" class="anchor"> Product specific limitations </a>

Some properties may also have certain limitations in the Remote - Containers extension.

| Property or variable | Type  | Description |
|:------------------|:------------|:------------|
| `workspaceMount` | string | Not yet supported when using Clone Repository in Container Volume. |
| `workspaceFolder` | string | Not yet supported when using Clone Repository in Container Volume. |
| `${localWorkspaceFolder}`  | Any | Not yet supported when using Clone Repository in Container Volume. |
| `${localWorkspaceFolderBasename}` | Any | Not yet supported when using Clone Repository in Container Volume. |
{: .table .table-bordered .table-responsive}

## <a href="#remote-containers-cli" name="remote-containers-cli" class="anchor"> Remote - Containers CLI </a>

There is a Remote - Containers [`devcontainer` CLI](https://code.visualstudio.com/docs/remote/devcontainer-cli) which may be installed within Remote - Containers or through the command line.

## <a href="#schema" name="schema" class="anchor"> Schema </a>

You can explore the [VS Code implementation](implementors/json_schema) of the dev container schema.