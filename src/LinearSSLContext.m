#import "LinearSSLContext.h"

#pragma mark - SSLContext

@implementation LinearSSLContext

- (instancetype)init {
  if (self = [super init]) {
    self.method = LinearTLS;
    self.mode = LinearSSLVerifyPeer;
    self.cert = NULL;
    self.pkey = NULL;
    self.cipher = @"ALL:EECDH+HIGH:EDH+HIGH:+MEDIUM+HIGH:!EXP:!LOW:!eNULL:!aNULL:!MD5:!RC4:!ADH:!KRB5:!PSK:!SRP";
    self.cacert = NULL;
  }
  return self;
}

@end
