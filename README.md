# Description
A disposable docker image to build a portable [nantille/blender_28_mod](https://github.com/nantille/blender_28_mod) on CentOS 7.

> ⚠**_Warning_**⚠ Currently only the `master` branch is supported. It means that blender cannot be compiled with stable versions, but only latest.  
> If you want to check available blender branches anyway, you can find them at https://github.com/blender/blender/branches.

# Usage
`cd` to the folder where Dockerfile and bash scripts are. Then:

- if you want to build, store and dispose, use `sudo ./launch.sh`. The resulting archive is saved in the current folder.
- if you want to work on it interactively then
```
$ sudo docker build -t scriptfx/blender_nantille:28 .
$ sudo docker run -ti scriptfx/blender_nantille:28 /bin/bash
```
