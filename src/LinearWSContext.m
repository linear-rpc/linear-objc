#import "LinearWSContext.h"

#pragma mark - LinearWSRequestContext

@implementation LinearWSRequestContext

- (instancetype)init {
  if (self = [super init]) {
    self.path = @"/linear";
    self.query = @"";
    self.authenticate = [[LinearAuthenticateContext alloc] init];
    self.headers = [[NSMutableDictionary alloc] init];
  }
  return self;
}

@end

#pragma mark - LinearWSResponseContext

@interface LinearWSResponseContext()

@property (nonatomic, assign, readwrite) NSInteger code;
@property (nonatomic, strong, readwrite) NSDictionary *headers;

@end

@implementation LinearWSResponseContext

- (instancetype)init {
  if (self = [super init]) {
    self.code = LinearWSNotFound;
    self.headers = [[NSDictionary alloc] init];
  }
  return self;
}

@end
