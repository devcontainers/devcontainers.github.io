---
layout: implementors
title:  "Reference Implementation"
shortTitle: "Reference Implementation"
author: Microsoft
index: 2
---

The reference implementation for the specification is available through a [development container CLI](https://github.com/devcontainers/cli). This CLI can take a devcontainer.json and create and configure a dev container from it.

## <a href="#what-is-CLI" name="what-is-CLI" class="anchor"> What is the dev container CLI? </a>
When tools like VS Code and Codespaces detect a devcontainer.json file in a user's project, they use a CLI to configure a dev container. We've now opened up this CLI as a reference implementation so that individual users and other tools can read in devcontainer.json metadata and create dev containers from it.

This CLI can either be used directly or integrated into product experiences, similar to how it's integrated with Dev Containers and Codespaces today. It currently supports both a simple single container option and integrates with [Docker Compose](https://docs.docker.com/compose/) for multi-container scenarios.

The CLI is available for review in a new [devcontainers/cli](https://github.com/devcontainers/cli) repository, and you can read more about its development in [this issue](https://github.com/devcontainers/spec/issues/9) in the spec repo.

## <a href="#try-it" name="try-it" class="anchor"> How can I try it? </a>

We'd love for you to try out the dev container CLI and let us know what you think. You can quickly try it out in just a few simple steps, either by installing its npm package or building the CLI repo from sources.

You may learn more about building from sources in the [CLI repo's README](https://github.com/devcontainers/cli#try-it-out). On this page, we'll focus on using the npm package.

To install the npm package, you will need Python, Node.js (version 14 or greater), and C/C++ installed to build one of the dependencies. The VS Code [How to Contribute](https://github.com/microsoft/vscode/wiki/How-to-Contribute) wiki has details about the recommended toolsets.

### <a href="#npm-install" name="npm-install" class="anchor"> npm install </a>

```bash
npm install -g @devcontainers/cli
```

Verify you can run the CLI and see its help text:

```bash
devcontainer <command>

Commands:
  devcontainer up                   Create and run dev container
  devcontainer build [path]         Build a dev container image
  devcontainer run-user-commands    Run user commands
  devcontainer read-configuration   Read configuration
  devcontainer features             Features commands
  devcontainer templates            Templates commands
  devcontainer exec <cmd> [args..]  Execute a command on a running dev container

Options:
  --help     Show help                                                 [boolean]
  --version  Show version number                                       [boolean]
```

### <a href="#try-out" name="try-out" class="anchor"> Try out the CLI </a>

Once you have the CLI, you can try it out with a sample project, like this [Rust sample](https://github.com/microsoft/vscode-remote-try-rust).

Clone the Rust sample to your machine, and start a dev container with the CLI's `up` command:

```bash
git clone https://github.com/microsoft/vscode-remote-try-rust
devcontainer up --workspace-folder <path-to-vscode-remote-try-rust>
```

This will download the container image from a container registry and start the container. Your Rust container should now be running:

```bash
[88 ms] dev-containers-cli 0.1.0.
[165 ms] Start: Run: docker build -f /home/node/vscode-remote-try-rust/.devcontainer/Dockerfile -t vsc-vscode-remote-try-rust-89420ad7399ba74f55921e49cc3ecfd2 --build-arg VARIANT=bullseye /home/node/vscode-remote-try-rust/.devcontainer
[+] Building 0.5s (5/5) FINISHED
 => [internal] load build definition from Dockerfile                       0.0s
 => => transferring dockerfile: 38B                                        0.0s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 2B                                            0.0s
 => [internal] load metadata for mcr.microsoft.com/vscode/devcontainers/r  0.4s
 => CACHED [1/1] FROM mcr.microsoft.com/vscode/devcontainers/rust:1-bulls  0.0s
 => exporting to image                                                     0.0s
 => => exporting layers                                                    0.0s
 => => writing image sha256:39873ccb81e6fb613975e11e37438eee1d49c963a436d  0.0s
 => => naming to docker.io/library/vsc-vscode-remote-try-rust-89420ad7399  0.0s
[1640 ms] Start: Run: docker run --sig-proxy=false -a STDOUT -a STDERR --mount type=bind,source=/home/node/vscode-remote-try-rust,target=/workspaces/vscode-remote-try-rust -l devcontainer.local_folder=/home/node/vscode-remote-try-rust --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --entrypoint /bin/sh vsc-vscode-remote-try-rust-89420ad7399ba74f55921e49cc3ecfd2-uid -c echo Container started
Container started
{"outcome":"success","containerId":"f0a055ff056c1c1bb99cc09930efbf3a0437c54d9b4644695aa23c1d57b4bd11","remoteUser":"vscode","remoteWorkspaceFolder":"/workspaces/vscode-remote-try-rust"}
```

You can then run commands in this dev container:

```bash
devcontainer exec --workspace-folder <path-to-vscode-remote-try-rust> cargo run
```

This will compile and run the Rust sample, outputting:

```bash
[33 ms] dev-containers-cli 0.1.0.
   Compiling hello_remote_world v0.1.0 (/workspaces/vscode-remote-try-rust)
    Finished dev [unoptimized + debuginfo] target(s) in 1.06s
     Running `target/debug/hello_remote_world`
Hello, VS Code Remote - Containers!
{"outcome":"success"}
```

Congrats, you've just run the dev container CLI and seen it in action!

These steps are also provided in the CLI repo's [README](https://github.com/devcontainers/cli/blob/main/README.md). You may also review frequently asked questions [here](https://github.com/devcontainers/spec/issues/31).

### <a href="#prebuilding" name="prebuilding" class="anchor"> Prebuilding </a> 
We recommend pre-building images with the tools you need rather than creating and building a container image each time you open your project in a dev container. Using pre-built images will result in a faster container startup, simpler configuration, and allows you to pin to a specific version of tools to improve supply-chain security and avoid potential breaks. You can automate pre-building your image by scheduling the build using a DevOps or continuous integration (CI) service like GitHub Actions.

We recommend using the [Dev Container CLI](#npm-install) (or other spec supporting utilities like the [GitHub Action](https://github.com/marketplace/actions/devcontainers-ci) or [Azure DevOps task](https://marketplace.visualstudio.com/items?itemName=devcontainers.ci)) to pre-build your images. Once you've built your image, you can push it to a container registry (like the [Azure Container Registry](https://learn.microsoft.com/azure/container-registry/container-registry-get-started-docker-cli?tabs=azure-cli), [GitHub Container Registry](https://docs.github.com/packages/working-with-a-github-packages-registry/working-with-the-container-registry#pushing-container-images), or [Docker Hub](https://docs.docker.com/engine/reference/commandline/push)) and reference it directly.

```bash
devcontainer build --workspace-folder . --push true --image-name <my_image_name>:<optional_image_version>
```

#### <a href="#labels" name="labels" class="anchor"> Metadata in image labels</a> 

You can include Dev Container configuration and Feature metadata in prebuilt images via [image labels](https://docs.docker.com/config/labels-custom-metadata/). This makes the image self-contained since these settings are automatically picked up when the image is referenced - whether directly, in a `FROM` in a referenced Dockerfile, or in a Docker Compose file. This helps prevent your Dev Container config and image contents from getting out of sync, and allows you to push updates of the same configuration to multiple repositories through a simple image reference.

This metadata label is **automatically added** when you pre-build using the [Dev Container CLI](#npm-install) (or other spec supporting utilities like the [GitHub Action](https://github.com/marketplace/actions/devcontainers-ci) or [Azure DevOps task](https://marketplace.visualstudio.com/items?itemName=devcontainers.ci)) and includes settings from devcontainer.json and any referenced Dev Container Features.

This allows you to have a separate **more complex** devcontainer.json you use to pre-build your image, and then a dramatically **simplified one** in one or more repositories. The contents of the image will be merged with this simplified devcontainer.json content at the time you create the container (see the [the spec](/implementors/spec/#merge-logic) for info on merge logic). But at its simplest, you can just reference the image directly in devcontainer.json for the settings to take effect:

```json
{
    "image": "mcr.microsoft.com/devcontainers/go:1"
}
```

Note that you can also opt to manually add metadata to an image label instead. These properties will be picked up even if you didn't use the Dev Container CLI to build (and can be updated by the CLI even if you do). For example, consider this Dockerfile snippet:

```Dockerfile
LABEL devcontainer.metadata='[{ \
  "capAdd": [ "SYS_PTRACE" ], \
  "remoteUser": "devcontainer", \ 
  "postCreateCommand": "yarn install" \ 
}]'
```

See the [Dev Container metadata reference](../json_reference) for information on which properties are supported.

### <a href="#domainnames" name="domainnames" class="anchor"> Domain Names </a> 

If you are behind a firewall that needs to allow specific domains used by the dev container CLI, here's the list of hostnames you should allow communication to go through:

* `containers.dev` - The [homepage](https://containers.dev/) for everything about dev containers. It includes all official and community-supported [Features](https://containers.dev/features) and [Templates](https://containers.dev/templates).
* `ghcr.io`, `*.azurecr.io`, `mcr.microsoft.com` - [OCI registries](https://containers.dev/implementors/features-distribution/#oci-registry) like [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry), [Azure Container Registry](azure.microsoft.com/en-us/products/container-registry), and [Microsoft Container Registry](https://mcr.microsoft.com/en-us/catalog?search=dev%20container) serves as the primary distribution mechanism for dev container resources. 