//
//  JHKOfflineCourseDefaultSectionView.m
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "JHKOfflineCourseDefaultSectionView.h"

@implementation JHKOfflineCourseDefaultSectionView
+(instancetype)getDefaultSectionView{
    return [[[NSBundle mainBundle]loadNibNamed:@"JHKOfflineCourseView" owner:self options:nil]objectAtIndex:5];
}

@end
