---
layout: implementors
title:  "Dev Container Templates reference [proposal]"
shortTitle: "Templates"
author: Microsoft
index: 7
---

Development container "Templates" are source files packaged together that encode configuration for a complete development environment. A Template can be used in a new or existing project, and a [supporting tool](/supporting) will use the configuration from the Template to build a development container.

The configuration is placed in a [`.devcontainer.json`](/implementors/json_reference#devcontainerjson) which can also reference other files within the Template. Alternatively, `.devcontainer/devcontainer.json` can also be used if the container needs to reference other files, such as a `Dockerfile` or `docker-compose.yml`. A Template can also provide additional source files (eg: boilerplate code or a [lifecycle script](/implementors/json_reference/#lifecycle-scripts).

Template metadata is captured by a `devcontainer-template.json` file in the root folder of the Template.

## <a href="#folder-structure" name="folder-structure" class="anchor"> Folder Structure</a>

A single Template is a folder with at least a `devcontainer-template.json` and [`devcontainer.json`](/implementors/json_reference#devcontainerjson).  Additional files are permitted and are packaged along side the required files.

```
+-- template
|    +-- devcontainer-template.json
|    +-- .devcontainer.json
|    +-- (other files)
```

## <a href="#devcontainer-template-properties" name="devcontainer-template-properties" class="anchor">devcontainer-template.json properties</a>

The `devcontainer-template.json` file defines information about the Template to be used by any [supporting tools](/supporting#supporting-tools-and-services).

The properties of the file are as follows:

| Property | Type | Description |
| :--- | :--- | :--- |
| `id` | string | ID of the Template. The `id` should be unique in the context of the repository/published package where the Template exists and must match the name of the directory where the `devcontainer-template.json` resides. |
| `version` | string | The semantic version of the Template. |
| `name` | string | Name of the Template. |
| `description` | string | Description of the Template. |
| `documentationURL` | string | Url that points to the documentation of the Template. |
| `licenseURL` | string | Url that points to the license of the Template. |
| `options` | object | A map of options that the supporting tools should use to populate different configuration options for the Template. |
| `platforms` | array | Languages and platforms supported by the Template. |
| `publisher` | string | Name of the publisher/maintainer of the Template. |
| `keywords` | array | List of strings relevant to a user that would search for this Template. |

### <a href="#options" name="options" class="anchor">  The `options` property</a>
The `options` property contains a map of option IDs and their related configuration settings. These `options` are used by the supporting tools to prompt the user to choose from different Template configuration options. The tools would replace the option ID with the selected value in all the files (within the sub-directory of the Template). This replacement would happen before dropping the `.devcontainer.json` (or `.devcontainer/devcontainer.json`) and other files (within the sub-directory of the Template) required to containerize your project. See [option resolution](#option-resolution) for more details. For example:

```json
{
  "options": {
    "optionId": {
      "type": "string",
      "description": "Description of the option",
      "proposals": ["value1", "value2"],
      "default": "value1"
    }
  }
}
```

| Property | Type | Description |
| :--- | :--- | :--- |
| `optionId` | string | ID of the option used by the supporting tools to replace the selected value in the files within the sub-directory of the Template. |
| `optionId.type` | string | Type of the option. Valid types are currently: `boolean`, `string` |
| `optionId.description` | string | Description for the option. |
| `optionId.proposals` | array | A list of suggested string values. Free-form values **are** allowed. Omit when using `optionId.enum`. |
| `optionId.enum` | array | A strict list of allowed string values. Free-form values are **not** allowed. Omit when using `optionId.proposals`. |
| `optionId.default` | string | Default value for the option. |

> `Note`: The `options` must be unique for every `devcontainer-template.json`

### <a href="#referencing-a-template" name="referencing-a-template" class="anchor"> Referencing a Template </a>

The `id` format (`<oci-registry>/<namespace>/<template>[:<semantic-version>]`) dictates how a [supporting tool](/supporting) will locate and download a given Template from an OCI registry. For example:

- `ghcr.io/user/repo/go`
- `ghcr.io/user/repo/go:1`
- `ghcr.io/user/repo/go:latest`

The registry must implement the [OCI Artifact Distribution Specification](https://github.com/opencontainers/distribution-spec). Some implementors can be [found here](https://oras.land/implementors/).

## <a href="#versioning" name="versioning" class="anchor"> Versioning </a>

Each Template is individually [versioned according to the semver specification](https://semver.org/).  The `version` property in the respective `devcontainer-template.json` file is updated to increment the Template's version.

Tooling that handles releasing Templates will not republish Templates if that exact version has already been published; however, tooling must republish major and minor versions in accordance with the semver specification.

## <a href="#release" name="release" class="anchor"> Release </a>

_For information on distributing Templates, see [templates-distribution](/implementors/templates-distribution)._

### <a href="#option-resolution" name="option-resolution" class="anchor"> Option Resolution </a>

A Template's `options` property is used by a supporting tool to prompt for different configuration options. A supporting tool will parse the `options` object provided by the user. If a value is selected for a Template, it will be replaced in the files (within the sub-directory of the Template).

### <a href="#option-resolution-example" name="option-resolution-example" class="anchor"> Option resolution example </a>

Consider a `java` Template with the following folder structure:

```
+-- java
|    +-- devcontainer-template.json
|    +-- .devcontainer.json
```

Suppose the `java` Template has the following `options` parameters declared in the `devcontainer-template.json` file:

```json
// ...
"options": {
    "imageVariant": {
        "type": "string",
        "description": "Specify version of java.",
        "proposals": [
          "17-bullseye",
          "17-buster",
          "11-bullseye",
          "11-buster",
          "17",
          "11"
        ],
			  "default": "17-bullseye"
    },
    "nodeVersion": {
        "type": "string", 
        "proposals": [
          "latest",
          "16",
          "14",
          "10",
          "none"
        ],
        "default": "latest",
        "description": "Specify version of node, or 'none' to skip node installation."
    },
    "installMaven": {
        "type": "boolean", 
        "description": "Install Maven, a management tool for Java.",
        "default": "false"
    },
}
```

and it has the following `.devcontainer.json` file:

```json
{
	"name": "Java",
	"image": "mcr.microsoft.com/devcontainers/java:0-${templateOption:imageVariant}",
	"features": {
		"ghcr.io/devcontainers/features/node:1": {
			"version": "${templateOption:nodeVersion}",
      "installMaven": "${templateOption:installMaven}"
		}
	},
//	...
}
```

A user tries to add the `java` Template to their project using the [supporting tools](/supporting#supporting-tools-and-services) and selects `17-bullseye` when prompted for `"Specify version of Go"` and the `default` values when prompted for `"Specify version of node, or 'none' to skip node installation"` and `"Install Maven, a management tool for Java"`.

The supporting tool could then use a string replacer for all the files within the sub-directory of the Template. In this example, `.devcontainer.json` needs to be modified and hence, the inputs can provided to it as follows:

```
{
  imageVariant:"17-bullseye",
  nodeVersion: "latest",
  installMaven: "false"
}
```

The modified `.devcontainer.json` will be as follows:

```json
{
	"name": "Go",
	"image": "mcr.microsoft.com/devcontainers/go:0-17-bullseye",
	"features": {
		"ghcr.io/devcontainers/features/node:1": {
			"version": "latest",
      "installMaven": "false"
		}
	},
	...
}
```

The modified `.devcontainer.json` would be dropped into any existing folder as a starting point for containerizing your project.
