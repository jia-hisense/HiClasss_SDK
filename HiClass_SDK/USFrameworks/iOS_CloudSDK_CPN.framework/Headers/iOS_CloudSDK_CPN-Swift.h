#if 0
#elif defined(__arm64__) && __arm64__
// Generated by Apple Swift version 5.4 (swiftlang-1205.0.26.9 clang-1205.0.19.55)
#ifndef IOS_CLOUDSDK_CPN_SWIFT_H
#define IOS_CLOUDSDK_CPN_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import Foundation;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="iOS_CloudSDK_CPN",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

@class UIViewController;
@class UIButton;
@class NSDictionary;
@class NSString;

SWIFT_CLASS("_TtC16iOS_CloudSDK_CPN11CommonTools")
@interface CommonTools : NSObject
/// Request dash board listing all customer information with entrance of subpage, such as modifying avatar or update new password.
/// Tips: Important! It’s not guarenteed ‘self.navigationController’ existed but use ‘push’ as default translation, sdk doesn’t do any adaption neither. So you have to make sure this controller can only be pushed with navigationController for security reasons. Also, we are dealing with the problem that more than three hierarchy of PresentedViewController/NavigationViewController/TabBarViewController may facing bugs with UI components.
///
/// returns:
/// UIViewController, listing Hisense account informations, also providing logout button.
+ (UIViewController * _Nonnull)getVCPersonalDashBoard;
/// Request main entrance of login submodule, avaliable for operations of AccountLogin, ForgetPassword, RegistNewAccount, WechatLogin
/// \param wechatCallBack Wechat login call back closure, call when icon button touched up inside.
///
///
/// returns:
/// UIViewController, providing login and regist entrance.
+ (UIViewController * _Nonnull)getVCLoginDashBoardWithThirdLogin:(NSArray * _Nonnull)thirdLogin customBtn:(NSArray<UIButton *> * _Nonnull)customBtn;
+ (UIViewController * _Nonnull)getBindPhoneNumberVC;
+ (void)saveTokenInfoFromH5WithTokenDic:(NSDictionary * _Nonnull)tokenDic;
+ (void)saveUserInfoFromH5WithUserDic:(NSDictionary * _Nonnull)userDic;
/// <ul>
///   <li>
///     根据输入自动参数，生成签名返回，此接口用于网关类型签名验证
///   </li>
/// </ul>
+ (NSString * _Nonnull)getJHKSignGWWithUserDic:(NSDictionary * _Nonnull)userDic;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSNumber;

