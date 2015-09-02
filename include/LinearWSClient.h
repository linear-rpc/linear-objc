#import "LinearClient.h"
#import "LinearWSSocket.h"

#pragma mark - WSClient

/**
 * WS Client class
 */
@interface LinearWSClient : LinearClient

/**
 * get new socket instance
 * @param host FQDN or IPAddr to peer node
 * @param port port number to peer node
 * @return LinearWSSocket instance
 * @see LinearWSSocket
 */
- (LinearWSSocket *)createSocket:(NSString *)host port:(NSInteger)port;

@end
