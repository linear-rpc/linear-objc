#import "LinearSocket.h"
#import "LinearWSContext.h"

#pragma mark - WSSocket

/**
 * WSSocket class
 */
@interface LinearWSSocket : LinearSocket

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
