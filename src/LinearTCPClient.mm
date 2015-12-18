#import "LinearTCPClient.h"

#include "linear/handler.h"
#include "linear/tcp_client.h"

@interface LinearTCPSocket(LinearTCPClientExtern)

- (instancetype)initWithCppSocket:(const linear::TCPSocket&)cppSocket;

@end

@interface LinearClient(LinearTCPClientExtern)

- (const linear::shared_ptr<linear::Handler>&)getHandler;

@end

@interface LinearTCPClient() {
  linear::TCPClient* client;
}
@end

@implementation LinearTCPClient

- (instancetype)init {
  if (self = [super init]) {
    if (!client) {
      client = new linear::TCPClient([super getHandler]);
    }
  }
  return self;
}

- (instancetype)initWithDelegateQueue:(NSOperationQueue *)queue {
  if (self = [super initWithDelegateQueue:queue]) {
    if (!client) {
      client = new linear::TCPClient([super getHandler]);
    }
  }
  return self;
}

- (void)dealloc {
  if (client) {
    delete client;
    client = NULL;
  }
}

- (LinearTCPSocket *)createSocket :(NSString *)host port:(NSInteger)port {
  LinearTCPSocket *socket = [[LinearTCPSocket alloc] initWithCppSocket:client->CreateSocket([host UTF8String], port)];
  return socket;
}

@end
