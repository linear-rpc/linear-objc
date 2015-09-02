#import "LinearAddrInfo.h"

#pragma mark - Socket Types

/** Socket Type Indicator */
typedef NS_ENUM(NSInteger, LinearSocketType) {
  /** NIL */
  LinearSocketTypeNIL,
  /** TCP */
  LinearSocketTypeTCP,
  /** SSL */
  LinearSocketTypeSSL,
  /** WebSocket */
  LinearSocketTypeWS,
  /** Secure WebSocket (not implemented yet) */
  LinearSocketTypeWSS,
};

#pragma mark - Socket Status

/** Socket State Indicator */
typedef NS_ENUM(NSInteger, LinearSocketState) {
  /** Disconnecting */
  LinearSocketStateDisconnecting,
  /** Disconnected */
  LinearSocketStateDisconnected,
  /** Connecting */
  LinearSocketStateConnecting,
  /** Connected */
  LinearSocketStateConnected,
};

#pragma mark - Socket

/**
 * Socket class
 */
@interface LinearSocket : NSObject

/** Socket Id */
@property (nonatomic, assign, readonly) NSInteger ident;
/** Socket Type */
@property (nonatomic, assign, readonly) LinearSocketType type;
/** Socket State */
@property (nonatomic, assign, readonly) LinearSocketState state;
/**
 * Self Information
 * @see LinearAddrInfo
 */
@property (nonatomic, strong, readonly) LinearAddrInfo *selfInfo;
/**
 * Peer Information
 * @see LinearAddrInfo
 */
@property (nonatomic, strong, readonly) LinearAddrInfo *peerInfo;

/**
 * Connect to peer
 * @return succeed to connect or not
 */
- (BOOL)connect;
/**
 * Connect to peer with timeout
 * @param timeout timeout value (ms)
 * @return succeed to connect or not
 */
- (BOOL)connect:(NSUInteger)timeout;
/**
 * Disconnect from peer
 * @return succeed to disconnect or not
 */
- (BOOL)disconnect;
/**
 * Interface to set SO_KEEPALIVE
 * @param interval interval time(second) to send tcp-keepalive
 * @param retry retry counter
 * @return succeed to set or not
 * @note This method is enabled on iOS 7.0-.
 * @see http://stackoverflow.com/questions/9214326/tcp-keepintvl-and-tcp-keepcnt-not-defined-in-tcp-h-in-ios-sdk
 */
- (BOOL)keepAlive:(NSUInteger)interval retry:(NSUInteger)retry;

@end
