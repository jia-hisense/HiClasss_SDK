//
//  HICTrainQuestionVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/23.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICTrainQuestionVC.h"

@interface HICTrainQuestionVC ()

@end

@implementation HICTrainQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * urlStr = [NSString stringWithFormat:@"%@/mweb/index.html#/questionnaire?questionActionId=%@&trainId=%@",APP_Web_DOMAIN,_taskId,_trainId];
    [HiWebViewManager addParentVC:self urlStr:urlStr isDelegate:YES isPush:YES hideCusNavi:YES hideCusTabBar:YES];
}

@end
