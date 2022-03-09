//
//  HICMyNoteModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/24.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICMyNoteModel : NSObject
/**
"id":"long,学习笔记关联ID",
               "courseKLDInfo":Object{...},
               "notesNum":"integer,笔记个数",
               "notesInfo":Object{...}
*/
@property (nonatomic ,strong)NSNumber *noteId;
@property (nonatomic ,strong)NSDictionary *courseKLDInfo;
@property (nonatomic ,assign)NSInteger notesNum;//笔记个数
//@property (nonatomic ,strong)NSDictionary *notesInfo;
@end

NS_ASSUME_NONNULL_END
