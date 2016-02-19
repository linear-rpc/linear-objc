#import "LinearClient.h"
#import "LinearTCPSocket.h"
#import "LinearWSSocket.h"

#if defined(WITH_SSL)
# import "LinearSSLSocket.h"
# import "LinearWSSSocket.h"
#endif

#include "linear/handler.h"

@interface LinearTCPSocket(LinearClientExtern)

- (instancetype)initWithCppSocket:(const linear::Socket&)cppSocket;

@end

@interface LinearWSSocket(LinearClientExtern)

- (instancetype)initWithCppSocket:(const linear::Socket&)cppSocket;

@end

#if defined(WITH_SSL)
@interface LinearSSLSocket(LinearClientExtern)

- (instancetype)initWithCppSocket:(const linear::Socket&)cppSocket;

@end

@interface LinearWSSSocket(LinearClientExtern)

- (instancetype)initWithCppSocket:(const linear::Socket&)cppSocket;

@end
#endif

@interface LinearTypeConverter

+ (id)to_id:(const linear::type::any&)from;

@end

@interface LinearRequest(LinearClientAddon)

@property (nonatomic, assign, readwrite) NSUInteger msgid;

@end

@interface LinearResponse(LinearClientAddon)

@property (nonatomic, strong, readwrite) LinearRequest *request;

@end

@interface LinearClient()

- (void)onConnect:(const linear::Socket&)cppSocket;
- (void)onDisconnect:(const linear::Socket&)cppSocket error:(const linear::Error&)cppError;
- (void)onMessage:(const linear::Socket&)cppSocket message:(const linear::Message&)cppMessage;
- (void)onError:(const linear::Socket&)cppSocket message:(const linear::Message&)cppMessage error:(const linear::Error&)cppError;

@end

class cppHandler : public linear::Handler {
public:
  cppHandler(LinearClient* client) : client_(client) {}
  ~cppHandler() {}

  void OnConnect(const linear::Socket& socket) {
    [client_ onConnect:socket];
  }
  void OnDisconnect(const linear::Socket& socket, const linear::Error& error) {
    [client_ onDisconnect:socket error:error];
  }
  void OnMessage(const linear::Socket& socket, const linear::Message& message) {
    [client_ onMessage:socket message:message];
  }
  void OnError(const linear::Socket& socket, const linear::Message& message, const linear::Error& error) {
    [client_ onError:socket message:message error:error];
  }

private:
  LinearClient* client_;
};

@interface LinearClient() {
  linear::shared_ptr<cppHandler> handler;
}
@end

@implementation LinearClient

- (instancetype)init {
  if (self = [super init]) {
    if (!handler) {
      handler = linear::shared_ptr<cppHandler>(new cppHandler(self));
    }
    _queue = [[NSOperationQueue alloc] init];
  }
  return self;
}

- (instancetype)initWithDelegateQueue:(NSOperationQueue *)queue {
  if (self = [super init]) {
    if (!handler) {
      handler = linear::shared_ptr<cppHandler>(new cppHandler(self));
    }
    _queue = queue;
  }
  return self;
}

- (void)dealloc {
}

- (const linear::shared_ptr<cppHandler>&)getHandler {
  return handler;
}

- (void)onConnect:(const linear::Socket&)cppSocket {
  if ([_delegate respondsToSelector:@selector(onConnect:)]) {
    @autoreleasepool {
      LinearSocket *socket;
      switch (cppSocket.GetType()) {
      case linear::Socket::TCP:
        socket = [[LinearTCPSocket alloc] initWithCppSocket:cppSocket];
        break;
      case linear::Socket::WS:
        socket = [[LinearWSSocket alloc] initWithCppSocket:cppSocket];
        break;
#if defined(WITH_SSL)
      case linear::Socket::WSS:
        socket = [[LinearWSSSocket alloc] initWithCppSocket:cppSocket];
        break;
#endif
      default:
        return;
      }
      [_queue addOperationWithBlock:^{
          [_delegate onConnect:socket];
        }];
    }
  }
}

- (void)onDisconnect:(const linear::Socket&)cppSocket error:(const linear::Error&)cppError {
  if ([_delegate respondsToSelector:@selector(onDisconnect:error:)]) {
    @autoreleasepool {
      LinearSocket *socket;
      switch (cppSocket.GetType()) {
      case linear::Socket::TCP:
        socket = [[LinearTCPSocket alloc] initWithCppSocket:cppSocket];
        break;
      case linear::Socket::WS:
        socket = [[LinearWSSocket alloc] initWithCppSocket:cppSocket];
        break;
#if defined(WITH_SSL)
      case linear::Socket::SSL:
        socket = [[LinearSSLSocket alloc] initWithCppSocket:cppSocket];
        break;
      case linear::Socket::WSS:
        socket = [[LinearWSSSocket alloc] initWithCppSocket:cppSocket];
        break;
#endif
      default:
        return;
      }
      LinearError *error = [[LinearError alloc] initWithErrorCode:(LinearErrorCode)cppError.Code()];
      [_queue addOperationWithBlock:^{
          [_delegate onDisconnect:socket error:error];
        }];
    }
  }
}

