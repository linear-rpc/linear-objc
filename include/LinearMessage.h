#import "LinearSocket.h"

#pragma mark - MessageTypes

/** Message Types */
typedef NS_ENUM(NSInteger, LinearMessageType) {
  /** Request */
  LinearMessageTypeRequest,
  /** Response */
  LinearMessageTypeResponse,
  /** Notify */
  LinearMessageTypeNotify,
  /** None */
  LinearMessageTypeUndefined,
};

#pragma mark - LinearMessage

/** Super class for several concrete messages */
@interface LinearMessage : NSObject

/** Message Type indicator */
@property (nonatomic, assign, readonly) LinearMessageType type;

@end

#pragma mark - LinearRequest

/** Request Message */
@interface LinearRequest : LinearMessage

/** message id */
@property (nonatomic, assign, readonly) NSUInteger msgid;
/** method name */
@property (nonatomic, copy) NSString *method;
/** parameters */
@property (nonatomic, strong) id params;

/**
 * Request constructor with method and parameters
 * @param method method name
 * @param params parameters
 * @return Request instance
 * @see method
 * @see params
 */
- (instancetype)initWithMethod:(NSString *)method params:(id)params;
/**
 * Send Request
 * @param socket LinearSocket instance
 * @return message id
 * @see LinearSocket
 * @see msgid
 */
- (NSNumber *)send:(LinearSocket *)socket;
/**
 * Send Request with timeout
 * @param socket LinearSocket instance
 * @param timeout timeout val(ms)
 * @return message id
 * @see LinearSocket
 * @see msgid
 */
- (NSNumber *)send:(LinearSocket *)socket timeout:(NSInteger)timeout;

@end

#pragma mark - LinearResponse

/** Response message */
@interface LinearResponse : LinearMessage

/**
 * original request correspond to
 * @see LinearRequest
 */
@property (nonatomic, strong, readonly) LinearRequest *request;
/**
 * message id correspond to original request
 * @see LinearRequest
 */
@property (nonatomic, assign) NSUInteger msgid;
/**
 * Response result
 * fill in when succeed to Request
 */
@property (nonatomic, strong) id result;
/**
 * Response error
 * fill in when fail to Request
 */
@property (nonatomic, strong) id error;

/**
 * Response constructor with msgid, result, error
 * @param msgid message id. Same as original LinearRequest
 * @param result Result val when succeed to Request
 * @param error Error val when fail to Request
 * @return Response instance
 * @see msgid
 * @see result
 * @see error
 */
- (instancetype)initWithMsgid:(NSUInteger)msgid result:(id)result error:(id)error;
/**
 * Send Response
 * @param socket LinearSocket instance
 * @see LinearSocket
 */
- (void)send:(LinearSocket *)socket;

@end

#pragma mark - LinearNotify

/** Notify message */
@interface LinearNotify : LinearMessage

/** Event Name */
@property (nonatomic, copy) NSString* name;
/** Event Data */
@property (nonatomic, strong) id data;

/**
 * Notify constructor with name and data
 * @param name Event Name
 * @param data Event Data
 * @return Notify instance
 * @see name
 * @see data
 */
- (instancetype)initWithName:(NSString *)name data:(id)data;
/**
 * Send Notify
 * @param socket LinearSocket instance
 * @see LinearSocket
 */
- (void)send:(LinearSocket *)socket;

@end

