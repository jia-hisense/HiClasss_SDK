//
//  CHSkinModel.h
//  CHSession
//
//  Created by 马迪 on 2020/12/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHSkinModel : NSObject

///背景类型：0 纯色 1 图片
@property (nonatomic, assign, readonly) NSInteger backgroundType;
///背景值：纯色时为色值，图片时为图片地址
@property (nonatomic, copy, readonly) NSString *backgroundValue;


///白板类型：0 纯色 1 图片 2、透明层（背景）
@property (nonatomic, assign, readonly) CHSkinWhiteboardType whiteboardType;
///白板值：纯色时为色值，图片时为1对1图片地址
@property (nonatomic, copy, readonly) NSString *whiteboardValue;
///白板图片时1对多图片地址
@property (nonatomic, copy, readonly) NSString *whiteboardSecondValue;

///移动端房间外填充类型：0 纯色 1 图片
@property (nonatomic, assign, readonly) NSInteger mobileroomFillType;
///移动端房间外填充值：纯色时为色值，图片时为图片地址
@property (nonatomic, copy, readonly) NSString *mobileroomFillValue;


///细节配色类型：1表示默认 其他值是下载bundle
@property (nonatomic, assign, readonly) NSInteger detailType;
///细节配色资源包名称
@property (nonatomic, copy, readonly) NSString *detailName;
///细节配色资源包地址
@property (nonatomic, copy, readonly) NSString *detailUrl;


+ (nullable instancetype)roomSkinModelWithDic:(nullable NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
