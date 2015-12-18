#import "LinearWSClient.h"

#include "linear/handler.h"
#include "linear/ws_client.h"

@interface LinearWSSocket(LinearWSClientExtern)

- (instancetype)initWithCppSocket:(const linear::WSSocket&)cppSocket;

@end

@interface LinearClient(LinearWSClientExtern)

- (const linear::shared_ptr<linear::Handler>&)getHandler;

@end

@interface LinearWSClient() {
  linear::WSClient* client;
}
@end

@implementation LinearWSClient

- (instancetype)init {
  if (self = [super init]) {
    if (!client) {
      client = new linear::WSClient([super getHandler]);
    }
  }
  return self;
}

- (instancetype)initWithDelegateQueue:(NSOperationQueue *)queue {
  if (self = [super initWithDelegateQueue:queue]) {
    if (!client) {
      client = new linear::WSClient([super getHandler]);
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

- (LinearWSSocket *)createSocket :(NSString *)host port:(NSInteger)port {
  LinearWSSocket *socket = [[LinearWSSocket alloc] initWithCppSocket:client->CreateSocket([host UTF8String], port)];
  return socket;
}

@end
