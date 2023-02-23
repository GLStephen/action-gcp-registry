# GitHub Action for GCP Registries

A GitHub action that builds your docker image and pushes it to container or artifact

## Prerequisites

- you have enabled the Registry in your Google Cloud project 
- you have a service account with Storage Admin permissions

## Usage

```bash
- name: Build and publish image to GCR
  uses: glstephen/action-gcp-registry@v1.0
  with:
    project_id: [your-project]
    dockerfile: [path-to-your-dockerfile]
    image: gcr.io/[your-project]/[image-name]
    service_account_key: ${{ secrets.GCLOUD_AUTH }}
```

Things to look out for:

- Your `GCLOUD_AUTH` secret (or whatever you name it) must be a base64 encoded gcloud JSON service key with the Storage
  Admin permissions.
- The image must be "pushable" to one of Google's container registries, i.e. it should be in the
  `gcr.io/[project]/[image]` or `eu.gcr.io/[project]/[image]` format.
  
## Inputs

| Name                  | Required | Default | Description      |
| --------------------- | -------- | ------- | ---------------- |
| `build_args`          | ❌       |         | Comma separated list of variable assignments that will be passed as `--build-arg` to the build script, e.g. `FIRST_NAME=Knot,LAST_NAME=Kandel` |
| `context`             | ❌       | .       | Relative path to the build context |
| `dockerfile`          | ✔        |         | Relative path to your Dockerfile |
| `image`               | ✔        |         | The name of the image in [Container Registry format](https://cloud.google.com/container-registry/docs/pushing-and-pulling#add-registry) |
| `service_account_key` | ✔        |         | Base64-encoded service account JSON key |
| `project`             | ✔        |         | The ID of your Google Cloud project |
| `target`              | ❌       |         | Target for [multistage builds](https://docs.docker.com/develop/develop-images/multistage-build/) |
