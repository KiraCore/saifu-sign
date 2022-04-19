# saifu-verify
KIRA Signature Verification Tool

## Releases

All files in the [KIRA releases](https://github.com/KiraCore/saifu-sign/releases) are always signed with [cosign](https://github.com/sigstore/cosign/releases) and listed with a corresponding `SHA256` checksum. You should NEVER install anything on your machine unless you verified integrity of the files!

To learn more about how to install cosign and verify integrity of files click [here](./COSIGN.md)

## Deployment

The automated deployment pipeline supports `dev` & `master` branch only, built code is published via the corresponding DNS addresses:

* `master` -> https://sign.kira.network
* `dev` -> https://dev-sign.kira.network

To modify build process refer to `./amplify.yml` file which overrides default build process.

## Build Image

The build process uses a dedicated Docker image [ghcr.io/kiracore/docker/base-image:v0.9.2-rc.2](https://github.com/kiracore/docker/pkgs/container/docker%2Fbase-image/19058504?tag=v0.9.2-rc.2), in case of any issues with dependencies please refer to the corresponding repository.

