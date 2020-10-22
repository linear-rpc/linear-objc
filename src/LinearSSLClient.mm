#import <Security/Security.h>

#import "LinearSSLClient.h"

#include "linear/handler.h"
#include "linear/ssl_client.h"

@interface LinearSSLSocket(LinearSSLClientExtern)

- (instancetype)initWithCppSocket:(const linear::SSLSocket&)cppSocket;

@end

@interface LinearClient(LinearSSLClientExtern)

- (const linear::shared_ptr<linear::Handler>&)getHandler;

@end

@interface LinearSSLClient() {
  linear::SSLClient* client;
}
@end

@implementation LinearSSLClient

- (instancetype)init {
  if (self = [super init]) {
    _sslctx = [[LinearSSLContext alloc] init];
    if (!client) {
      client = new linear::SSLClient([super getHandler]);
    }
  }
  return self;
}

- (instancetype)initWithDelegateQueue:(NSOperationQueue *)queue {
  if (self = [super initWithDelegateQueue:queue]) {
    _sslctx = [[LinearSSLContext alloc] init];
    if (!client) {
      client = new linear::SSLClient([super getHandler]);
    }
  }
  return self;
}

- (void)dealloc {
  if (client) {
    delete client;
    client = NULL;
  }
}

- (LinearSSLSocket *)createSocket:(NSString *)host port:(NSInteger)port {
  linear::SSLContext::Method method;
  switch (_sslctx.method) {
  case LinearTLS:
    method = linear::SSLContext::TLS;
    break;
  }
  linear::SSLContext cppCtx(method);
  // do not verify on cpp layer
  cppCtx.SetVerifyMode(linear::SSLContext::VERIFY_NONE);
  if (_sslctx.cert != NULL) {
    if (!cppCtx.SetCertificate(_sslctx.cert.UTF8String)) {
      if (!cppCtx.SetCertificate(_sslctx.cert.UTF8String, linear::SSLContext::DER)) {
        NSLog(@"fail to set certificate(%@)", _sslctx.cert);
      }
    }
  }
  if (_sslctx.pkey != NULL) {
    if (!cppCtx.SetPrivateKey(_sslctx.pkey.UTF8String,
                              ((_sslctx.pass == NULL) ? "" : _sslctx.pass.UTF8String))) {
      if (!cppCtx.SetPrivateKey(_sslctx.pkey.UTF8String,
                                ((_sslctx.pass == NULL) ? "" : _sslctx.pass.UTF8String),
                                linear::SSLContext::DER)) {
        NSLog(@"fail to set private key(%@)", _sslctx.pkey);
      }
    }
  }
  LinearSSLSocket *socket = [[LinearSSLSocket alloc] initWithCppSocket:client->CreateSocket([host UTF8String], port, cppCtx)];
  return socket;
}

- (void)onConnect:(const linear::Socket&)cppSocket {
  try {
    linear::SSLSocket cppSSLSocket = cppSocket.as<linear::SSLSocket>();
    if (_sslctx.mode == LinearSSLVerifyPeer) {

      // store certificates from server
      CFMutableArrayRef array = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
      std::vector<linear::X509Certificate> cppCerts = cppSSLSocket.GetPeerCertificateChain();
      // TODO: replace foreach
      for (std::vector<linear::X509Certificate>::iterator it = cppCerts.begin();
           it != cppCerts.end(); it++) {
        NSLog(@"SubjectDN: %s, IssuerDN: %s", it->GetSubject().DN.c_str(), it->GetIssuer().DN.c_str());
        X509* cppX509 = it->GetHandle();
        unsigned char* buf = NULL;
        int len = i2d_X509(cppX509, &buf);
        CFDataRef data = CFDataCreate(kCFAllocatorDefault, buf, len);
        free(buf);
        // not deep copied, so we have to free cert after exec SecTrustEvaluate.
        SecCertificateRef cert = SecCertificateCreateWithData(NULL, data);
        CFRelease(data);
        CFArrayAppendValue(array, cert);
      }
      SecTrustRef trust;
      SecPolicyRef policy = SecPolicyCreateBasicX509();
      OSStatus status = SecTrustCreateWithCertificates(array, policy, &trust);
      if (status != noErr) {
        NSLog(@"fail to store certificates from server");
        for (int i = 0; i < CFArrayGetCount(array); i++) {
          CFRelease(CFArrayGetValueAtIndex(array, i));
        }
        CFRelease(array);
        CFRelease(policy);
        cppSSLSocket.Disconnect();
        return;
      }

      // add allowed ca certificates(intermidiate CAs or self-signed CAs) if needed
      SecCertificateRef ca_cert;
      if (_sslctx.cacert != NULL) {
        NSData* data = [[NSData alloc] initWithContentsOfFile: _sslctx.cacert];
        ca_cert = SecCertificateCreateWithData(NULL, (CFDataRef)data);
        NSArray* ca_cert_array = [[NSArray alloc] initWithObjects:(__bridge id)ca_cert, nil];
        OSStatus status = SecTrustSetAnchorCertificates(trust, (CFArrayRef)ca_cert_array);
        if (status != noErr) {
          NSLog(@"fail to store CA certificate you specified");
          for (int i = 0; i < CFArrayGetCount(array); i++) {
            CFRelease(CFArrayGetValueAtIndex(array, i));
          }
          CFRelease(array);
          CFRelease(policy);
          cppSSLSocket.Disconnect();
          return;
        }
        CFRetain(ca_cert);
      }

      // validate certificates
      SecTrustResultType r = kSecTrustResultInvalid;
      status  = SecTrustEvaluate(trust, &r);
      if (_sslctx.cacert != NULL) {
        CFRelease(ca_cert);
      }
      for (int i = 0; i < CFArrayGetCount(array); i++) {
        CFRelease(CFArrayGetValueAtIndex(array, i));
      }
      CFRelease(array);
      CFRelease(policy);
      CFRelease(trust);
      if (status != noErr ||
          (r != kSecTrustResultProceed && r != kSecTrustResultUnspecified)) {
        NSLog(@"invalid server certificate");
        cppSSLSocket.Disconnect();
        return;
      }
    }

    // call OnConnect of Obj-C
    if ([self.delegate respondsToSelector:@selector(onConnect:)]) {
      @autoreleasepool {
        LinearSocket *socket = [[LinearSSLSocket alloc] initWithCppSocket:cppSSLSocket];
        [self.queue addOperationWithBlock:^{
            [self.delegate onConnect:socket];
          }];
      }
    }
  } catch(...) {
    NSLog(@"BUG: invalid type of linear::SSLSocket");
    return;
  }
}

@end
