//
//  HICLectureKnowledgeView.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/12.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICLectureKnowledgeView : UITableView
-(instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)NSNumber *lectureId;
@end

NS_ASSUME_NONNULL_END
