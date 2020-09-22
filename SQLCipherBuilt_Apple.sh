#!/usr/bin/env bash
#---------------------------------------------------------------------------------------------
# Version example : 3310100
#---------------------------------------------------------------------------------------------

if [ "$#" -ne 1 ]
then
    echo "Usage:"
    echo "./SQLCipherBuilt_Apple.sh <VERSION>"
    exit 1
fi

VERSION=$1

#---------------------------------------------------------------------------------------------
# Config
#---------------------------------------------------------------------------------------------

SQLITE_CFLAGS=" \
-DSQLITE_HAS_CODEC \
-DSQLITE_THREADSAFE=1 \
-DSQLITE_TEMP_STORE=2 \
"

LDFLAGS="\
-framework Security \
-framework Foundation \
"

COMPILE_OPTION=" \
--with-pic \
--disable-tcl \
--enable-tempstore=yes \
--enable-threadsafe=yes \
--with-crypto-lib=commoncrypto \
"

#---------------------------------------------------------------------------------------------
# Download sources
#---------------------------------------------------------------------------------------------
#prepare dir to compile

mkdir ./tmp
mkdir ./tmp/${VERSION}
cd ./tmp/${VERSION}/

#Download sources files from SQLite

curl -OL https://github.com/sqlcipher/sqlcipher/archive/v${VERSION}.zip
tar -xvf v${VERSION}.zip
cd sqlcipher-${VERSION}

#---------------------------------------------------------------------------------------------
# for Apple©
#---------------------------------------------------------------------------------------------

DEVELOPER=$(xcode-select -print-path)
TOOLCHAIN_BIN="${DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin"
export CC="${TOOLCHAIN_BIN}/clang"
export AR="${TOOLCHAIN_BIN}/ar"
export RANLIB="${TOOLCHAIN_BIN}/ranlib"
export STRIP="${TOOLCHAIN_BIN}/strip"
export LIBTOOL="${TOOLCHAIN_BIN}/libtool"
export NM="${TOOLCHAIN_BIN}/nm"
export LD="${TOOLCHAIN_BIN}/ld"

#---------------------------------------------------------------------------------------------
# iOS (iPhone / iPad)
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

./configure ${COMPILE_OPTION} \
--host="$HOST" \
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

./configure ${COMPILE_OPTION} \
--host="$HOST" \
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

./configure ${COMPILE_OPTION} \
--host="$HOST" \
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

./configure ${COMPILE_OPTION} \
--host="$HOST" \
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

rm ./${VERSION}/iOS/libsqlcipher.a
lipo -create -output "./${VERSION}/iOS/libsqlcipher.a" "./tmp/${VERSION}/sqlcipher-${VERSION}/armv7/libsqlcipher.a" "./tmp/${VERSION}/sqlcipher-${VERSION}/armv7s/libsqlcipher.a" "./tmp/${VERSION}/sqlcipher-${VERSION}/arm64/libsqlcipher.a" "./tmp/${VERSION}/sqlcipher-${VERSION}/x86_64/libsqlcipher.a"

open ./${VERSION}

File ./${VERSION}/libsqlcipher.a

#---------------------------------------------------------------------------------------------

cd ./tmp/${VERSION}/sqlcipher-${VERSION}/

#---------------------------------------------------------------------------------------------
# tvOS (Apple TV)
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

./configure ${COMPILE_OPTION} \
--host="$HOST" \
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
-arch ${ARCH} \
-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
-mtvos-version-min=${TVOS_MIN_SDK_VERSION} \
"

make clean

./configure ${COMPILE_OPTION} \
--host="$HOST" \
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

rm ./${VERSION}/tvOS/libsqlcipher.a
lipo -create -output "./${VERSION}/tvOS/libsqlcipher.a" "./tmp/${VERSION}/sqlcipher-${VERSION}/arm64/libsqlcipher.a" "./tmp/${VERSION}/sqlcipher-${VERSION}/x86_64/libsqlcipher.a"

open ./${VERSION}

File ./${VERSION}/tvOS/libsqlcipher.a

#---------------------------------------------------------------------------------------------

cd ./tmp/${VERSION}/sqlcipher-${VERSION}/

#---------------------------------------------------------------------------------------------
# remove export for iOS tvOS
#---------------------------------------------------------------------------------------------
unset CC
unset AR
unset RANLIB
unset STRIP
unset LIBTOOL
unset NM
unset LD
unset CROSS_TOP
unset CROSS_SDK
#---------------------------------------------------------------------------------------------
# macOS (OSX)
#---------------------------------------------------------------------------------------------

CFLAGS=" \
-arch x86_64 \
-mmacos-version-min=10.10 \
"

make clean

./configure ${COMPILE_OPTION} \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make

#Copy result

cd ..
cd ..
cd .. 

mkdir ./${VERSION}
mkdir ./${VERSION}/macOS
rm  ./${VERSION}/macOS/sqlcipher.bundle

cp ./tmp/${VERSION}/sqlcipher-${VERSION}/.libs/libsqlcipher.0.dylib ./${VERSION}/macOS/sqlcipher.bundle

#---------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------
# Clean all sources and files
#---------------------------------------------------------------------------------------------

rm -r ./tmp

