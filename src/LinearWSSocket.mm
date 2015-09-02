#import "LinearWSSocket.h"

#include "linear/ws_socket.h"

@interface LinearWSResponseContext(LinearWSSocketExtern)

@property (nonatomic, assign, readwrite) NSInteger code;
@property (nonatomic, strong, readwrite) NSDictionary *headers;

@end

@interface LinearSocket(LinearWSSocketExtern)

- (instancetype)initWithCppSocket:(const linear::Socket&)cppSocket;
- (const linear::Socket&)getCppSocket;

@end

@interface LinearWSSocket()

- (instancetype)initWithCppSocket:(const linear::WSSocket&)cppSocket;

@end

@implementation LinearWSSocket

- (instancetype)initWithCppSocket:(const linear::WSSocket&)cppSocket {
  if (self = [super initWithCppSocket:cppSocket]) {
  }
  return self;
}

- (BOOL)setWSRequestContext:(LinearWSRequestContext *)wsctx {
  linear::WSRequestContext cppCtx;
  cppCtx.path = [wsctx.path UTF8String];
  cppCtx.query = [wsctx.query UTF8String];
  if (wsctx.authenticate.username.length > 0) {
    cppCtx.authenticate.username = [wsctx.authenticate.username UTF8String];
    cppCtx.authenticate.password = [wsctx.authenticate.password UTF8String];
  }
  for (id key in wsctx.headers) {
    if (![key isKindOfClass:[NSString class]]) {
      return NO;
    }
    id val = [wsctx.headers objectForKey:key];
    if (![val isKindOfClass:[NSString class]]) {
      return NO;
    }
    cppCtx.headers.insert(std::make_pair([key UTF8String], [val UTF8String]));
  }
  const linear::Socket& cppSocket = [super getCppSocket];
  if (cppSocket.GetType() != linear::Socket::WS) {
    return NO;
  }
  cppSocket.as<linear::WSSocket>().SetWSRequestContext(cppCtx);
  return YES;
}

- (LinearWSResponseContext *)getWSResponseContext {
  LinearWSResponseContext* ctx = [[LinearWSResponseContext alloc] init];
  const linear::Socket& cppSocket = [super getCppSocket];
  if (cppSocket.GetType() != linear::Socket::WS) {
    return ctx;
  }
  const linear::WSResponseContext& cppCtx = cppSocket.as<linear::WSSocket>().GetWSResponseContext();
  ctx.code = cppCtx.code;
  NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
  for (std::map<std::string, std::string>::const_iterator it = cppCtx.headers.begin();
       it != cppCtx.headers.end(); it++) {
    [headers setObject:[NSString stringWithUTF8String:it->second.c_str()] forKey:[NSString stringWithUTF8String:it->first.c_str()]];
  }
  ctx.headers = [NSDictionary dictionaryWithDictionary:headers];
  return ctx;
}

@end
