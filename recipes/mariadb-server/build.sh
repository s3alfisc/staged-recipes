#!/usr/bin/env bash
set -e -x

# Copy mariadb-connector-c to server
cp -R ./connector/mariadb-connector-c-${version_connector} ./server/libmariadb/

# Now move to server folder
cd ./server/

git submodule update --init --recursive

# Make build directory
mkdir build
cd build

# Build
cmake ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_SKIP_INSTALL_ALL_DEPENDENCY=ON \
    -DCMAKE_EXE_LINKER_FLAGS="-ltcmalloc" \
    -DWITH_SAFEMALLOC=OFF \
    -DBUILD_CONFIG=mysql_release \
    ..

make -k -j${CPU_COUNT}

# Test
cmake --build . --target test

# Build
cmake --build . --verbose