@interface CommonTools (SWIFT_EXTENSION(iOS_CloudSDK_CPN))
/// 设置SDK启动参数
/// \param aesKey aesKey
///
/// \param aesVi aesVi
///
/// \param appKey appKey
///
/// \param appSecret appSecret
///
+ (void)setCloudSDKParamsWithAesKey:(NSString * _Nonnull)aesKey aesVi:(NSString * _Nonnull)aesVi appKey:(NSString * _Nonnull)appKey appSecret:(NSString * _Nonnull)appSecret;
/// 启动登录SDK
+ (void)launch;
/// 统一网关网络请求-简化参数
/// \param url url
///
/// \param contentType contentType unknownType = 0; jsonType = 1; wwwFormType = 2; formType = 3;
///
/// \param methodType methodType GET：0 POST：1
///
/// \param params params
///
/// \param success 返回可选字典类型
///
/// \param failure 返回可选NSError
///
+ (void)netRequestWithUrl:(NSString * _Nonnull)url contentType:(NSInteger)contentType methodType:(NSInteger)methodType params:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(id _Nullable))success failure:(void (^ _Nonnull)(id _Nullable))failure;
/// 统一网关网络请求
/// \param url url
///
/// \param params params
///
/// \param contentType contentType unknownType = 0; jsonType = 1; wwwFormType = 2; formType = 3;
///
/// \param methodType methodType GET：0 POST：1
///
/// \param responseType responseType JSONType = 0; XMLType = 1;
///
/// \param needSignDownCheck needSignDownCheck
///
/// \param signType signType accountSign = 0; gatewaySign = 1;
///
/// \param publicKey publicKey
///
/// \param salt salt
///
/// \param signInHeader signInHeader
///
/// \param customHeader customHeader
///
/// \param timeout timeout
///
/// \param formatSpecialCharacters formatSpecialCharacters
///
/// \param success 返回可选字典类型
///
/// \param failure 返回可选NSError
///
+ (void)netRequestWithFullValueWithUrl:(NSString * _Nonnull)url params:(NSDictionary<NSString *, id> * _Nonnull)params contentType:(NSInteger)contentType methodType:(NSInteger)methodType responseType:(NSInteger)responseType needSignDownCheck:(BOOL)needSignDownCheck signType:(NSInteger)signType publicKey:(NSString * _Nonnull)publicKey salt:(NSString * _Nonnull)salt signInHeader:(BOOL)signInHeader customHeader:(NSDictionary<NSString *, id> * _Nullable)customHeader timeout:(NSTimeInterval)timeout formatSpecialCharacters:(BOOL)formatSpecialCharacters success:(void (^ _Nonnull)(id _Nullable))success failure:(void (^ _Nonnull)(id _Nullable))failure;
/// 获取登录相关信息，包含isLogIn、customerId、deviceId、token
///
/// returns:
/// 返回字典
+ (NSDictionary * _Nullable)getLogInfo SWIFT_WARN_UNUSED_RESULT;
/// 获取token
///
/// returns:
/// token
+ (NSString * _Nullable)getToken SWIFT_WARN_UNUSED_RESULT;
/// 获取customerId
///
/// returns:
/// customerId
+ (NSString * _Nullable)getCustomerId SWIFT_WARN_UNUSED_RESULT;
/// 获取customerName
///
/// returns:
/// customerName
+ (NSString * _Nullable)getCustomerName SWIFT_WARN_UNUSED_RESULT;
/// 获取subscriberId
///
/// returns:
/// subscriberId
+ (NSString * _Nullable)getSubscriberId SWIFT_WARN_UNUSED_RESULT;
/// 获取loginName
///
/// returns:
/// loginName
+ (NSString * _Nullable)getLoginName SWIFT_WARN_UNUSED_RESULT;
/// 获取refreshToken
///
/// returns:
/// refreshToken
+ (NSString * _Nullable)getRefreshToken SWIFT_WARN_UNUSED_RESULT;
/// 获取tokenCreateTime
///
/// returns:
/// tokenCreateTime
+ (NSString * _Nullable)getTokenCreateTime SWIFT_WARN_UNUSED_RESULT;
/// 获取tokenExpiredTime
///
/// returns:
/// tokenExpiredTime
+ (NSString * _Nullable)getTokenExpiredTime SWIFT_WARN_UNUSED_RESULT;
/// 设置当前为苹果登录模式
+ (void)setAccountSignTypeToApple;
/// 获取DeviceID
///
/// returns:
/// String
+ (NSString * _Nonnull)getDeviceID SWIFT_WARN_UNUSED_RESULT;
/// 获取是否登录
///
/// returns:
/// Bool
+ (BOOL)isLogined SWIFT_WARN_UNUSED_RESULT;
/// 匿名登录
/// \param complete 完成回调
///
+ (void)logoutDirectWithComplete:(void (^ _Nonnull)(BOOL))complete;
/// 保存h5登录信息
/// \param tokenInfo 登录信息
///
+ (void)saveTokenInfoFromH5WithTokenInfo:(NSDictionary * _Nonnull)tokenInfo;
@end

typedef SWIFT_ENUM(NSInteger, HTTPContentType, closed) {
  HTTPContentTypeUnknownType = 0,
  HTTPContentTypeJsonType = 1,
  HTTPContentTypeWwwFormType = 2,
  HTTPContentTypeFormType = 3,
};

typedef SWIFT_ENUM(NSInteger, HTTPMethod, closed) {
  HTTPMethodGET = 0,
  HTTPMethodPOST = 1,
};



SWIFT_CLASS("_TtC16iOS_CloudSDK_CPN11NetWorkTool")
@interface NetWorkTool : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end

typedef SWIFT_ENUM(NSInteger, ResponseType, closed) {
  ResponseTypeJSONType = 0,
  ResponseTypeXMLType = 1,
};

typedef SWIFT_ENUM(NSInteger, SignType, closed) {
  SignTypeAccountSign = 0,
  SignTypeGatewaySign = 1,
};






SWIFT_CLASS("_TtC16iOS_CloudSDK_CPN5WeAPI")
@interface WeAPI : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
#endif

