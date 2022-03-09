//
//  HICCheckNoteModel.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/11.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICCheckNoteModel : NSObject

/// 笔记ID
@property (nonatomic, strong) NSNumber *noteId;

/// 笔记时间
@property (nonatomic, strong) NSNumber *noteTime;

/// 笔记标签
@property (nonatomic, strong) NSString *noteTag;

/// 笔记是否重要
@property (nonatomic, strong) NSNumber *noteMajorFlag;

/// 笔记标题
@property (nonatomic, strong) NSString *noteTitle;

/// 笔记内容
@property (nonatomic, strong) NSString *noteContent;

@end

NS_ASSUME_NONNULL_END
