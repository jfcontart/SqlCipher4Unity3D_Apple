#!/usr/bin/env bash

# Version example : 3310100

if [ "$#" -ne 1 ]
then
    echo "Usage:"
    echo "./SQLiteBuilt.sh <VERSION>"
    exit 1
fi

VERSION=$1

DEVELOPER=$(xcode-select -print-path)
TOOLCHAIN_BIN="${DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin"
export CC="${TOOLCHAIN_BIN}/clang"
export AR="${TOOLCHAIN_BIN}/ar"
export RANLIB="${TOOLCHAIN_BIN}/ranlib"
export STRIP="${TOOLCHAIN_BIN}/strip"
export LIBTOOL="${TOOLCHAIN_BIN}/libtool"
export NM="${TOOLCHAIN_BIN}/nm"
export LD="${TOOLCHAIN_BIN}/ld"


#prepare dir to compile

mkdir ./tmp
mkdir ./tmp/${VERSION}
cd ./tmp/${VERSION}/

#Download sources files from SQLite

curl -OL https://github.com/sqlcipher/sqlcipher/archive/v${VERSION}.tar.gz
tar -xvf v${VERSION}.tar.gz
cd sqlcipher-${VERSION}

SQLITE_CFLAGS=" \
-DSQLITE_HAS_CODEC \
-DSQLITE_THREADSAFE=1 \
-DSQLITE_TEMP_STORE=2 \
"

LDFLAGS="\
-framework Security \
-framework Foundation \
"

#---------------------------------------------------------------------------------------------

#Compile for ARMV7
ARCH=armv7
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
  -fembed-bitcode \
  -arch ${ARCH} \
  -isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
  -mios-version-min=${IOS_MIN_SDK_VERSION} \
"

make clean

./configure \
--with-pic \
--disable-tcl \
--host="$HOST" \
--enable-tempstore=yes \
--enable-threadsafe=yes \
--with-crypto-lib=commoncrypto \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make sqlite3.h
make sqlite3ext.h
make libsqlcipher.la

mkdir ./${ARCH}
cp .libs/libsqlcipher.a ${ARCH}/libsqlcipher.a

#---------------------------------------------------------------------------------------------

#Compile for ARMV7s
ARCH=armv7s
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
  -fembed-bitcode \
  -arch ${ARCH} \
  -isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
  -mios-version-min=${IOS_MIN_SDK_VERSION} \
"

make clean

./configure \
--with-pic \
--disable-tcl \
--host="$HOST" \
--enable-tempstore=yes \
--enable-threadsafe=yes \
--with-crypto-lib=commoncrypto \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make sqlite3.h
make sqlite3ext.h
make libsqlcipher.la

mkdir ./${ARCH}
cp .libs/libsqlcipher.a ${ARCH}/libsqlcipher.a

#---------------------------------------------------------------------------------------------

#Compile for ARM64
ARCH=arm64
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
  -fembed-bitcode \
  -arch ${ARCH} \
  -isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
  -mios-version-min=${IOS_MIN_SDK_VERSION} \
"

make clean

./configure \
--with-pic \
--disable-tcl \
--host="$HOST" \
--enable-tempstore=yes \
--enable-threadsafe=yes \
--with-crypto-lib=commoncrypto \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make sqlite3.h
make sqlite3ext.h
make libsqlcipher.la

mkdir ./${ARCH}
cp .libs/libsqlcipher.a ${ARCH}/libsqlcipher.a

#---------------------------------------------------------------------------------------------

#Compile for x86_64
ARCH=x86_64
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneSimulator"
HOST="x86_64-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
  -fembed-bitcode \
  -arch ${ARCH} \
  -isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
  -mios-version-min=${IOS_MIN_SDK_VERSION} \
"

make clean

./configure \
--with-pic \
--disable-tcl \
--host="$HOST" \
--enable-tempstore=yes \
--enable-threadsafe=yes \
--with-crypto-lib=commoncrypto \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make sqlite3.h
make sqlite3ext.h
make libsqlcipher.la

mkdir ./${ARCH}
cp .libs/libsqlcipher.a ${ARCH}/libsqlcipher.a

#---------------------------------------------------------------------------------------------

#LIPO

cd ..
cd ..
cd ..
mkdir ./${VERSION}
mkdir ./${VERSION}/iOS

#mkdir ./${VERSION}/iOS/armv7
#rm ./${VERSION}/iOS/armv7/libsqlcipher.a
#cp ./tmp/${VERSION}/sqlcipher-${VERSION}/armv7/libsqlcipher.a ./${VERSION}/armv7/libsqlcipher.a
#mkdir ./${VERSION}/iOS/armv7s
#rm ./${VERSION}/iOS/armv7s/libsqlcipher.a
#cp ./tmp/${VERSION}/sqlcipher-${VERSION}/armv7s/libsqlcipher.a ./${VERSION}/armv7s/libsqlcipher.a
#mkdir ./${VERSION}/iOS/arm64
#rm ./${VERSION}/iOS/arm64/libsqlcipher.a
#cp ./tmp/${VERSION}/sqlcipher-${VERSION}/arm64/libsqlcipher.a ./${VERSION}/arm64/libsqlcipher.a
#mkdir ./${VERSION}/iOS/x86_64
#rm ./${VERSION}/iOS/x86_64/libsqlcipher.a
#cp ./tmp/${VERSION}/sqlcipher-${VERSION}/x86_64/libsqlcipher.a ./${VERSION}/x86_64/libsqlcipher.a

