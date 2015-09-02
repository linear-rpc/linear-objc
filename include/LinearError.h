#import <Foundation/Foundation.h>

#define LINEAR_ERRCODE_MAP(GEN)   \
  GEN(EACCES,          "permission denied")                             \
  GEN(EADDRINUSE,      "address already in use")                        \
  GEN(EADDRNOTAVAIL,   "address not available")                         \
  GEN(EAFNOSUPPORT,    "address family not supported")                  \
  GEN(EAGAIN,          "resource temporarily unavailable")              \
  GEN(EAI_ADDRFAMILY,  "address family not supported")                  \
  GEN(EAI_AGAIN,       "temporary failure")                             \
  GEN(EAI_BADFLAGS,    "bad ai_flags value")                            \
  GEN(EAI_CANCELED,    "request canceled")                              \
  GEN(EAI_FAIL,        "permanent failure")                             \
  GEN(EAI_FAMILY,      "ai_family not supported")                       \
  GEN(EAI_MEMORY,      "out of memory")                                 \
  GEN(EAI_NODATA,      "no address")                                    \
  GEN(EAI_NONAME,      "unknown node or service")                       \
  GEN(EAI_SERVICE,     "service not available for socket type")         \
  GEN(EAI_SOCKTYPE,    "socket type not supported")                     \
  GEN(EAI_SYSTEM,      "system error")                                  \
  GEN(EALREADY,        "connection already in progress")                \
  GEN(EBADF,           "bad file descriptor")                           \
  GEN(EBUSY,           "resource busy or locked")                       \
  GEN(ECANCELED,       "operation canceled")                            \
  GEN(ECHARSET,        "invalid Unicode character")                     \
  GEN(ECONNABORTED,    "software caused connection abort")              \
  GEN(ECONNREFUSED,    "connection refused")                            \
  GEN(ECONNRESET,      "connection reset by peer")                      \
  GEN(EDESTADDRREQ,    "destination address required")                  \
  GEN(EEXIST,          "file already exists")                           \
  GEN(EFAULT,          "bad address in system call argument")           \
  GEN(EHOSTUNREACH,    "host is unreachable")                           \
  GEN(EINTR,           "interrupted system call")                       \
  GEN(EINVAL,          "invalid argument")                              \
  GEN(EIO,             "i/o error")                                     \
  GEN(EISCONN,         "socket is already connected")                   \
  GEN(EISDIR,          "illegal operation on a directory")              \
  GEN(ELOOP,           "too many symbolic links encountered")           \
  GEN(EMFILE,          "too many open files")                           \
  GEN(EMSGSIZE,        "message too long")                              \
  GEN(ENAMETOOLONG,    "name too long")                                 \
  GEN(ENETDOWN,        "network is down")                               \
  GEN(ENETUNREACH,     "network is unreachable")                        \
  GEN(ENFILE,          "file table overflow")                           \
  GEN(ENOBUFS,         "no buffer space available")                     \
  GEN(ENODEV,          "no such device")                                \
  GEN(ENOENT,          "no such file or directory")                     \
  GEN(ENOMEM,          "not enough memory")                             \
  GEN(ENONET,          "machine is not on the network")                 \
  GEN(ENOSPC,          "no space left on device")                       \
  GEN(ENOSYS,          "function not implemented")                      \
  GEN(ENOTCONN,        "socket is not connected")                       \
  GEN(ENOTDIR,         "not a directory")                               \
  GEN(ENOTEMPTY,       "directory not empty")                           \
  GEN(ENOTSOCK,        "socket operation on non-socket")                \
  GEN(ENOTSUP,         "operation not supported on socket")             \
  GEN(EPERM,           "operation not permitted")                       \
  GEN(EPIPE,           "broken pipe")                                   \
  GEN(EPROTO,          "protocol error")                                \
  GEN(EPROTONOSUPPORT, "protocol not supported")                        \
  GEN(EPROTOTYPE,      "protocol wrong type for socket")                \
  GEN(EROFS,           "read-only file system")                         \
  GEN(ESHUTDOWN,       "cannot send after transport endpoint shutdown") \
  GEN(ESPIPE,          "invalid seek")                                  \
  GEN(ESRCH,           "no such process")                               \
  GEN(ETIMEDOUT,       "connection timed out")                          \
  GEN(EXDEV,           "cross-device link not permitted")               \
  GEN(UNKNOWN,         "unknown error")                                 \
  GEN(EOF,             "end of file")                                   \

#define LINEAR_ERRCODE_GEN(name, s) LinearErrorCode##name,
/** Error Code Definitions */
typedef NS_ENUM(NSInteger, LinearErrorCode) {
  /** OK */
  LinearErrorCodeOK = 0,
  /** ErrorCodes defined by Macros (appledoc does not correspond to macro expansion) */
  LINEAR_ERRCODE_MAP(LINEAR_ERRCODE_GEN)
};
#undef LINEAR_ERRCODE_GEN

#pragma mark - Error Information

/**
 * Error Information class
 */
@interface LinearError : NSObject

/** Error Code */
@property (nonatomic, assign) LinearErrorCode code;
/** Error Message */
@property (nonatomic, copy) NSString *message;

- (instancetype)initWithErrorCode:(LinearErrorCode)code;

@end
