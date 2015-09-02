#import <Foundation/Foundation.h>

#include "linear/message.h"

@interface LinearTypeConverter : NSObject

+ (linear::type::any)to_any:(id)from;
+ (id)to_id:(const linear::type::any&)from;

@end

linear::type::any number_to_any(NSNumber* from) {
  linear::type::any ret;

  CFNumberType type = CFNumberGetType((CFNumberRef)from);
  switch (type) {
  case kCFNumberSInt8Type:
  case kCFNumberSInt16Type:
  case kCFNumberShortType:
    ret = from.shortValue;
    break;
  case kCFNumberSInt32Type:
  case kCFNumberIntType:
  case kCFNumberLongType:
  case kCFNumberCFIndexType:
  case kCFNumberNSIntegerType:
    ret = from.intValue;
    break;
  case kCFNumberSInt64Type:
  case kCFNumberLongLongType:
    ret = from.longLongValue;
    break;
  case kCFNumberFloat32Type:
  case kCFNumberFloatType:
  case kCFNumberCGFloatType:
    ret = from.floatValue;
    break;
  case kCFNumberFloat64Type:
  case kCFNumberDoubleType:
    ret = from.doubleValue;
    break;
  case kCFNumberCharType:
    ret = from.charValue;
    break;
  default:
    NSLog(@"BUG: unable to convert objc-number");
    break;
  }
  return ret;
}

linear::type::any id_to_any(id from) {
  linear::type::any ret;

  if ([from isKindOfClass:[NSArray class]]) {
    if (((NSArray*)from).count == 0) {
      ret = std::vector<int>();
    } else {
      std::vector<linear::type::any> vec;
      for (id nsarray in from) {
        linear::type::any val = id_to_any(nsarray);
        vec.push_back(val);
      }
      ret = vec;
    }
  } else if ([from isKindOfClass:[NSDictionary class]]) {
    if (((NSDictionary*)from).count == 0) {
      ret = std::map<int, int>();
    } else {
      std::map<linear::type::any, linear::type::any> m;
      for (id nskey in from) {
        linear::type::any key = id_to_any(nskey);
        linear::type::any val = id_to_any([from objectForKey:nskey]);
        m.insert(std::map<linear::type::any, linear::type::any>::value_type(key, val));
      }
      ret = m;
    }
  } else if ([from isKindOfClass:[NSData class]]) {
    ret = linear::type::binary((const char*)[from bytes], [from length]);
  } else if ([from isKindOfClass:[NSString class]]) {
    ret = std::string(((NSString*)from).UTF8String);

  // http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
  // http://stackoverflow.com/questions/23425187/nsnumber-with-bool-is-no-bool-on-64bit
  // note: YES or NO has no meanings
  } else if ([from isKindOfClass:[[NSNumber numberWithBool: YES] class]]) {
    ret = (((NSNumber*)from).boolValue) ? true : false;
  } else if ([from isKindOfClass:[NSNumber class]]) {
    ret = number_to_any((NSNumber*)from);
  } else if ([from isEqual:[NSNull null]] || from == nil) {
    ret = linear::type::nil_();
  } else {
    NSLog(@"BUG: unable to convert objc-object");
  }
  return ret;
}

id any_to_id(const msgpack::object& from) {
  switch (from.type) {
  case msgpack::type::NIL:
    return [NSNull null];
    break;
  case msgpack::type::BOOLEAN:
    return [[NSNumber alloc] initWithBool:from.via.boolean];
    break;
  case msgpack::type::POSITIVE_INTEGER:
    return [[NSNumber alloc] initWithUnsignedLongLong:from.via.u64];
    break;
  case msgpack::type::NEGATIVE_INTEGER:
    return [[NSNumber alloc] initWithLongLong:from.via.i64];
    break;
  case msgpack::type::FLOAT:
    return [[NSNumber alloc] initWithFloat:from.via.f64];
    break;
  case msgpack::type::STR:
    return [[NSString alloc] initWithBytes:from.via.str.ptr length:from.via.str.size encoding:NSUTF8StringEncoding];
    break;
  case msgpack::type::BIN:
    return [[NSData alloc] initWithBytes:from.via.bin.ptr length:from.via.bin.size];
    break;
  case msgpack::type::EXT:
    return [[NSData alloc] initWithBytes:from.via.ext.ptr length:from.via.ext.size + 1];
    break;
  case msgpack::type::ARRAY:
    {
      NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:from.via.array.size];
      msgpack::object* const pend = from.via.array.ptr + from.via.array.size;
      for (msgpack::object* p = from.via.array.ptr; p < pend; p++) {
        id item = any_to_id(*p);
        [array addObject:item];
      }
      return array;
    }
    break;
  case msgpack::type::MAP:
    {
      NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:from.via.map.size];
      msgpack::object_kv* const pend = from.via.map.ptr + from.via.map.size;
      for (msgpack::object_kv* p = from.via.map.ptr; p < pend; p++) {
        id key = any_to_id(p->key);
        id val = any_to_id(p->val);
        [dictionary setObject:val forKey:key];
      }
      return dictionary;
    }
    break;
  }
}

@implementation LinearTypeConverter

+ (linear::type::any)to_any:(id)from {
  return id_to_any(from);
}

+ (id)to_id:(const linear::type::any&)from {
  return any_to_id(from.object());
}

@end

