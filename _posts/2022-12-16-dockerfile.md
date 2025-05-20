---
layout: post
title:  "Using Images, Dockerfiles, and Docker Compose"
author:
  - "@chuxel"
authorUrl:
  - https://github.com/chuxel
---

When creating a development container, you have a variety of different ways to customize your environment like ["Features"](/features) or [lifecycle scripts](/implementors/json_reference/#lifecycle-scripts). However, if you are familiar with containers, you may want to use a [Dockerfile](/guide/dockerfile#dockerfile) or [Docker Compose / Compose](/guide/dockerfile#docker-compose) to customize your environment. This article will walk through how to use these formats with the Dev Container spec.

## <a href="#dockerfile" name="dockerfile" class="anchor">  Using a Dockerfile </a>

To keep things simple, many [Dev Container Templates](/templates) use container image references.

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu"
}
```

However, [Dockerfiles](https://docs.docker.com/engine/reference/builder/) are a great way to extend images, add additional native OS packages, or make minor edits to the OS image. You can reuse any Dockerfile, but let's walk through how to create one from scratch.

First, add a file named `Dockerfile` next to your `devcontainer.json`. For example:

```Dockerfile
FROM mcr.microsoft.com/devcontainers/base:ubuntu
# Install the xz-utils package
RUN apt-get update && apt-get install -y xz-utils
```

Next, remove the `image` property from `devcontainer.json` (if it exists) and add the `build` and `dockerfile` properties instead:

```json
{
    "build": {
        // Path is relative to the devcontainer.json file.
        "dockerfile": "Dockerfile"
    }
}
```

That's it! When you start up your Dev Container, the Dockerfile will be automatically built with no additional work. See [Dockerfile scenario reference](/implementors/json_reference/#image-specific) for more information on other related devcontainer.json properties.

### <a href="#dockerfile-image-iteration" name="dockerfile-image-iteration" class="anchor"> Iterating on an image that includes Dev Container metadata </a>

Better yet, you can can use a Dockerfile as a part of authoring an image you can share with others. You can even **add Dev Container settings and metadata right into the image itself**. This avoids having to duplicate config and settings in multiple devcontainer.json files and keeps them in sync with your images! 

See the guide on **[pre-building]({% post_url 2023-08-22-prebuild %})** to learn more!

## <a href="#docker-compose" name="docker-compose" class="anchor">  Using Docker Compose </a>

[Docker Compose](https://docs.docker.com/compose/) is a great way to define a multi-container development environment. Rather than adding things like databases or redis to your Dockerfile, you can reference existing images for these services and focus your Dev Container's content on tools and utilities you need for development.

### <a href="#docker-compose-image" name="docker-compose-image" class="anchor"> Using an image with Docker Compose </a>

As mentioned in the Dockerfile section, to keep things simple, many [Dev Container Templates](/templates) use container image references.

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu"
}
```

Let's create a `docker-compose.yml` file next to your `devcontainer.json` that references the same image and includes a PostgreSQL database:

```yaml
version: '3.8'
services:
  devcontainer:
    image: mcr.microsoft.com/devcontainers/base:ubuntu
    volumes:
      - ../..:/workspaces:cached
    network_mode: service:db
    command: sleep infinity

  db:
    image: postgres:latest
    restart: unless-stopped
    volumes:
      - postgres-data:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_USER: postgres
      POSTGRES_DB: postgres

volumes:
  postgres-data:
```

In this example:
-  `../..:/workspaces:cached` mounts the workspace folder from the local source tree into the Dev Container.
- `network_mode: service:db` puts the Dev Container on the same network as the database, so that it can access it on `localhost`.
- The `db` section uses the [Postgres](https://hub.docker.com/_/postgres) image with a few settings.

Next, let's configure devcontainer.json to use it.

```json
{
    "dockerComposeFile": "docker-compose.yml",
    "service": "devcontainer",
    "workspaceFolder": "/workspaces/${localWorkspaceFolderBasename}"
}
```

In this example:
- `service` indicates which service in the `docker-compose.yml` file is the Dev Container.
- `dockerComposeFile` indicates where to find the `docker-compose.yml` file.
- `workspaceFolder` indicates where to mount the workspace folder. This corresponds to a sub-folder under the mount point from `../..:/workspaces:cached` in the `docker-compose.yml` file.

That's it!

### <a href="#docker-compose-dockerfile" name="docker-compose-dockerfile" class="anchor"> Using a Dockerfile with Docker Compose </a>

You can also combine these scenarios and use Dockerfile with Docker Compose. This time we'll update `docker-compose.yml` to reference the Dockerfile by replacing `image` with a similar `build` section:

```yaml
version: '3.8'
services:
  devcontainer:
    build: 
      context: .
      dockerfile: Dockerfile
    volumes:
      - ../..:/workspaces:cached      
    network_mode: service:db
    command: sleep infinity

  db:
    image: postgres:latest
    restart: unless-stopped
    volumes:
      - postgres-data:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_USER: postgres
      POSTGRES_DB: postgres

volumes:
  postgres-data:
```

Finally, as in the Dockerfile example, you can use this same setup to create a Dev Container image that you can share with others. You can also add Dev Container settings and metadata right into the image itself. 

See the guide on **[pre-building]({% post_url 2023-08-22-prebuild %})** to learn more!
