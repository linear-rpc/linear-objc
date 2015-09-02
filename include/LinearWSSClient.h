#import "LinearClient.h"
#import "LinearWSSSocket.h"

#pragma mark - WSSClient

/**
 * WSS Client class
 * @note can use only encrypted transport now.
 * (can't deal any certificates)
 */
@interface LinearWSSClient : LinearClient

/**
 * get new socket instance
 * @param host FQDN or IPAddr to peer node
 * @param port port number to peer node
 * @return LinearWSSSocket instance
 * @see LinearWSSSocket
 */
- (LinearWSSSocket *)createSocket:(NSString *)host port:(NSInteger)port;

@end
