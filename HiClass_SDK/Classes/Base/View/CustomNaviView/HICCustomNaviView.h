//
//  HICCustomNaviView.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HICCustomNaviViewDelegate <NSObject>
@optional

- (void)leftBtnClicked;
- (void)rightBtnClicked:(NSString *)str;

@end

@interface HICCustomNaviView : UIView

@property (nonatomic, weak) id<HICCustomNaviViewDelegate>delegate;

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, strong)UIButton *goBackBtn;
@property (nonatomic, assign)BOOL hideLeftBtn;

- (instancetype)initWithTitle:(NSString *)title rightBtnName:(NSString * __nullable)rightBtnName  showBtnLine:(BOOL)showBtnLine;
- (void)setRightBtnText:(NSString * __nullable)str;
- (void)modifyTitleLabel:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
