#import "LinearError.h"
#import "LinearMessage.h"
#import "LinearSocket.h"

#pragma mark - ClientDelegate

/** Callback Handler Delegates */
@protocol LinearClientDelegate <NSObject>

@optional
/**
 * called when connected to peer
 * @param socket connected socket
 * @see LinearSocket
 */
- (void)onConnect:(LinearSocket *)socket;
/**
 * called when disconnected to peer
 * @param socket disconnected socket
 * @param error error reason.
 * @see LinearSocket, LinearError
 */
- (void)onDisconnect:(LinearSocket *)socket error:(LinearError *)error;
/**
 * called when received some message from peer
 * @param socket message is received from this socket
 * @param message LinearRequest, LinearResponse or LinearNotify
 * @see LinearSocket, LinearMessage
 */
- (void)onMessage:(LinearSocket *)socket message:(LinearMessage *)message;
/**
 * called when occurred some errors
 * @param socket error occurred on this socket
 * @param message fail to send this message
 * @param error error reason
 * @see LinearSocket, LinearMessage, LinearError
 */
- (void)onError:(LinearSocket *)socket message:(LinearMessage *)message error:(LinearError *)error;

@end

#pragma mark - Client

/**
 * Client class
 */
@interface LinearClient : NSObject

/** operation queue for delegate */
@property (nonatomic, strong) NSOperationQueue* queue;
/**
 * callback handler delegate
 * @see LinearClientDelegate
 */
@property (nonatomic, weak) id<LinearClientDelegate> delegate;

/**
 * init with your operation queue
 * @param queue NSOperationQueue
 */
- (instancetype)initWithDelegateQueue:(NSOperationQueue *)queue;

@end
