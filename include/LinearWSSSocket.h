#import "LinearSocket.h"
#import "LinearWSContext.h"

#pragma mark - WSSSocket

/**
 * WSSSocket class
 */
@interface LinearWSSSocket : LinearSocket

/**
 * set WebSocket Request Context
 * @param wsctx LinearRequestContext Object
 * @return success or not
 * @see LinearWSRequestContext
 */
- (BOOL)setWSRequestContext:(LinearWSRequestContext *)wsctx;
/**
 * get WebSocket Response Context
 * @return LinearRequestContext Object
 * @see LinearWSRequestContext
 */
- (LinearWSResponseContext *)getWSResponseContext;

@end
