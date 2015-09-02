#import "LinearSSLSocket.h"

#include "linear/ssl_socket.h"

@interface LinearSocket(LinearSSLSocketExtern)

- (instancetype)initWithCppSocket:(const linear::Socket&)cppSocket;

@end

@interface LinearSSLSocket()

- (instancetype)initWithCppSocket:(const linear::SSLSocket&)cppSocket;

@end

@implementation LinearSSLSocket

- (instancetype)initWithCppSocket:(const linear::SSLSocket&)cppSocket {
  if (self = [super initWithCppSocket:cppSocket]) {
  }
  return self;
}

@end
