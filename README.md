# saifu-verify
KIRA Signature Verification Tool

## Deployment

The automated deployment pipeline supports `dev` & `master` branch only, built code is published via the corresponding DNS addresses:

* `master` -> https://sign.kira.network
* `dev` -> https://dev-sign.kira.network

To modify build process refer to `./amplify.yml` file which overrides default build process.

## Build Image

The build process uses a dedicated Docker image [kiracore/docker:dev-base-image](https://github.com/KiraCore/docker/blob/dev/base-image/container/deployment.sh), in case of any issues with dependencies please refer to the corresponding repository.