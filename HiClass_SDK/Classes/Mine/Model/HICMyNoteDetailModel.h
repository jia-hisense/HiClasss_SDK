//
//  HICMyNoteDetailModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICMyNoteDetailModel : NSObject
/// 笔记ID
@property (nonatomic, strong) NSNumber *noteId;

/// 笔记时间
@property (nonatomic, strong) NSNumber *updateTime;

/// 笔记是否重要
@property (nonatomic, strong) NSNumber *noteMajorFlag;

/// 笔记标题
@property (nonatomic, strong) NSString *title;

/// 笔记内容
@property (nonatomic, strong) NSString *content;

@end

NS_ASSUME_NONNULL_END
