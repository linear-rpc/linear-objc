#import "LinearLog.h"

#include "linear/log.h"

void cppLogCallback(linear::log::Level level, const char* file, int line, const char* func, const char* message) {
  NSString *levelString;

  switch (level) {
  case linear::log::LOG_ERR:
    levelString = @"ERR";
    break;
  case linear::log::LOG_WARN:
    levelString = @"WRN";
    break;
  case linear::log::LOG_INFO:
    levelString = @"INF";
    break;
  case linear::log::LOG_DEBUG:
    levelString = @"DBG";
    break;
  case linear::log::LOG_OFF:
  default:
    return;
  }
  NSLog(@"%@: %@", levelString, [[NSString alloc] initWithUTF8String:message]);
}

@implementation LinearLog

+ (void)show:(LinearLogLevel)level {
  switch(level) {
  case LinearLogLevelError:
    linear::log::SetLevel(linear::log::LOG_ERR);
    break;
  case LinearLogLevelWarn:
    linear::log::SetLevel(linear::log::LOG_WARN);
    break;
  case LinearLogLevelInfo:
    linear::log::SetLevel(linear::log::LOG_INFO);
    break;
  case LinearLogLevelDebug:
    linear::log::SetLevel(linear::log::LOG_DEBUG);
    break;
  case LinearLogLevelFull:
    linear::log::SetLevel(linear::log::LOG_FULL);
    break;
  }
  linear::log::EnableCallback(cppLogCallback);
}

+ (void)hide {
  linear::log::DisableCallback();
}

@end
