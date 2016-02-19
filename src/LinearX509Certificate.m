#import "LinearX509Certificate.h"

#pragma mark - X509Certificate

@interface LinearX509Principal()

@property (nonatomic, copy, readwrite) NSString *CN;
@property (nonatomic, copy, readwrite) NSString *DN;

@end

@implementation LinearX509Principal

- (instancetype)init {
  if (self = [super init]) {
    self.CN = @"";
    self.DN = @"";
  }
  return self;
}

@end

@interface LinearX509Certificate()

@property (nonatomic, strong, readwrite) LinearX509Principal *subject;
@property (nonatomic, strong, readwrite) LinearX509Principal *issuer;
@property (nonatomic, assign, readwrite) BOOL CA;

@end

@implementation LinearX509Certificate

- (instancetype)init {
  if (self = [super init]) {
    self.subject = [[LinearX509Principal alloc] init];
    self.issuer = [[LinearX509Principal alloc] init];
    self.CA = FALSE;
  }
  return self;
}

@end
