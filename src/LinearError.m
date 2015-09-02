#import "LinearError.h"

@implementation LinearError

- (NSString *)message {
#define LINEAR_ERRORSTR_GEN(name, s) case LinearErrorCode##name : _message = [[NSString alloc] initWithUTF8String:s]; break;
  switch (_code) {
  case LinearErrorCodeOK:
    _message = @"success";
    break;
    LINEAR_ERRCODE_MAP(LINEAR_ERRORSTR_GEN)
  default:
    _message = @"unknown error";
    break;
  }
#undef LINEAR_ERRORSTR_GEN
  return _message;
}

- (instancetype)initWithErrorCode:(LinearErrorCode)code {
  if (self = [super init]) {
    _code = code;
  }
  return self;
}

@end
