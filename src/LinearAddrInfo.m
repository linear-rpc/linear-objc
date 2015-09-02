#import "LinearAddrInfo.h"

@implementation LinearAddrInfo

- (instancetype)initWithHost:(NSString *)host port:(NSInteger)port {
  if (self = [super init]) {
    self.host = host;
    self.port = port;
  }
  return self;
}

@end
