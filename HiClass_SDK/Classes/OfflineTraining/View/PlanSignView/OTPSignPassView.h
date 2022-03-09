//
//  OTPSignPassView.h
//  HiClass
//
//  Created by 铁柱， on 2020/4/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PassViewBlock)(NSString *inputText);
@interface OTPSignPassView : UIView

@property (nonatomic, copy) PassViewBlock backBlock; // 初始化对象回调的block
-(instancetype)initWithFrame:(CGRect)frame andParentView:(UIView *)parentView;// 构造函数
-(void)showPassView; // 显示页面

+(void)showWindowPassViewBlock:(PassViewBlock)block; // 直接显示到window上，实现全屏遮盖和回调

@end

NS_ASSUME_NONNULL_END
