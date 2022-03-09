//
//  HICNoteInfoModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/24.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICNoteInfoModel : NSObject
/**
 "id":"long,笔记ID",
                    "title":"string,笔记标题",
                    "content":"string,笔记内容",
                    "majorFlag":"integer,重要标志：0-否，1-是",
                    "updateTime":"long,笔记时间，秒级时间戳"*/
@property (nonatomic ,strong)NSNumber *noteInfoId;//
@property (nonatomic ,strong)NSString *title;//
@property (nonatomic ,strong)NSString *content;//
@property (nonatomic ,assign)NSInteger majorFlag;//
@property (nonatomic ,strong)NSNumber *updateTime;
@end

NS_ASSUME_NONNULL_END