#elif defined(__ARM_ARCH_7A__) && __ARM_ARCH_7A__
// Generated by Apple Swift version 5.4 (swiftlang-1205.0.26.9 clang-1205.0.19.55)
#ifndef IOS_CLOUDSDK_CPN_SWIFT_H
#define IOS_CLOUDSDK_CPN_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import Foundation;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="iOS_CloudSDK_CPN",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

@class UIViewController;
@class UIButton;
@class NSDictionary;
@class NSString;

SWIFT_CLASS("_TtC16iOS_CloudSDK_CPN11CommonTools")
@interface CommonTools : NSObject
/// Request dash board listing all customer information with entrance of subpage, such as modifying avatar or update new password.
/// Tips: Important! It’s not guarenteed ‘self.navigationController’ existed but use ‘push’ as default translation, sdk doesn’t do any adaption neither. So you have to make sure this controller can only be pushed with navigationController for security reasons. Also, we are dealing with the problem that more than three hierarchy of PresentedViewController/NavigationViewController/TabBarViewController may facing bugs with UI components.
///
/// returns:
/// UIViewController, listing Hisense account informations, also providing logout button.
+ (UIViewController * _Nonnull)getVCPersonalDashBoard;
/// Request main entrance of login submodule, avaliable for operations of AccountLogin, ForgetPassword, RegistNewAccount, WechatLogin
/// \param wechatCallBack Wechat login call back closure, call when icon button touched up inside.
///
///
/// returns:
/// UIViewController, providing login and regist entrance.
+ (UIViewController * _Nonnull)getVCLoginDashBoardWithThirdLogin:(NSArray * _Nonnull)thirdLogin customBtn:(NSArray<UIButton *> * _Nonnull)customBtn;
+ (UIViewController * _Nonnull)getBindPhoneNumberVC;
+ (void)saveTokenInfoFromH5WithTokenDic:(NSDictionary * _Nonnull)tokenDic;
+ (void)saveUserInfoFromH5WithUserDic:(NSDictionary * _Nonnull)userDic;
/// <ul>
///   <li>
///     根据输入自动参数，生成签名返回，此接口用于网关类型签名验证
///   </li>
/// </ul>
+ (NSString * _Nonnull)getJHKSignGWWithUserDic:(NSDictionary * _Nonnull)userDic;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSNumber;

