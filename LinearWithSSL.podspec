Pod::Spec.new do |s|
  s.name = 'LinearWithSSL'
  s.version = '0.6.6'
  s.summary = 'a msgpack-rpc implementation for Objective-C'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage = 'https://github.com/linear-rpc/linear-objc'
  s.authors = { 'Norio Kobota' => 'Norio.Kobota@jp.sony.com' }
  s.source = { :git => 'https://github.com/linear-rpc/linear-objc', :submodules => true }
  s.platform = :ios, '7.0'
  s.prepare_command = <<-PREPROCESS
(
./build-universal.sh --with-ssl
)
PREPROCESS

  @headers = [
    'workspace/universal/include/LinearAddrInfo.h',
    'workspace/universal/include/LinearAuthContext.h',
    'workspace/universal/include/LinearClient.h',
    'workspace/universal/include/LinearError.h',
    'workspace/universal/include/LinearLog.h',
    'workspace/universal/include/LinearMessage.h',
    'workspace/universal/include/LinearSocket.h',
    'workspace/universal/include/LinearTCPClient.h',
    'workspace/universal/include/LinearTCPSocket.h',
    'workspace/universal/include/LinearWSClient.h',
    'workspace/universal/include/LinearWSContext.h',
    'workspace/universal/include/LinearWSSocket.h',
    'workspace/universal/include/LinearSSLContext.h',
    'workspace/universal/include/LinearX509Certificate.h',
    'workspace/universal/include/LinearSSLClient.h',
    'workspace/universal/include/LinearSSLSocket.h',
    'workspace/universal/include/LinearWSSClient.h',
    'workspace/universal/include/LinearWSSSocket.h'
  ]

  @libraries = [
    'workspace/universal/lib/liblinear_objc.a',
    'workspace/universal/lib/liblinear.a',
    'workspace/universal/lib/libtv.a',
    'workspace/universal/lib/libuv.a',
    'deps/OpenSSL-for-iPhone/lib/libcrypto.a',
    'deps/OpenSSL-for-iPhone/lib/libssl.a'
  ]

  @libs = [
    'linear_objc', 'linear', 'tv', 'uv', 'crypto', 'ssl'
  ]

  s.source_files = @headers
  s.vendored_libraries = @libraries
  s.libraries = @libs
  s.xcconfig = { 'OTHER_LDFLAGS' => '-lstdc++' }
  s.requires_arc = true
end
