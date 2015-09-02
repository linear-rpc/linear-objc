#import "LinearTCPSocket.h"

#include "linear/tcp_socket.h"

@interface LinearSocket(LinearTCPSocketExtern)

- (instancetype)initWithCppSocket:(const linear::Socket&)cppSocket;

@end

@interface LinearTCPSocket()

- (instancetype)initWithCppSocket:(const linear::TCPSocket&)cppSocket;

@end

@implementation LinearTCPSocket

- (instancetype)initWithCppSocket:(const linear::TCPSocket&)cppSocket {
  if (self = [super initWithCppSocket:cppSocket]) {
  }
  return self;
}

@end
