//
//  HICOfflineLecturerFrame.h
//  HiClass
//
//  Created by hisense on 2020/4/24.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICOfflineLecturerData : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *post;
@property (nonatomic, strong) NSString *brief;

@property (nonatomic, assign) BOOL isSeparatorHidden;

- (instancetype)initWithTitle:(NSString *)title iconUrl:(NSString *)iconUrl name:(NSString *)name post:(NSString *)post brief:(NSString *)brief isSeparatorHidden:(BOOL) isSeparatorHidden;
@end



@interface HICOfflineLecturerFrame : NSObject

@property (nonatomic, strong) HICOfflineLecturerData *data;

@property (nonatomic, assign) BOOL isOpened;

@property (nonatomic, assign, readonly) CGRect titleLblF;
@property (nonatomic, assign, readonly) CGRect iconImgViewF;
@property (nonatomic, assign, readonly) CGRect nameLblF;
@property (nonatomic, assign, readonly) CGRect postLblF;
@property (nonatomic, assign, readonly) CGRect briefLblF;
@property (nonatomic, assign, readonly) CGRect openBtnF;
@property (nonatomic, assign, readonly) CGRect shrinkBtnF;
@property (nonatomic, assign, readonly) CGRect separatorLineViewF;
@property (nonatomic, assign, readonly) CGFloat cellHeight;


- (instancetype)initWithData:(HICOfflineLecturerData *)data isOpened:(BOOL)isOpened;

@end

NS_ASSUME_NONNULL_END
