#import "LinearAuthContext.h"

/**
 * WSRequestContext class
 */
@interface LinearWSRequestContext : NSObject

/** request path */
@property (nonatomic, copy) NSString *path;
/** request query */
@property (nonatomic, copy) NSString *query;
/**
 * authenticate infomations
 * @see LinearAuthenticateContext
 */
@property (nonatomic, strong) LinearAuthenticateContext *authenticate;
/** request headers */
@property (nonatomic, strong) NSMutableDictionary *headers;

@end

/** WebSocket Response Code Definitions */
typedef NS_ENUM(NSInteger, LinearWSResponseCode) {
  /** 101 Switching Protocols == OK */
  LinearWSOK                  = 101,
  /** 400 Bad Request */
  LinearWSBadRequest          = 400,
  /** 401 Unauthorized */
  LinearWSUnauthorized        = 401,
  /** 403 Forbidden */
  LinearWSForbidden           = 403,
  /** 404 Not Found */
  LinearWSNotFound            = 404,
  /** 500 Internal Server Error */
  LinearWSInternalServerError = 500,
  /** 503 Service Unavailable */
  LinearWSServiceUnavailable  = 503,
};

/**
 * WSResponseContext class
 */
@interface LinearWSResponseContext : NSObject

/** response code */
@property (nonatomic, assign, readonly) NSInteger code;
/** response headers */
@property (nonatomic, strong, readonly) NSDictionary *headers;

@end
