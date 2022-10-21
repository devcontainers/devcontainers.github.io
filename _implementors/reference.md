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

We recommend using the dev container CLI to pre-build your images. Once you've built your image, you can push it to a container registry (like the [Azure Container Registry](https://learn.microsoft.com/azure/container-registry/container-registry-get-started-docker-cli?tabs=azure-cli), [GitHub Container Registry](https://docs.github.com/packages/working-with-a-github-packages-registry/working-with-the-container-registry#pushing-container-images), or [Docker Hub](https://docs.docker.com/engine/reference/commandline/push)) and reference it directly.

#### <a href="#labels" name="labels" class="anchor"> Metadata in image labels (proposal) </a> 

You can include dev container configuration and Feature metadata in prebuilt images via [image labels](https://docs.docker.com/config/labels-custom-metadata/), such that, the image and the built-in features can be used with a devcontainer.json (image-, Dockerfile- or Docker Compose-based) that does not repeat the dev container config or feature metadata. Other tools should be able to record the same metadata without necessarily using features themselves.

You may add metadata to the image with the following structure, using one entry per Feature and devcontainer.json:

```json
[
	{
		"id"?: string,
		"init"?: boolean,
		"privileged"?: boolean,
		"capAdd"?: string[],
		"securityOpt"?: string[],
		"entrypoint"?: string,
		"mounts"?: [],
		...
		"customizations"?: {
			...
		}
	},
	...
]
```

To simplify adding this metadata for other tools, we also support having a single top-level object with the same properties.

The metadata is added to the image as a `devcontainer.metadata` label with a JSON string value representing the above array or single object.

You may review more information about this proposal in the [spec repo](https://github.com/devcontainers/spec/blob/main/proposals/image-metadata.md).