- (void)onMessage:(const linear::Socket&)cppSocket message:(const linear::Message&)cppMessage {
  if ([_delegate respondsToSelector:@selector(onMessage:message:)]) {
    @autoreleasepool {
      LinearSocket *socket;
      switch (cppSocket.GetType()) {
      case linear::Socket::TCP:
        socket = [[LinearTCPSocket alloc] initWithCppSocket:cppSocket];
        break;
      case linear::Socket::WS:
        socket = [[LinearWSSocket alloc] initWithCppSocket:cppSocket];
        break;
#if defined(WITH_SSL)
      case linear::Socket::SSL:
        socket = [[LinearSSLSocket alloc] initWithCppSocket:cppSocket];
        break;
      case linear::Socket::WSS:
        socket = [[LinearWSSSocket alloc] initWithCppSocket:cppSocket];
        break;
#endif
      default:
        return;
      }
      LinearMessage *message;
      switch (cppMessage.type) {
      case linear::REQUEST:
        {
          const linear::Request& cppRequest = cppMessage.as<linear::Request>();
          LinearRequest *objcRequest = [[LinearRequest alloc] init];
          objcRequest.msgid = cppRequest.msgid;
          objcRequest.method = [[NSString alloc] initWithUTF8String:cppRequest.method.c_str()];
          objcRequest.params = [LinearTypeConverter to_id:cppRequest.params];
          message = (LinearMessage*)objcRequest;
        }
        break;
      case linear::RESPONSE:
        {
          const linear::Response& cppResponse = cppMessage.as<linear::Response>();
          LinearRequest *objcRequest = [[LinearRequest alloc] init];
          objcRequest.msgid = cppResponse.request.msgid;
          objcRequest.method = [[NSString alloc] initWithUTF8String:cppResponse.request.method.c_str()];
          objcRequest.params = [LinearTypeConverter to_id:cppResponse.request.params];
          
          LinearResponse *objcResponse = [[LinearResponse alloc] init];
          objcResponse.request = objcRequest;
          objcResponse.msgid = cppResponse.msgid;
          objcResponse.result = [LinearTypeConverter to_id:cppResponse.result];
          objcResponse.error = [LinearTypeConverter to_id:cppResponse.error];
          message = (LinearMessage*)objcResponse;
        }
        break;
      case linear::NOTIFY:
        {
          const linear::Notify& cppNotify = cppMessage.as<linear::Notify>();
          LinearNotify *objcNotify = [[LinearNotify alloc] init];
          objcNotify.name = [[NSString alloc] initWithUTF8String:cppNotify.method.c_str()];
          objcNotify.data = [LinearTypeConverter to_id:cppNotify.params];
          message = (LinearMessage*)objcNotify;
        }
        break;
      default:
        return;
      }
      [_queue addOperationWithBlock:^{
          [_delegate onMessage:socket message:message];
        }];
    }
  }
}

- (void)onError:(const linear::Socket&)cppSocket message:(const linear::Message&)cppMessage error:(const linear::Error&)cppError {
  if ([_delegate respondsToSelector:@selector(onError:message:error:)]) {
    @autoreleasepool {
      LinearSocket *socket;
      switch (cppSocket.GetType()) {
      case linear::Socket::TCP:
        socket = [[LinearTCPSocket alloc] initWithCppSocket:cppSocket];
        break;
      case linear::Socket::WS:
        socket = [[LinearWSSocket alloc] initWithCppSocket:cppSocket];
        break;
#if defined(WITH_SSL)
      case linear::Socket::SSL:
        socket = [[LinearSSLSocket alloc] initWithCppSocket:cppSocket];
        break;
      case linear::Socket::WSS:
        socket = [[LinearWSSSocket alloc] initWithCppSocket:cppSocket];
        break;
#endif
      default:
        return;
      }
      LinearMessage *message;
      LinearError *error = [[LinearError alloc] initWithErrorCode:(LinearErrorCode)cppError.Code()];
      switch (cppMessage.type) {
      case linear::REQUEST:
        {
          const linear::Request& cppRequest = cppMessage.as<linear::Request>();
          LinearRequest *objcRequest = [[LinearRequest alloc] init];
          objcRequest.msgid = cppRequest.msgid;
          objcRequest.method = [[NSString alloc] initWithUTF8String:cppRequest.method.c_str()];
          objcRequest.params = [LinearTypeConverter to_id:cppRequest.params];
          message = (LinearMessage*)objcRequest;
        }
        break;
      case linear::RESPONSE:
        {
          const linear::Response& cppResponse = cppMessage.as<linear::Response>();
          LinearRequest *objcRequest = [[LinearRequest alloc] init];
          objcRequest.msgid = cppResponse.request.msgid;
          objcRequest.method = [[NSString alloc] initWithUTF8String:cppResponse.request.method.c_str()];
          objcRequest.params = [LinearTypeConverter to_id:cppResponse.request.params];

          LinearResponse *objcResponse = [[LinearResponse alloc] init];
          objcResponse.request = objcRequest;
          objcResponse.msgid = cppResponse.msgid;
          objcResponse.result = [LinearTypeConverter to_id:cppResponse.result];
          objcResponse.error = [LinearTypeConverter to_id:cppResponse.error];
          message = (LinearMessage*)objcResponse;
        }
        break;
      case linear::NOTIFY:
        {
          const linear::Notify& cppNotify = cppMessage.as<linear::Notify>();
          LinearNotify *objcNotify = [[LinearNotify alloc] init];
          objcNotify.name = [[NSString alloc] initWithUTF8String:cppNotify.method.c_str()];
          objcNotify.data = [LinearTypeConverter to_id:cppNotify.params];
          message = (LinearMessage*)objcNotify;
        }
        break;
      default:
        return;
      }
      [_queue addOperationWithBlock:^{
          [_delegate onError:socket message:message error:error];
        }];
    }
  }
}

@end
