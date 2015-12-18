#import "LinearSSLClient.h"

#include "linear/handler.h"
#include "linear/ssl_client.h"

@interface LinearSSLSocket(LinearSSLClientExtern)

- (instancetype)initWithCppSocket:(const linear::SSLSocket&)cppSocket;

@end

@interface LinearClient(LinearSSLClientExtern)

- (const linear::shared_ptr<linear::Handler>&)getHandler;

@end

@interface LinearSSLClient() {
  linear::SSLClient* client;
}
@end

// TODO: SSLContext
@implementation LinearSSLClient

- (instancetype)init {
  if (self = [super init]) {
    if (!client) {
      client = new linear::SSLClient([super getHandler]);
    }
  }
  return self;
}

- (instancetype)initWithDelegateQueue:(NSOperationQueue *)queue {
  if (self = [super initWithDelegateQueue:queue]) {
    if (!client) {
      client = new linear::SSLClient([super getHandler]);
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

- (LinearSSLSocket *)createSocket :(NSString *)host port:(NSInteger)port {
  LinearSSLSocket *socket = [[LinearSSLSocket alloc] initWithCppSocket:client->CreateSocket([host UTF8String], port)];
  return socket;
}

@end
