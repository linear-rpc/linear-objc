SUBDIRS = .

lib_LTLIBRARIES = liblinear_objc.la

liblinear_objc_la_OBJCFLAGS = \
	-I$(top_srcdir)/include \
	-I$(top_srcdir)/deps/linear-cpp/deps/libtv/include \
	-I$(top_srcdir)/deps/linear-cpp/deps/libtv/deps/libuv/include \
	-I$(top_srcdir)/deps/linear-cpp/deps/msgpack/include \
	-I$(top_srcdir)/deps/linear-cpp/include \
	-I$(top_srcdir)/deps/OpenSSL-for-iPhone/include

liblinear_objc_la_OBJCXXFLAGS = \
	-I$(top_srcdir)/include \
	-I$(top_srcdir)/deps/linear-cpp/deps/libtv/include \
	-I$(top_srcdir)/deps/linear-cpp/deps/libtv/deps/libuv/include \
	-I$(top_srcdir)/deps/linear-cpp/deps/msgpack/include \
	-I$(top_srcdir)/deps/linear-cpp/include \
	-I$(top_srcdir)/deps/OpenSSL-for-iPhone/include

liblinear_objc_la_SOURCES = \
	LinearAddrInfo.m \
	LinearAuthContext.m \
	LinearError.m \
	LinearMessage.m \
	LinearLog.mm \
	LinearWSContext.m \
	LinearSocket.mm \
	LinearTCPSocket.mm \
	LinearWSSocket.mm \
	LinearClient.mm \
	LinearTCPClient.mm \
	LinearWSClient.mm \
	LinearTypeConverter.mm

if WITH_SSL
liblinear_objc_la_SOURCES += \
	LinearSSLSocket.mm \
	LinearSSLClient.mm \
	LinearWSSSocket.mm \
	LinearWSSClient.mm
endif

clean-local:
	rm -f *~
