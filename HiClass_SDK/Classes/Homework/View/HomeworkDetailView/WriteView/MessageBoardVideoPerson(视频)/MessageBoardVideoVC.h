//
//  MessageBoardVideoVC.h
//  SHChatUI
//
//  Created by wangggang on 2019/10/16.
//  Copyright © 2019 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

//完成回调
typedef void(^FinishBlock)(id content, NSString *duration);

@interface MessageBoardVideoVC : UIViewController

//进度颜色(默认 orangeColor)
@property (nonatomic, copy) UIColor *progressColor;
//最大时长(默认 15)
@property (nonatomic, assign) NSInteger maxSeconds;
//是否保存到系统(默认 不保存)
@property (nonatomic, assign) BOOL isSave;
//完成回调
@property (nonatomic, copy) FinishBlock finishBlock;

@end

NS_ASSUME_NONNULL_END
