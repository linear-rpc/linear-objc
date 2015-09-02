#import <Foundation/Foundation.h>

#pragma mark - Address Information

/**
 * Address Information class
 */
@interface LinearAddrInfo : NSObject

/** FQDN or IPAddress */
@property (nonatomic, copy) NSString *host;
/** port number */
@property (nonatomic, assign) NSInteger port;

- (instancetype)initWithHost:(NSString *)host port:(NSInteger)port;

@end
