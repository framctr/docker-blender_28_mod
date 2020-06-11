# Build a portable nantille/blender_28_mod in a virtual env.
#
# Useful link at https://wiki.blender.org/wiki/Building_Blender/Linux/Fedora

FROM centos:7.4.1708

LABEL mantainer="Francesco Maria Cultrera"
LABEL mantainer-mail="scriptfx@outlook.it"

# Blender 2.8 requires Python 3.7
ENV PY3VER=3.7.7

# Blender branch from which to build
# if you want latest alpha set it to "master"
ENV BRANCH=blender-v2.83-release
ENV TG_LIB=blender-2.83-release

# Update sys and install needed packages
RUN yum -y update \
 && yum install -y epel-release centos-release-scl \ 
 && yum clean all \
 && yum install -y \
        gcc \
        gcc-c++ \
        git \
        subversion \
        wget \
        make \
        cmake \
        cmake3 \
        openssl-devel \
        bzip2-devel \
        libffi-devel \
        libX11-devel \
        libXi-devel \
        libXcursor-devel \
        libXrandr-devel \
        libXinerama-devel \
        libXxf86vm-devel \
        libstdc++-static \
        devtoolset-7-gcc-c++ \
        rpm-build \
        mesa-libGLU-devel \
 && yum clean all

# Use cmake3 instead of version 2
RUN alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake3 20 \
    --slave /usr/local/bin/ctest ctest /usr/bin/ctest3 \
    --slave /usr/local/bin/cpack cpack /usr/bin/cpack3 \
    --slave /usr/local/bin/ccmake ccmake /usr/bin/ccmake3 \
    --family cmake

# Build Python 3.7 and install pip (useful if you 
# won't have an option to install it later)
RUN mkdir /usr/src/python37 \
 && cd /usr/src/python37 \
 && wget https://www.python.org/ftp/python/$PY3VER/Python-$PY3VER.tgz \
 && tar xzf Python-$PY3VER.tgz \
 && cd Python-$PY3VER \
 && ./configure --enable-optimizations \
 && make altinstall \
 && curl https://bootstrap.pypa.io/get-pip.py | python3.7 \
 && pip3 install --upgrade pip

# Get blender mod and precompiled library dependencies
RUN mkdir /usr/src/blender \
 && cd /usr/src/blender \
 && git clone git://github.com/nantille/blender_28_mod \
 && mkdir /usr/src/blender/lib \
 && cd /usr/src/blender/lib \
 && svn checkout https://svn.blender.org/svnroot/bf-blender/tags/$TG_LIB/lib/linux_centos7_x86_64/ \
 && cd /usr/src/blender/blender_28_mod \
 && git config --global user.name 'Marco Polo' \
 && git config --global user.email '<>' \
 && git pull --rebase http://git.blender.org/blender.git $BRANCH \
 && git remote set-url origin git://git.blender.org/blender.git \
 && git submodule sync \
 && git submodule update --init --recursive \
 && git submodule foreach git checkout $BRANCH \
 && git submodule foreach git pull --rebase origin $BRANCH \
 && git remote set-url origin https://github.com/nantille/blender_28_mod.git

# Build and package it
COPY compile.sh /usr/src/
RUN chmod +x /usr/src/compile.sh \
 && scl enable devtoolset-7 /usr/src/compile.sh
