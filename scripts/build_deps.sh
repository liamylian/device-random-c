#!/bin/sh

# Build dependencies
#
#   build_deps.sh <build-csdk>
#
#   Options:
#   build-csdk: 1 to build EdgeX C SDK, 0 to skip
#
set -e -x

BUILD_CSDK=$1

CBOR_VERSION=0.7.0
CSDK_VERSION=2.1.0

if [ -d /tmp/deps ]
then
  exit 0
fi
mkdir /tmp/deps

# Solve git clone problem: HTTP/2 stream 1 was not closed cleanly before end of the underlying stream
# git config --global http.version HTTP/1.1

# Get c-sdk from edgexfoundry and build
if [ "$BUILD_CSDK" = "1" ]
then
  cd /tmp/deps
  git clone https://github.com/PJK/libcbor.git
  cd libcbor
  git reset --hard v${CBOR_VERSION}
  mkdir -p build && cd build
  cmake -DCMAKE_BUILD_TYPE=Release -DCBOR_CUSTOM_ALLOC=ON ..
  make
  make install

  cd /tmp/deps
  wget https://github.com/edgexfoundry/device-sdk-c/archive/v${CSDK_VERSION}.zip
  unzip v${CSDK_VERSION}.zip
  cd device-sdk-c-${CSDK_VERSION}
  ./scripts/build.sh
  cp -rf include/* /usr/include/
  cp build/release/c/libcsdk.so /usr/lib/
fi

rm -rf /tmp/deps

