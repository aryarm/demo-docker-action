# demo-docker-action
A demonstration of using GitHub actions to build and push reproducible Docker containers with best practices

## configuration
First, fork this repository.

Now, add your Google Container registry username and password as repository secrets under the settings menu. To get there, click on [_Settings_ > _Secrets and variables_ > _Actions_](../../settings/secrets/actions#repository-secrets). Then create secrets for

1. GCR_USERNAME
2. GCR_PASSWORD

## adding your own container
Each directory in this repository corresponds with a different Docker image. To add a new image, start by creating a new directory. Our GitHub actions workflow will automatically notice it and try to build an image for it.

Inside of the directory, [create a conda environment.yml file](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#create-env-file-manually) containing all of the required packages. Make sure to follow best practices when writing your conda environment.yml file.
![reproducible_conda_envs](https://github.com/aryarm/demo-docker-action/assets/23412689/791efa84-53dd-4fca-8ea8-8c7029c0528b)

If a Dockerfile exists in the directory, it will be used to create the image. Otherwise, the GitHub action will use the default Dockerfile provided in the root of this repository.
