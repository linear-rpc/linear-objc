#import "LinearSSLSocket.h"

#include "linear/ssl_socket.h"

@interface LinearX509Principal(LinearSSLSocketExtern)

@property (nonatomic, copy, readwrite) NSString *CN;
@property (nonatomic, copy, readwrite) NSString *DN;

@end

@interface LinearX509Certificate(LinearSSLSocketExtern)

@property (nonatomic, strong, readwrite) LinearX509Principal *subject;
@property (nonatomic, strong, readwrite) LinearX509Principal *issuer;
@property (nonatomic, assign, readwrite) BOOL CA;

@end

@interface LinearSocket(LinearSSLSocketExtern)

- (instancetype)initWithCppSocket:(const linear::Socket&)cppSocket;
- (const linear::Socket&)getCppSocket;

@end

@interface LinearSSLSocket()

- (instancetype)initWithCppSocket:(const linear::SSLSocket&)cppSocket;

@end

@implementation LinearSSLSocket

- (instancetype)initWithCppSocket:(const linear::SSLSocket&)cppSocket {
  if (self = [super initWithCppSocket:cppSocket]) {
  }
  return self;
}

- (LinearX509Certificate *)getPeerCertificate {
  LinearX509Certificate *cert = [[LinearX509Certificate alloc] init];
  try {
    linear::Socket cppSocket = [super getCppSocket];
    linear::SSLSocket cppSSLSocket = cppSocket.as<linear::SSLSocket>();
    if (cppSSLSocket.PresentPeerCertificate()) {
      linear::X509Certificate cppCert = cppSSLSocket.GetPeerCertificate();
      cert.subject.CN = [[NSString alloc] initWithUTF8String:cppCert.GetSubject().CN.c_str()];
      cert.subject.DN = [[NSString alloc] initWithUTF8String:cppCert.GetSubject().DN.c_str()];
      cert.issuer.CN = [[NSString alloc] initWithUTF8String:cppCert.GetIssuer().CN.c_str()];
      cert.issuer.DN = [[NSString alloc] initWithUTF8String:cppCert.GetIssuer().DN.c_str()];
      cert.CA = cppCert.IsCA() ? TRUE : FALSE;
    }
  } catch (...) {}
  return cert;
}

- (NSArray *)getPeerCertificateChain {
  NSMutableArray *array = [[NSMutableArray alloc] init];
  try {
    linear::Socket cppSocket = [super getCppSocket];
    linear::SSLSocket cppSSLSocket = cppSocket.as<linear::SSLSocket>();
    std::vector<linear::X509Certificate> cppCerts = cppSSLSocket.GetPeerCertificateChain();
    // TODO: replace foreach
    for (std::vector<linear::X509Certificate>::iterator it = cppCerts.begin();
         it != cppCerts.end(); it++) {
      LinearX509Certificate *cert = [[LinearX509Certificate alloc] init];
      cert.subject.CN = [[NSString alloc] initWithUTF8String:it->GetSubject().CN.c_str()];
      cert.subject.DN = [[NSString alloc] initWithUTF8String:it->GetSubject().DN.c_str()];
      cert.issuer.CN = [[NSString alloc] initWithUTF8String:it->GetIssuer().CN.c_str()];
      cert.issuer.DN = [[NSString alloc] initWithUTF8String:it->GetIssuer().DN.c_str()];
      cert.CA = it->IsCA() ? TRUE : FALSE;
      [array addObject:cert];
    }
  } catch (...) {}
  return array;
}

@end
