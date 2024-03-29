# demo-docker-action
A demonstration of using GitHub actions to build and push reproducible, conda-based Docker containers with best practices

The build-and-push GitHub action is triggered whenever a push is made to `main` or to a PR that will be merged into `main`. Images from PRs are tagged by their PR number.

## adding your own container
Each directory in this repository corresponds with a different Docker image. So you should start by creating a new directory.

If a Dockerfile exists in the directory, it will be used to create the image. Otherwise, the GitHub action will use the default Dockerfile provided in the root of this repository.

Try to install all of your software with conda. You can provide [a conda `environment.yml` file](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#create-env-file-manually) containing all of your required packages. Make sure to follow best practices when writing your conda environment file.
![reproducible_conda_envs](https://github.com/aryarm/demo-docker-action/assets/23412689/791efa84-53dd-4fca-8ea8-8c7029c0528b)

Alongside your `environment.yml` file, you must provide a `conda-linux-64.lock` file. This maximizes the reproducibility of your builds. To create it, you can run the following inside the directory:
```
conda-lock --kind explicit --platform linux-64
```
If you ever add or modify a package in your `environment.yml` file, you should update its version in the `conda-linux-64.lock` file:
<pre><code>conda-lock --kind explicit --platform linux-64 <b>--update PACKAGENAME</b></code></pre>
If you don't already have it, you can [install `conda-lock` with conda](https://anaconda.org/conda-forge/conda-lock):
```
conda create -y -n lock -c conda-forge conda-lock
```

Optionally, you can provide a `test.sh` script that will be used to test the image before it's pushed. The script will be executed from its directory. Remember to mark it as executable via `chmod u+x test.sh`.

## pushing to other container registries
This GitHub action is currently configured to push to the GitHub container registry, but you can easily add other container registries, like DockerHub or Google Container Registry.

Just add your registry in [the *"include" section* of the GitHub action workflow](https://github.com/aryarm/demo-docker-action/blob/c0604b4/.github/workflows/docker.yml#L53-L54). For each registry, you will need to provide:
1. A short nickname (ex: "google" if using the Google Container Registry)
2. The registry domain (ex: "gcr.io" if using the Google Container Registry)
3. A login username
4. A login password or key

For a list of the supported registries and directions on how to obtain usernames and passwords, refer to [the `docker/login-action` README](https://github.com/docker/login-action?tab=readme-ov-file#about).

**Important**: Since item 4 is usually sensitive, it should be added as a _GitHub secret_ under the settings menu for this repository. To get there, click on [_Settings_ > _Secrets and variables_ > _Actions_](../../settings/secrets/actions#repository-secrets). Give your secret a memorable name. Provide that name in place of the secret itself within the GitHub action workflow.

## some best practices that this template encourages
1. **Reproducibility** Locks all of your software to specific versions, and uses conda and conda-lock to also lock the dependencies of that software.
2. **Size** Uses a small base image and [multi-stage builds](https://pythonspeed.com/articles/smaller-python-docker-images/) to ensure only the required software is packaged.
3. **Speed** Uses [Docker layer caching](https://pythonspeed.com/articles/faster-multi-stage-builds) to ensure images are built quickly. The default Dockerfile is designed to [reduce cache busting](https://pythonspeed.com/articles/docker-caching-model/).
4. **Testing and Security** Uses GitHub actions to automatically test images before deploying them. Uses GitHub secrets to securely manage permissions to push to shared container repositories.
