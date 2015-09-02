#import "LinearClient.h"
#import "LinearTCPSocket.h"

#pragma mark - TCPClient

/**
 * TCP Client class
 */
@interface LinearTCPClient : LinearClient

/**
 * get new socket instance
 * @param host FQDN or IPAddr to peer node
 * @param port port number to peer node
 * @return LinearTCPSocket instance
 * @see LinearTCPSocket
 */
- (LinearTCPSocket *)createSocket:(NSString *)host port:(NSInteger)port;

@end
