#import "LinearWSSClient.h"

#include "linear/handler.h"
#include "linear/wss_client.h"

@interface LinearWSSSocket(LinearWSSClientExtern)

- (instancetype)initWithCppSocket:(const linear::WSSSocket&)cppSocket;

@end

@interface LinearClient(LinearWSSClientExtern)

- (const linear::Handler&)getHandler;

@end

@interface LinearWSSClient() {
  linear::WSSClient* client;
}
@end

@implementation LinearWSSClient

- (instancetype)init {
  if (self = [super init]) {
    if (!client) {
      client = new linear::WSSClient([super getHandler]);
    }
  }
  return self;
}

- (instancetype)initWithDelegateQueue:(NSOperationQueue *)queue {
  if (self = [super initWithDelegateQueue:queue]) {
    if (!client) {
      client = new linear::WSSClient([super getHandler]);
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

- (LinearWSSSocket *)createSocket :(NSString *)host port:(NSInteger)port {
  LinearWSSSocket *socket = [[LinearWSSSocket alloc] initWithCppSocket:client->CreateSocket([host UTF8String], port)];
  return socket;
}

@end