rm ./${VERSION}/iOS/libsqlcipher.a
lipo -create -output "./${VERSION}/iOS/libsqlcipher.a" "./tmp/${VERSION}/sqlcipher-${VERSION}/armv7/libsqlcipher.a" "./tmp/${VERSION}/sqlcipher-${VERSION}/armv7s/libsqlcipher.a" "./tmp/${VERSION}/sqlcipher-${VERSION}/arm64/libsqlcipher.a" "./tmp/${VERSION}/sqlcipher-${VERSION}/x86_64/libsqlcipher.a"

open ./${VERSION}

File ./${VERSION}/libsqlcipher.a

#---------------------------------------------------------------------------------------------
cd ./tmp/${VERSION}/sqlcipher-${VERSION}/
#---------------------------------------------------------------------------------------------

#Compile for ARM64
ARCH=arm64
TVOS_MIN_SDK_VERSION=10.0
OS_COMPILER="AppleTVOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
  -fembed-bitcode \
  -arch ${ARCH} \
  -isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
  -mtvos-version-min=${TVOS_MIN_SDK_VERSION} \
"

make clean

./configure \
--with-pic \
--disable-tcl \
--host="$HOST" \
--enable-tempstore=yes \
--enable-threadsafe=yes \
--with-crypto-lib=commoncrypto \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make sqlite3.h
make sqlite3ext.h
make libsqlcipher.la

mkdir ./${ARCH}
cp .libs/libsqlcipher.a ${ARCH}/libsqlcipher.a

#---------------------------------------------------------------------------------------------

#Compile for x86_64
ARCH=x86_64
TVOS_MIN_SDK_VERSION=10.0
OS_COMPILER="AppleTVSimulator"
HOST="x86_64-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
  -fembed-bitcode \
  -arch ${ARCH} \
  -isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
  -mtvos-version-min=${TVOS_MIN_SDK_VERSION} \
"

make clean

./configure \
--with-pic \
--disable-tcl \
--host="$HOST" \
--enable-tempstore=yes \
--enable-threadsafe=yes \
--with-crypto-lib=commoncrypto \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make sqlite3.h
make sqlite3ext.h
make libsqlcipher.la

mkdir ./${ARCH}
cp .libs/libsqlcipher.a ${ARCH}/libsqlcipher.a

#---------------------------------------------------------------------------------------------

#LIPO

cd ..
cd ..
cd ..
mkdir ./${VERSION}
mkdir ./${VERSION}/tvOS

#mkdir ./${VERSION}/tvOS/arm64
#rm ./${VERSION}/tvOS/arm64/libsqlcipher.a
#cp ./tmp/${VERSION}/sqlcipher-${VERSION}/arm64/libsqlcipher.a ./${VERSION}/tvOS/arm64/libsqlcipher.a
#mkdir ./${VERSION}/tvOS/x86_64
#rm ./${VERSION}/tvOS/x86_64/libsqlcipher.a
#cp ./tmp/${VERSION}/sqlcipher-${VERSION}/x86_64/libsqlcipher.a ./${VERSION}/tvOS/x86_64/libsqlcipher.a

rm ./${VERSION}/tvOS/libsqlcipher.a
lipo -create -output "./${VERSION}/tvOS/libsqlcipher.a" "./tmp/${VERSION}/sqlcipher-${VERSION}/arm64/libsqlcipher.a" "./tmp/${VERSION}/sqlcipher-${VERSION}/x86_64/libsqlcipher.a"

open ./${VERSION}

File ./${VERSION}/tvOS/libsqlcipher.a

#---------------------------------------------------------------------------------------------
cd ./tmp/${VERSION}/sqlcipher-${VERSION}/
#---------------------------------------------------------------------------------------------

ARCH=x86_64

CFLAGS="\
  -fembed-bitcode \
  -arch ${ARCH} \
  -mmacos-version-min=10.10 \
"

make clean

./configure \
--enable-tempstore= yes \
--enable-load-extension \
--disable-tcl \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make

#Copy result

cd ..
cd ..
cd .. 

mkdir ./${VERSION}
mkdir ./${VERSION}/macOS
rm  ./${VERSION}/macOS/libsqlcipher.0.dylib

cp ./tmp/${VERSION}/sqlcipher-${VERSION}/.libs/libsqlcipher.0.dylib ./${VERSION}/macOS/sqlcipher.bundle

#---------------------------------------------------------------------------------------------


#Clean 

rm -r ./tmp

