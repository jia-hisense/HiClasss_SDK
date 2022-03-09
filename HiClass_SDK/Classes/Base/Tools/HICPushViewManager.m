//
//  HICPushViewManager.m
//  HiClass
//
//  Created by wangggang on 2020/3/23.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICPushViewManager.h"

#import "HICCompanyKnowledgeVC.h"
#import "HICExamCenterDetailVC.h"
#import "HICLessonsVC.h"
#import "HICKnowledgeDetailVC.h"
#import "HICTrainDetailVC.h"
#import "HICLectureDetailVC.h"
#import "HICRankingListVC.h"
#import "HICExamBaseVC.h"
#import "HICOnlineTrainVC.h"
#import "HICPushCustoWebVC.h"
#import "HICHomePostDetailVC.h"
#import "HICMyCertificateDetailVC.h"
#import "HICBaseNavigationViewController.h"
#import "OfflineTrainPlanListVC.h" // 培训安排页面
#import "HICOfflineTrainInfoVC.h"
#import "HICEnrollDetailVC.h"
#import "HICMixTrainArrangeVC.h"
#import "HICMixTrainArrangeMapVC.h"
#import "HICNotEnrollTrainArrangeVC.h"
#import "HICLiveCenterVC.h"
@implementation PushViewControllerModel

- (instancetype)initWithPushType:(NSInteger)pushType urlStr:(NSString *)urlStr detailId:(NSInteger)detailId studyResourceType:(HICStudyResourceType)studyResourceType pushType:(NSInteger)isPush {

    if (self = [super init]) {
        _pushType = pushType;
        _urlStr = urlStr;
        _detailID = detailId;
        _studyResourceType = studyResourceType;
        _isPushType = isPush;
    }
    return self;
}

@end

@implementation HICPushViewManager

