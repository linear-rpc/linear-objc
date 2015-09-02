#import "LinearAuthContext.h"

@implementation LinearAuthContext

- (instancetype)init {
  if (self = [super init]) {
    self.username = @"";
  }
  return self;
}

@end

@implementation LinearAuthenticateContext

- (instancetype)init {
  if (self = [super init]) {
    self.password = @"";
  }
  return self;
}

@end
