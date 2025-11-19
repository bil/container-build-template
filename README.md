This template aims to make multi-stage container builds easier and more intuitive.

1. Add installation scripts to `./template/containerfiles/run` 
    - These should be `.sh` scripts
    - They should be written as if you were running them through the command line
2. Open `./template/engine_instructions.yaml` in a text editor
2. Specify the base image for the container as the value for the `base` key
    - The image needs to be specified as a full container registry URL if the image is stored in a private registry
    - If the image is stored on DockerHub, a resolvable image name is sufficient
3. Under the `images` key, list the names of the install scripts
    - base name only, no extensions
    - each name should be a yaml array element
    - these will be intermediate images in the build
5. Values in the `instructions` key provide further modifications for the container
    - these are all optional
    - `ENV`
        - environment variables to set in the container
        - specify each variable as an array element with two keys:
            - `name` = variable name
            - `value` = variable value
    - `COPY`
        - files and directories to copy to the container
        - `./src` is provided for your convenience, but any file under the repo root can be copied
        - specify each variable as an array element with two keys:
            - `src` = path from repo root
            - `dst` = path in container
    - `ENTRYPOINT`
        - allows the container to be run as an executable
        - default value is `/bin/bash -c`
        - each space-delimited value should be a separate yaml array element
    - `CMD`
        - commands/parameters passed to the entrypoint
        - each space-delimited value should be a separate yaml array element
6. To push your container image to a container registry, include values in the keys under `tagging`
    - `registry` = the URL of the container registry to push to
    - `name` = what to name the stored image
    - `tag` = optional (defaults to latest)
6. From `./template` run `make`

