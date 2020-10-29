#!/bin/sh

## settings
SUPPORTED_ARCH="arm64 arm64e i386 x86_64"
COMMON_CFLAGS="-Os"
## end settings

XCRUN=`which xcrun`
LIPO=`which lipo`

if [ "$XCRUN" = "" -o "$LIPO" = "" ]; then
    echo "needs xcrun and lipo"
    exit 1
fi

COMMON_CONFIGURE_FLAGS=
WORKSPACE="`pwd`/workspace"

while (( $# > 0))
do
    if [ "`echo "$1" | grep "\--with-ssl="`" != "" ]; then
        COMMON_CONFIGURE_FLAGS="$COMMON_CONFIGURE_FLAGS $1"
    elif [ "`echo "$1" | grep "\--with-ssl"`" != "" ]; then
        COMMON_CONFIGURE_FLAGS="$COMMON_CONFIGURE_FLAGS --with-ssl=`pwd`/deps/Build-OpenSSL-cURL/openssl/iOS-fat"
    else
        COMMON_CONFIGURE_FLAGS="$COMMON_CONFIGURE_FLAGS $1"
    fi
    shift
done

if [ "`echo ${COMMON_CONFIGURE_FLAGS} | grep "\--with-ssl"`" == "" ]; then
    COMMON_CONFIGURE_FLAGS="$COMMON_CONFIGURE_FLAGS --without-ssl"
fi

do_configure() {
    TARGET_ARCH=$1
    CFLAGS="${COMMON_CFLAGS}"
    SDK_VERSION=`$XCRUN -sdk iphoneos --show-sdk-version | bc`
    if [ `echo "$SDK_VERSION >= 9.0" | bc` == 1 ]; then
	if [ "$TARGET_ARCH" == "i386" -o "$TARGET_ARCH" == "x86_64" ]; then
	    CFLAGS="${CFLAGS}"
	else
            CFLAGS="-fembed-bitcode ${CFLAGS}"
	fi
    fi
    case ${TARGET_ARCH} in
	armv7)
	    TARGET_HOST_OPTION="--host=arm-apple-darwin"
	    SDK_DIR="`$XCRUN -sdk iphoneos --show-sdk-path`"
	    CFLAGS="-arch armv7 ${CFLAGS} -D__ARM_EABI__" ## TODO: should use -target arm-darwin-eabi
	    ;;
	armv7s)
	    TARGET_HOST_OPTION="--host=arm-apple-darwin"
	    SDK_DIR="`$XCRUN -sdk iphoneos --show-sdk-path`"
	    CFLAGS="-arch armv7s ${CFLAGS} -D__ARM_EABI__" ## TODO: should use -target arm-darwin-eabi
	    ;;
	arm64)
	    TARGET_HOST_OPTION="--host=arm-apple-darwin"
	    SDK_DIR="`$XCRUN -sdk iphoneos --show-sdk-path`"
	    CFLAGS="-arch arm64 ${CFLAGS}"
	    ;;
	arm64e)
	    TARGET_HOST_OPTION="--host=arm-apple-darwin"
	    SDK_DIR="`$XCRUN -sdk iphoneos --show-sdk-path`"
	    CFLAGS="-arch arm64e ${CFLAGS}"
	    ;;
	i386)
	    TARGET_HOST_OPTION="--host=i386-apple-darwin"
	    SDK_DIR="`$XCRUN -sdk iphonesimulator --show-sdk-path`"
	    CFLAGS="-arch i386 ${CFLAGS}"
	    ;;
	x86_64)
	    TARGET_HOST_OPTION="--host=x86_64-apple-darwin"
	    SDK_DIR="`$XCRUN -sdk iphonesimulator --show-sdk-path`"
	    CFLAGS="-arch x86_64 ${CFLAGS}"
	    ;;
	*)
	    echo "error: ${TARGET_ARCH} is not supported"
	    exit 1;
    esac

    export CC=clang
    export CXX=clang++
    export OBJC=clang
    export OBJCXX=clang++
    export AR=ar
    export AS=as
    export LD=ld
    export RANLIB=ranlib
    export CFLAGS="-isysroot ${SDK_DIR} -miphoneos-version-min=7.0 -D__IPHONE_OS_VERSION_MIN_REQUIRED=70000 ${CFLAGS}"
    export CXXFLAGS=${CFLAGS}
    export OBJCFLAGS=${CFLAGS}
    export OBJCXXFLAGS=${OBJCFLAGS}

    /bin/sh ./configure ${TARGET_HOST_OPTION} --disable-shared --prefix=${WORKSPACE}/${TARGET_ARCH} ${COMMON_CONFIGURE_FLAGS}
}

# openssl
if [ "`echo "$COMMON_CONFIGURE_FLAGS" | grep "\--with-ssl"`" != "" ]; then
    (
        cd deps/Build-OpenSSL-cURL
        ./build.sh
    )
fi

rm -fr ${WORKSPACE}
./bootstrap

set -e
for arch in ${SUPPORTED_ARCH}; do
    mkdir -p ${WORKSPACE}/${arch}
    do_configure ${arch}
    make clean all install
done

mkdir -p ${WORKSPACE}/universal/lib
temp=`echo ${SUPPORTED_ARCH} | cut -d " " -f 1`
cp -rf ${WORKSPACE}/${temp}/include/ ${WORKSPACE}/universal/include/
TARGET_LIBS="`ls ${WORKSPACE}/${temp}/lib/*.a | rev | cut -d '/' -f 1 | rev`"
for lib in ${TARGET_LIBS}; do
    LIBS=
    for arch in ${SUPPORTED_ARCH}; do
	LIBS="${WORKSPACE}/${arch}/lib/${lib} $LIBS"
    done
    ${LIPO} ${LIBS} -create -output ${WORKSPACE}/universal/lib/${lib}
done
