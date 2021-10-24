# Hardware
This is the hardware submodule repo for `bladerf`. The scripts in this repo don't work without the parent module. You should clone https://github.com/base-band/bladerf and read the readme there.

# General Information for building
These instructions use `BB_PARENT` env variable to point at a folder which has multiple git repos inside. These instructions assume that this repo is a submodule of `bladerf`.

# Rebuilding VexRiscv using Docker
This project has generated output from VexRiscv. To generate a new core.

```bash
export BB_PARENT=/work/base-band       # update to fit your needs
docker run -dit --name bbex -v ${BB_PARENT}:/src ghcr.io/base-band/docker-images/vex-ci-build:latest
docker exec -it bbex bash
ls  /src # check if the dirs look correct
cd /src/bladerf/lib/hardware
make genriscv
git diff
```

Due to the nature of VexRiscv, it's a very high probability that `git diff` will show many changes akin to comparing assembly output. Small changes in tool versions and code will result in wild differences in the output file. 




# License
Some files were copied and modified from https://github.com/siglabsoss/q-engine  See LICENSE_siglabsoss

