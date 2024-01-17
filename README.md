# demo-docker-action
A demonstration of using GitHub actions to build and push reproducible Docker containers with best practices

The build-and-push GitHub action is triggered whenever a push is made to `main` or to a PR that will be merged into `main`.

## adding your own container
Each directory in this repository corresponds with a different Docker image. So you should start by creating a new directory.

If a Dockerfile exists in the directory, it will be used to create the image. Otherwise, the GitHub action will use the default Dockerfile provided in the root of this repository.

For the most reproducible builds, try to install all of your software with conda. You should provide [a conda `environment.yml` file](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#create-env-file-manually) containing all of your required packages. Make sure to follow best practices when writing your conda environment file.
![reproducible_conda_envs](https://github.com/aryarm/demo-docker-action/assets/23412689/791efa84-53dd-4fca-8ea8-8c7029c0528b)

Alongside your `environment.yml` file, you should provide a `conda-linux-64.lock` file. To create it, you can run the following inside the directory:
```
conda-lock --kind explicit --platform linux-64 --file environment.yml --check-input-hash
```
You can [install `conda-lock` with conda](https://anaconda.org/conda-forge/conda-lock):
```
conda create -y -n lock -c conda-forge conda-lock
```

Optionally, you can provide a `test.bash` script that will be used to test the image before it's pushed. The script will be executed from its directory.

## pushing to other container registries
This GitHub action is currently configured to push to the GitHub container registry, but you can easily add other container registries, like DockerHub or Google Container Registry.

Just add your registry in [the *"include" section* of the GitHub action workflow](https://github.com/aryarm/demo-docker-action/blob/2850ce9b/.github/workflows/docker.yml#L53-L54). For each registry, you will need to provide:
1. A short nickname (ex: "google" if using the Google Container Registry)
2. The registry domain (ex: "gcr.io" if using the Google Container Registry)
3. A login username
4. A login password or key

For a list of the supported registries and directions on how to obtain usernames and passwords, refer to [the `docker/login-action` README](https://github.com/docker/login-action?tab=readme-ov-file#about).

**Important**: Since item 4 is usually sensitive, it should be added as a _GitHub secret_ under the settings menu for this repository. To get there, click on [_Settings_ > _Secrets and variables_ > _Actions_](../../settings/secrets/actions#repository-secrets). Give your secret a memorable name. Provide that name in place of the secret itself within the GitHub action workflow.
