//
//  CHWhiteBoardSkinManager.h
//  CHWhiteBoard
//
//

#import <Foundation/Foundation.h>

// 换肤
#define CHSkinWhiteDefineColor(s) [[CHWhiteBoardSkinManager shareInstance] getDefaultColorWithKey:(s)]
#define CHSkinWhiteDefineImage(s) [[CHWhiteBoardSkinManager shareInstance] getDefaultImageWithKey:(s)]

#define CHSkinWhiteElementColor(z , s) [[CHWhiteBoardSkinManager shareInstance] getElementColorWithName:(z) andKey:(s)]
#define CHSkinWhiteElementImage(z , s) [[CHWhiteBoardSkinManager shareInstance] getElementImageWithName:(z) andKey:(s)]

NS_ASSUME_NONNULL_BEGIN

@interface CHWhiteBoardSkinManager : NSObject

+ (instancetype)shareInstance;
+ (void)destroy;

- (UIColor *)getDefaultColorWithKey:(NSString *)key;
- (UIImage *)getDefaultImageWithKey:(NSString *)key;

- (nullable UIColor *)getElementColorWithName:(NSString *)name andKey:(NSString *)key;
- (nullable UIImage *)getElementImageWithName:(NSString *)name andKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
