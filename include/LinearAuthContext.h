#import <Foundation/Foundation.h>

/**
 * Super Class for Authenticate
 */
@interface LinearAuthContext : NSObject

/** username */
@property (nonatomic, copy) NSString *username;

@end

/**
 * Authenticate Context
 */
@interface LinearAuthenticateContext : LinearAuthContext

/** password */
@property (nonatomic, copy) NSString *password;

@end
