#import "LinearSocket.h"
#import "LinearX509Certificate.h"

#pragma mark - SSLSocket

/**
 * SSLSocket class
 */
@interface LinearSSLSocket : LinearSocket

/**
 * get peer certificate
 * @return LinearX509Certificate Object
 * @see LinearX509Certificate
 */
- (LinearX509Certificate *)getPeerCertificate;
/**
 * get peer certificate chain
 * @return LinearX509Certificate Object
 * @see LinearX509Certificate
 */
- (NSArray *)getPeerCertificateChain;

@end
