#import "LinearClient.h"
#import "LinearSSLSocket.h"

#pragma mark - SSLClient

/**
 * SSL Client class
 * @note can use only encrypted transport now.
 * (can't deal any certificates)
 */
@interface LinearSSLClient : LinearClient

/**
 * get new socket instance
 * @param host FQDN or IPAddr to peer node
 * @param port port number to peer node
 * @return LinearSSLSocket instance
 * @see LinearSSLSocket
 */
- (LinearSSLSocket *)createSocket:(NSString *)host port:(NSInteger)port;

@end
