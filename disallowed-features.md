---
title: Disallowed Features
layout: singlePage
sectionid: disallowed-features
---

Dev container tools refuse to use a [Feature](implementors/features) that was reported to be problematic. This page explains why a Feature can be disallowed and what to do if one of your dev containers uses it.

## <a href="#error" name="error" class="anchor"> What you see </a>

When a dev container configuration references a disallowed Feature, building or starting the dev container fails with an error similar to:

> Cannot use the '`ghcr.io/<owner>/<collection>/<feature>`' Feature since it was reported to be problematic. Please remove this Feature from your configuration and rebuild any dev container using it before continuing.

If a dev container that uses the Feature is already running, the tool stops it.

## <a href="#why" name="why" class="anchor"> Why a Feature is disallowed </a>

A single Feature, or all Features in a collection, is disallowed when installing it is no longer considered safe. For example:

- The Feature contains malicious code or a serious security vulnerability.
- The GitHub account or organization that published the Feature was renamed or deleted, and its name is now available to, or controlled by, someone else. Whoever controls the name can publish new content under the same Feature IDs, so these IDs can no longer be trusted.

## <a href="#what-to-do" name="what-to-do" class="anchor"> What to do </a>

1. Remove the Feature from the `features` property of your `devcontainer.json`. Also check settings that add Features to all of your dev containers, such as `dev.containers.defaultFeatures` in VS Code.
2. If you need what the Feature installed, look for an alternative in the list of [available Features](features), or check whether its original author now publishes it under a different ID.
3. Rebuild your dev container.

Tools only check the Features referenced in your configuration. If you use an image that was pre-built with the Feature, rebuild that image without it.

## <a href="#authors" name="authors" class="anchor"> For Feature authors </a>

If you rename or delete the GitHub account or organization that publishes your Features, [update or remove the entry of your collection](https://github.com/devcontainers/devcontainers.github.io/blob/gh-pages/_data/collection-index.yml) in the collection index and let your users know about the new Feature IDs. Collections whose publishing account changed may be removed from the index and disallowed.

## <a href="#reporting" name="reporting" class="anchor"> Reporting a problematic Feature </a>

If you believe a Feature is malicious or was published by someone other than its original author, report it as described in our [security policy](https://github.com/devcontainers/devcontainers.github.io/blob/gh-pages/SECURITY.md). Please don't report security issues in public GitHub issues.

## <a href="#control-manifest" name="control-manifest" class="anchor"> How tools find disallowed Features </a>

Disallowed Features are listed in the [control manifest](static/devcontainer-control-manifest.json), which is maintained in the [devcontainers/crawler](https://github.com/devcontainers/crawler/blob/main/config/devcontainer-control-manifest.json) repository. Each entry in `disallowedFeatures` has:

| Property | Type | Description |
|----------|------|-------------|
| `featureIdPrefix` | string | A Feature ID is disallowed if it equals this prefix, or starts with it followed by `/`, `:` or `@`. For example, `ghcr.io/example/features` disallows `ghcr.io/example/features/node:1`, but not `ghcr.io/example/features-other/node:1`. |
| `documentationURL` | string | Optional. A link to more information that tools show with the error, for example this page. |

Disallowed Features are also removed from the list of [available Features](features) and from the index that tools use to discover Features.
