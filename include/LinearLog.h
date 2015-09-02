#import <Foundation/Foundation.h>

#pragma mark - Log Levels

/**
 * Log Level definitions
 */
typedef NS_ENUM(NSInteger, LinearLogLevel) {
  /** Error */
  LinearLogLevelError,
  /** Warning */
  LinearLogLevelWarn,
  /** Informations */
  LinearLogLevelInfo,
  /** Debug - Truncate some data */
  LinearLogLevelDebug,
  /** Debug - Full Info */
  LinearLogLevelFull,
};

#pragma mark - Log

/**
 * Log class
 */
@interface LinearLog : NSObject

/**
 * show logs into debug window
 * @param level LinearLogLevel
 */
+ (void)show:(LinearLogLevel)level;
/**
 * hide logs
 */
+ (void)hide;

@end

