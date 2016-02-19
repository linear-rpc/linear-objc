#import <Foundation/Foundation.h>

#pragma mark - X509Certificate

/**
 * X509 Principal class
 */
@interface LinearX509Principal : NSObject

/** Common Name */
@property (nonatomic, copy, readonly) NSString *CN;
/** Distinguished Name */
@property (nonatomic, copy, readonly) NSString *DN;

@end

/**
 * X509 Certificate class
 */
@interface LinearX509Certificate : NSObject

/** Subject Info */
@property (nonatomic, strong, readonly) LinearX509Principal *subject;
/** Issuer Info */
@property (nonatomic, strong, readonly) LinearX509Principal *issuer;
/** CA cert or not */
@property (nonatomic, assign, readonly) BOOL CA;

@end