+ (void)parentVC:(UIViewController *)parentVC pushVCWithModel:(PushViewControllerModel *)model {
    if (model) {
        UIViewController *vc;
        NSInteger isPush = 0; // 默认的推出为PUSH
        switch (model.pushType) {
            case 0:
            {
                // 岗位/岗位目录
                vc = [HICHomePostDetailVC new];
                HICHomePostDetailVC *post = (HICHomePostDetailVC *)vc;
                post.trainPostId = model.detailID;
                post.titleName = NSLocalizableString(@"positionDetails", nil);
            }
                break;
            case 1:
            {
                // 试卷/试卷目录
                vc = [HICExamCenterDetailVC new];
                HICExamCenterDetailVC *deVC = (HICExamCenterDetailVC *)vc;
                deVC.examId = model.urlStr;
            }
                break;
            case 2:
                // 试题库/试题库目录

                break;
            case 3:
            {
                // 证书
                vc = [HICMyCertificateDetailVC new];
                HICMyCertificateDetailVC *cerVC = (HICMyCertificateDetailVC *)vc;
                cerVC.employeeCertId = [NSString stringWithFormat:@"%ld", (long)model.detailID];
            }
                break;
            case 4:
            {
                // 考试
                vc = [HICExamCenterDetailVC new];
                HICExamCenterDetailVC *deVC = (HICExamCenterDetailVC *)vc;
                deVC.examId = model.urlStr;
            }
                break;
            case 5:
            {
                // 知识/课程
                vc = [HICCompanyKnowledgeVC new];
                HICCompanyKnowledgeVC *kVC = (HICCompanyKnowledgeVC *)vc;
                kVC.dirId = model.pushId;
                if (model.titleName && ![model.titleName isEqualToString:@""]) {
                    kVC.title = model.titleName;
                }
                kVC.orderBy = model.orderBy;
                kVC.isHiddenNav = YES;
            }
                break;
            case 6:
            {
                // 课程
                vc = [HICLessonsVC new];
                HICLessonsVC *lessVC = (HICLessonsVC *)vc;
                lessVC.objectID = [NSNumber numberWithInteger:model.detailID];
            }
                break;
            case 7: { // 知识
                vc = [HICKnowledgeDetailVC new];
                HICKnowledgeDetailVC *konVC = (HICKnowledgeDetailVC *)vc;
                konVC.kType = model.studyResourceType;
                konVC.objectId = [NSNumber numberWithInteger:model.detailID];
            }
                break;
            case 8:{ // 报名
                if (model.workId > 0) {
                    vc = [HICOfflineTrainInfoVC new];
                    HICOfflineTrainInfoVC *offVc = (HICOfflineTrainInfoVC*)vc;
                    offVc.trainId = model.workId;
                    offVc.isRegisterJump = 1;
                    offVc.registerActionId = [NSNumber numberWithInteger:model.detailID];
                }else{
                    vc = [HICEnrollDetailVC new];
                    HICEnrollDetailVC *enVC = (HICEnrollDetailVC *)vc;
                    enVC.registerID = [NSNumber numberWithInteger:model.detailID];
                }
                break;
            }
            case 9:
                // 请假
                
                break;
            case 10:
                // 习题集
            
                break;
            case 11:
                // 线下课
            
                break;
            case 12:
            {
                // 培训详情
                vc = [HICTrainDetailVC new];
                HICTrainDetailVC *tranVC = (HICTrainDetailVC *)vc;
                tranVC.trainId = [NSNumber numberWithInteger:model.detailID];
            }
                break;
            case 13:
            {
                // 问卷/评价
                vc = [HICPushCustoWebVC new];
                HICPushCustoWebVC *web = (HICPushCustoWebVC *)vc;
                web.urlStr = model.urlStr;
                web.isCompanyUrl = YES;
            }
                break;
            case 14:
            {
                // 讲师
                vc = [HICLectureDetailVC new];
                HICLectureDetailVC *detVC = (HICLectureDetailVC *)vc;
                //TODO: 需要增加参数
                detVC.lecturerId = model.detailID;
            }
                break;
            case 15:
            {
                // 分类
                vc = [HICCompanyKnowledgeVC new];
            }
                break;
            case 30:
            {
                // 排行榜
                vc = [HICRankingListVC new];
                HICRankingListVC *listVC = (HICRankingListVC *)vc;
                // TODO: 需要增加参数
                listVC.rankType = model.detailID;
            }
                break;
            case 123:
            {
                // 混合培训
                if (model.registChannel == 2 || ((model.registChannel == 1 && model.workId > 0))){
                    if ([model.mixTrainType isEqualToString:@"classic"]) {
                        vc = [HICMixTrainArrangeVC new];
                        HICMixTrainArrangeVC *aVc = (HICMixTrainArrangeVC *)vc;
                        aVc.registerId = [NSNumber numberWithInteger:model.workId];
                        aVc.trainId = [NSNumber numberWithInteger:model.detailID];
                    }else{
                        vc = [HICMixTrainArrangeMapVC new];
                        HICMixTrainArrangeMapVC *aVc = (HICMixTrainArrangeMapVC *)vc;
                        aVc.registerId = [NSNumber numberWithInteger:model.workId];
                        aVc.trainId = [NSNumber numberWithInteger:model.detailID];
                        aVc.taskName = model.titleName;
                        //                        aVc.taskName = @"";
                    }
                }
                else{
                    vc = [HICNotEnrollTrainArrangeVC new];
                    HICNotEnrollTrainArrangeVC *aVc = (HICNotEnrollTrainArrangeVC *)vc;
                    aVc.trainId = [NSNumber numberWithInteger:model.detailID];
                }
            }
                    break;
            case 122:
            {
                // 线下培训
                if (model.childType == 0) {
                    // 线下培训详情页
                    vc = [HICOfflineTrainInfoVC new];
                    HICOfflineTrainInfoVC *tvc = (HICOfflineTrainInfoVC *)vc;
                    tvc.trainId = model.detailID;
                    tvc.isStarted = NO;
                    tvc.registerActionId = [NSNumber numberWithInteger:model.workId];
                } else {
                    if (model.registChannel == 2 || (model.registChannel == 1 )) {//指派或报名
                        // 培训安排页面
                        vc = [[OfflineTrainPlanListVC alloc] init];
                        OfflineTrainPlanListVC *ct = (OfflineTrainPlanListVC*)vc;
                        ct.trainId = model.detailID;
                        ct.isShowRightMore = YES;
                    }else{
                        vc = [HICNotEnrollTrainArrangeVC new];
                        HICNotEnrollTrainArrangeVC *aVc = (HICNotEnrollTrainArrangeVC *)vc;
                        aVc.trainId = [NSNumber numberWithInteger:model.detailID];
                    }

                }
            }
                break;
            case 1001:
                // 视频会议
                break;
            case 1002:
            {
                // TODO: 岗位地图
                if ([RoleManager.showTabBarMenus containsObject:@"AppJobMapF"]) {
                    NSInteger index = [RoleManager.showTabBarMenus indexOfObject:@"AppJobMapF"];
                    if (index < parentVC.tabBarController.childViewControllers.count) {
                        [parentVC.tabBarController setSelectedIndex:index];
                    }
                }
            }
                break;
            case 1003:
            {
                // 考试中心
                vc = [HICExamBaseVC new];
            }
                break;
            case 1004:
            {
                // 培训管理列表
                vc = [HICOnlineTrainVC new];
//                HICOnlineTrainVC *tranVC = (HICOnlineTrainVC *)vc;
            }
                break;
            case 1005:
            {
                // 问卷
                
            }
                break;
            case 1006:
                // 报名
            
                break;
            case 1007:
                // 企业知识
                vc = [HICCompanyKnowledgeVC new];
                break;
            case 1008:
            {
                // 自定义URL
                vc = [HICPushCustoWebVC new];
                HICPushCustoWebVC *web = (HICPushCustoWebVC *)vc;
                web.urlStr = model.urlStr;
            }
                break;
            case 1009:
            {
                // 自定义链接目录
                vc = [HICCompanyKnowledgeVC new];
                HICCompanyKnowledgeVC *kVC = (HICCompanyKnowledgeVC *)vc;
                kVC.dirId = [NSString stringWithFormat:@"%ld", (long)model.detailID];
                kVC.isOnleVideo = model.companyOnlyVideo;
                kVC.isHiddenNav = NO;
            }
                break;
            case 1010:
                // 仅展示图片
            
                break;
                
            case 1012 :
                //直播
            {
                vc = [HICLiveCenterVC new];
                [LogManager reportSerLogWithType:HICLiveCenter params:nil];
            }
                break;
            case 1013 :
                //答题游戏
            {
                vc = [HICPushCustoWebVC new];
                HICPushCustoWebVC *web = (HICPushCustoWebVC *)vc;
                web.urlStr = [NSString stringWithFormat:@"%@/mweb/index.html?#/games", APP_Web_DOMAIN];
                web.isCompanyUrl = YES;
            }
                break;
            default:
                break;
        }
        if (!vc) {
            // 没有找到对应的跳转页面
            return;
        }
        if (isPush == 0) {
            if ([parentVC isKindOfClass:UINavigationController.class]) {
                HICBaseNavigationViewController *nvc = (HICBaseNavigationViewController *)parentVC;
                [nvc pushViewController:vc animated:YES];
            } else {
                [parentVC.navigationController pushViewController:vc animated:YES];
            }
        }else if (isPush == 1) {
            [parentVC presentViewController:vc animated:YES completion:^{
               // 执行完成
            }];
        }else if (isPush == 2) {
            // tab页面切换
        }
    }
}

@end
