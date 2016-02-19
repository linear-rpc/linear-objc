#import "LinearClient.h"
#import "LinearSSLContext.h"
#import "LinearSSLSocket.h"

#pragma mark - SSLClient

/**
 * SSL Client class
 */
@interface LinearSSLClient : LinearClient

/**
 * @brief LinearSSLContext
 *
 * certificates, CA certificates and privatekey etc.
 * for connecting.
 */
@property (nonatomic, strong) LinearSSLContext *sslctx;

/**
 * get new socket instance
 * @param host FQDN or IPAddr to peer node
 * @param port port number to peer node
 * @return LinearSSLSocket instance
 * @see LinearSSLSocket
 */
- (LinearSSLSocket *)createSocket:(NSString *)host port:(NSInteger)port;

@end
