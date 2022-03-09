//
//  HICStudyVideoPlayRelatedCell.h
//  iTest
//
//  Created by Sir_Jing on 2020/2/4.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICStudyVideoPlayBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICStudyVideoPlayRelatedCell : HICStudyVideoPlayBaseCell

@property (nonatomic, copy) id relatedModel;
@property (nonatomic,strong) NSArray *dataArr;
//@property (nonatomic ,assign) BOOL isAll;
@end

NS_ASSUME_NONNULL_END
