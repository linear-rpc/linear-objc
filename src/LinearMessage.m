#import "LinearMessage.h"
#import "LinearError.h"

@interface LinearSocket(LinearMessageExtern)

- (LinearError *)send:(LinearMessage *)message;
- (LinearError *)send:(LinearMessage *)message timeout:(NSInteger)timeout;

@end

#pragma mark - LinearMessage

@interface LinearMessage()

@property (nonatomic, assign, readwrite) LinearMessageType type;

@end

@implementation LinearMessage

- (instancetype)init {
  if (self = [super init]) {
    self.type = LinearMessageTypeUndefined;
  }
  return self;
}

@end

#pragma mark - LinearRequest

@interface LinearRequest()

@property (nonatomic, assign, readwrite) NSUInteger msgid;

@end

@implementation LinearRequest

- (instancetype)init {
  if (self = [super init]) {
    self.type = LinearMessageTypeRequest;
  }
  return self;
}

- (instancetype)initWithMethod:(NSString *)method params:(id)params {
  if (self = [super init]) {
    self.type = LinearMessageTypeRequest;
    self.msgid = 0;
    self.method = method;
    self.params = params;
  }
  return self;
}

- (NSNumber *)send:(LinearSocket *)socket {
  return [self send:socket timeout:-1];
}

- (NSNumber *)send:(LinearSocket *)socket timeout:(NSInteger)timeout {
  LinearError *err = [socket send:self timeout:timeout];
  if (err.code != LinearErrorCodeOK) {
    return [NSNumber numberWithInt:-1];
  }
  return [NSNumber numberWithUnsignedInt:self.msgid];
}

@end

#pragma mark - LinearResponse

@interface LinearResponse()

@property (nonatomic, strong, readwrite) LinearRequest *request;

@end

@implementation LinearResponse

- (instancetype)init {
  if (self = [super init]) {
    self.type = LinearMessageTypeResponse;
    self.msgid = 0;
  }
  return self;
}

- (instancetype)initWithMsgid:(NSUInteger)msgid result:(id)result error:(id)error {
  if (self = [super init]) {
    self.type = LinearMessageTypeResponse;
    self.msgid = msgid;
    self.result = result;
    self.error = error;
  }
  return self;
}

- (void)send:(LinearSocket *)socket {
  [socket send:self];
}

@end

#pragma mark - LinearNotify

@implementation LinearNotify

- (instancetype)init {
  if (self = [super init]) {
    self.type = LinearMessageTypeNotify;
  }
  return self;
}

- (instancetype)initWithName:(NSString *)name data:(id)data {
  if (self = [super init]) {
    self.type = LinearMessageTypeNotify;
    self.name = name;
    self.data = data;
  }
  return self;
}

- (void)send:(LinearSocket *)socket {
  [socket send:self];
}

@end