@interface CommonTools (SWIFT_EXTENSION(iOS_CloudSDK_CPN))
/// 设置SDK启动参数
/// \param aesKey aesKey
///
/// \param aesVi aesVi
///
/// \param appKey appKey
///
/// \param appSecret appSecret
///
+ (void)setCloudSDKParamsWithAesKey:(NSString * _Nonnull)aesKey aesVi:(NSString * _Nonnull)aesVi appKey:(NSString * _Nonnull)appKey appSecret:(NSString * _Nonnull)appSecret;
/// 启动登录SDK
+ (void)launch;
/// 统一网关网络请求-简化参数
/// \param url url
///
/// \param contentType contentType unknownType = 0; jsonType = 1; wwwFormType = 2; formType = 3;
///
/// \param methodType methodType GET：0 POST：1
///
/// \param params params
///
/// \param success 返回可选字典类型
///
/// \param failure 返回可选NSError
///
+ (void)netRequestWithUrl:(NSString * _Nonnull)url contentType:(NSInteger)contentType methodType:(NSInteger)methodType params:(NSDictionary<NSString *, id> * _Nonnull)params success:(void (^ _Nonnull)(id _Nullable))success failure:(void (^ _Nonnull)(id _Nullable))failure;
/// 统一网关网络请求
/// \param url url
///
/// \param params params
///
/// \param contentType contentType unknownType = 0; jsonType = 1; wwwFormType = 2; formType = 3;
///
/// \param methodType methodType GET：0 POST：1
///
/// \param responseType responseType JSONType = 0; XMLType = 1;
///
/// \param needSignDownCheck needSignDownCheck
///
/// \param signType signType accountSign = 0; gatewaySign = 1;
///
/// \param publicKey publicKey
///
/// \param salt salt
///
/// \param signInHeader signInHeader
///
/// \param customHeader customHeader
///
/// \param timeout timeout
///
/// \param formatSpecialCharacters formatSpecialCharacters
///
/// \param success 返回可选字典类型
///
/// \param failure 返回可选NSError
///
+ (void)netRequestWithFullValueWithUrl:(NSString * _Nonnull)url params:(NSDictionary<NSString *, id> * _Nonnull)params contentType:(NSInteger)contentType methodType:(NSInteger)methodType responseType:(NSInteger)responseType needSignDownCheck:(BOOL)needSignDownCheck signType:(NSInteger)signType publicKey:(NSString * _Nonnull)publicKey salt:(NSString * _Nonnull)salt signInHeader:(BOOL)signInHeader customHeader:(NSDictionary<NSString *, id> * _Nullable)customHeader timeout:(NSTimeInterval)timeout formatSpecialCharacters:(BOOL)formatSpecialCharacters success:(void (^ _Nonnull)(id _Nullable))success failure:(void (^ _Nonnull)(id _Nullable))failure;
/// 获取登录相关信息，包含isLogIn、customerId、deviceId、token
///
/// returns:
/// 返回字典
+ (NSDictionary * _Nullable)getLogInfo SWIFT_WARN_UNUSED_RESULT;
/// 获取token
///
/// returns:
/// token
+ (NSString * _Nullable)getToken SWIFT_WARN_UNUSED_RESULT;
/// 获取customerId
///
/// returns:
/// customerId
+ (NSString * _Nullable)getCustomerId SWIFT_WARN_UNUSED_RESULT;
/// 获取customerName
///
/// returns:
/// customerName
+ (NSString * _Nullable)getCustomerName SWIFT_WARN_UNUSED_RESULT;
/// 获取subscriberId
///
/// returns:
/// subscriberId
+ (NSString * _Nullable)getSubscriberId SWIFT_WARN_UNUSED_RESULT;
/// 获取loginName
///
/// returns:
/// loginName
+ (NSString * _Nullable)getLoginName SWIFT_WARN_UNUSED_RESULT;
/// 获取refreshToken
///
/// returns:
/// refreshToken
+ (NSString * _Nullable)getRefreshToken SWIFT_WARN_UNUSED_RESULT;
/// 获取tokenCreateTime
///
/// returns:
/// tokenCreateTime
+ (NSString * _Nullable)getTokenCreateTime SWIFT_WARN_UNUSED_RESULT;
/// 获取tokenExpiredTime
///
/// returns:
/// tokenExpiredTime
+ (NSString * _Nullable)getTokenExpiredTime SWIFT_WARN_UNUSED_RESULT;
/// 设置当前为苹果登录模式
+ (void)setAccountSignTypeToApple;
/// 获取DeviceID
///
/// returns:
/// String
+ (NSString * _Nonnull)getDeviceID SWIFT_WARN_UNUSED_RESULT;
/// 获取是否登录
///
/// returns:
/// Bool
+ (BOOL)isLogined SWIFT_WARN_UNUSED_RESULT;
/// 匿名登录
/// \param complete 完成回调
///
+ (void)logoutDirectWithComplete:(void (^ _Nonnull)(BOOL))complete;
/// 保存h5登录信息
/// \param tokenInfo 登录信息
///
+ (void)saveTokenInfoFromH5WithTokenInfo:(NSDictionary * _Nonnull)tokenInfo;
@end

typedef SWIFT_ENUM(NSInteger, HTTPContentType, closed) {
  HTTPContentTypeUnknownType = 0,
  HTTPContentTypeJsonType = 1,
  HTTPContentTypeWwwFormType = 2,
  HTTPContentTypeFormType = 3,
};

typedef SWIFT_ENUM(NSInteger, HTTPMethod, closed) {
  HTTPMethodGET = 0,
  HTTPMethodPOST = 1,
};



SWIFT_CLASS("_TtC16iOS_CloudSDK_CPN11NetWorkTool")
@interface NetWorkTool : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end

typedef SWIFT_ENUM(NSInteger, ResponseType, closed) {
  ResponseTypeJSONType = 0,
  ResponseTypeXMLType = 1,
};

typedef SWIFT_ENUM(NSInteger, SignType, closed) {
  SignTypeAccountSign = 0,
  SignTypeGatewaySign = 1,
};






SWIFT_CLASS("_TtC16iOS_CloudSDK_CPN5WeAPI")
@interface WeAPI : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
#endif

#endif