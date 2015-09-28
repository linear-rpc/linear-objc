#import "LinearError.h"
#import "LinearMessage.h"
#import "LinearSocket.h"

#include "linear/socket.h"
#include "linear/message.h"

@interface LinearTypeConverter

+ (linear::type::any)to_any:(id)from;

@end

@interface LinearRequest(LinearSocketAddon)

@property (nonatomic, assign, readwrite) NSUInteger msgid;

@end

@interface LinearSocket () {
  linear::Socket socket;
}

- (instancetype)initWithCppSocket:(const linear::Socket&)cppSocket;
- (const linear::Socket&)getCppSocket;
- (LinearError *)send:(LinearMessage *)message;
- (LinearError *)send:(LinearMessage *)message timeout:(NSInteger)timeout;

@end

@implementation LinearSocket

- (instancetype)initWithCppSocket:(const linear::Socket&)cppSocket {
  if (self = [super init]) {
    socket = cppSocket;
  }
  return self;
}

- (const linear::Socket&)getCppSocket {
  return socket;
}

- (NSInteger)ident {
  return socket.GetId();
}

- (LinearSocketType)type {
  switch (socket.GetType()) {
  case linear::Socket::TCP:
    return LinearSocketTypeTCP;
  case linear::Socket::SSL:
    return LinearSocketTypeSSL;
  case linear::Socket::WS:
    return LinearSocketTypeWS;
  case linear::Socket::WSS:
    return LinearSocketTypeWSS;
  default:
    return LinearSocketTypeNIL;
  }
}

- (LinearSocketState)state {
  switch (socket.GetState()) {
  case linear::Socket::DISCONNECTING:
    return LinearSocketStateDisconnecting;
  case linear::Socket::CONNECTING:
    return LinearSocketStateConnecting;
  case linear::Socket::CONNECTED:
    return LinearSocketStateConnected;
  case linear::Socket::DISCONNECTED:
  default:
    return LinearSocketStateDisconnected;
  }
}

- (LinearAddrInfo *)selfInfo {
  linear::Addrinfo cppInfo = socket.GetSelfInfo();
  LinearAddrInfo *info = [[LinearAddrInfo alloc] init];
  info.host = [[NSString alloc] initWithUTF8String:cppInfo.addr.c_str()];
  info.port = cppInfo.port;
  return info;
}

- (LinearAddrInfo *)peerInfo {
  linear::Addrinfo cppInfo = socket.GetPeerInfo();
  LinearAddrInfo *info = [[LinearAddrInfo alloc] init];
  info.host = [[NSString alloc] initWithUTF8String:cppInfo.addr.c_str()];
  info.port = cppInfo.port;
  return info;
}

- (BOOL)connect {
  linear::Error err = socket.Connect();
  if (err.Code() != linear::LNR_OK) {
    return NO;
  }
  return YES;
}

- (BOOL)connect:(NSUInteger)timeout {
  linear::Error err = socket.Connect(timeout);
  if (err.Code() != linear::LNR_OK) {
    return NO;
  }
  return YES;
}

- (BOOL)disconnect {
  linear::Error err = socket.Disconnect();
  if (err.Code() != linear::LNR_OK) {
    return NO;
  }
  return YES;
}

- (BOOL)keepAlive:(NSUInteger)interval retry:(NSUInteger)retry {
  linear::Error err = socket.KeepAlive(interval, retry);
  if (err.Code() != linear::LNR_OK) {
    return NO;
  }
  return YES;
}

- (BOOL)keepAlive:(NSUInteger)interval retry:(NSUInteger)retry type:(LinearKeepAliveType)type {
  linear::Socket::KeepAliveType t = linear::Socket::KEEPALIVE_TCP;
  switch(type) {
  case LinearKeepAliveWS:
    t = linear::Socket::KEEPALIVE_WS;
    break;
  default:
    break;
  }
  linear::Error err = socket.KeepAlive(interval, retry, t);
  if (err.Code() != linear::LNR_OK) {
    return NO;
  }
  return YES;
}

- (LinearError *)send:(LinearMessage *)message {
  switch (message.type) {
  case LinearMessageTypeRequest:
    {
      return [self send:message timeout:-1];
    }
  case LinearMessageTypeResponse:
    {
      LinearResponse *objcResponse = (LinearResponse *)message;
      linear::Response cppResponse(objcResponse.msgid,
                                   [LinearTypeConverter to_any:objcResponse.result],
                                   [LinearTypeConverter to_any:objcResponse.error]);
      linear::Error err = cppResponse.Send(socket);
      return [[LinearError alloc] initWithErrorCode:(LinearErrorCode)err.Code()];
    }
  case LinearMessageTypeNotify:
    {
      LinearNotify *objcNotify = (LinearNotify *)message;
      linear::Notify cppNotify([objcNotify.name UTF8String],
                               [LinearTypeConverter to_any:objcNotify.data]);
      linear::Error err = cppNotify.Send(socket);
      return [[LinearError alloc] initWithErrorCode:(LinearErrorCode)err.Code()];
    }
  default:
    return [[LinearError alloc] initWithErrorCode:LinearErrorCodeEINVAL];
  }
}

- (LinearError *)send:(LinearMessage *)message timeout:(NSInteger)timeout {
  if (message.type != LinearMessageTypeRequest) {
    return [[LinearError alloc] initWithErrorCode:LinearErrorCodeEINVAL];
  }
  LinearRequest *objcRequest = (LinearRequest *)message;
  linear::Request cppRequest([objcRequest.method UTF8String],
                             [LinearTypeConverter to_any:objcRequest.params]);
  linear::Error err = cppRequest.Send(socket, timeout);
  LinearError* ret = [[LinearError alloc] initWithErrorCode:(LinearErrorCode)err.Code()];
  if (ret.code == LinearErrorCodeOK) {
    objcRequest.msgid = cppRequest.msgid;
  }
  return ret;
}

@end
