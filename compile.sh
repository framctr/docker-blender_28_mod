#!/bin/bash

# Build
cd /usr/src/blender/blender_28_mod
make update
make

# Create package
cd /home
cpack -G TGZ --config /usr/src/blender/build_linux/CPackConfig.cmake
echo $(ls blender-2.8*.tar.gz) created
mv blender-2.8*-x86_64.tar.gz blender_28_mod-x86_64.tar.gz