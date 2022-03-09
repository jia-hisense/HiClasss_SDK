//
//  HICMixTrainArrangeTaskVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/16.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICMixTrainArrangeTaskVC.h"
#import "HICMixTrainTaskBubbleView.h"
#import "HICKnowledgeDetailVC.h"
#import "HICLessonsVC.h"
#import "HICExamCenterDetailVC.h"
#import "HICTrainQuestionVC.h"
#import "HICHomeworkListVC.h"
#import "HICOfflineCourseDetailVC.h"
#import "HICTrainSigninWebVC.h"
@interface HICMixTrainArrangeTaskVC ()
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,assign)CGFloat n;
@end
@implementation HICMixTrainArrangeTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.n = HIC_ScreenWidth / 375.0;
    [self createNavView];
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
-(void) createNavView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_StatusBar_Height + 44)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#00BED7"];
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame = CGRectMake(16, 11 + HIC_StatusBar_Height, 12, 22);
    [backbutton hicChangeButtonClickLength:30];
    [backbutton setImage:[UIImage imageNamed:@"头部-返回-白色"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backbutton];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10 + HIC_StatusBar_Height, HIC_ScreenWidth, 25)];
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.font = FONT_MEDIUM_18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _name;
    [backView addSubview:titleLabel];

    [self.view addSubview:backView];
}
- (void)createUI{
    NSInteger allCount = _dataArr.count;
    if (_dataArr.count == 0) {
        return;
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"#00BED7"];

    [self.view addSubview:self.scrollView];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 294 *_n)];
    topImage.image = [UIImage imageNamed:@"背景01"];
    topImage.userInteractionEnabled = YES;
    [self.scrollView addSubview:topImage];
    
    if (allCount <= 5) {
        self.scrollView.contentSize = CGSizeMake(HIC_ScreenWidth, (245 + 490)*_n);
        UIImageView *downImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, topImage.height, HIC_ScreenWidth, 490 *_n)];
        downImage.image = [UIImage imageNamed:@"背景图拼接"];
        downImage.userInteractionEnabled = YES;
        [self.scrollView addSubview:downImage];
    }else{
        NSInteger arrCount = (allCount - 5) / 4;
        NSInteger surplCount = (allCount - 5) % 4;
        if (surplCount == 0) {
            self.scrollView.contentSize = CGSizeMake(HIC_ScreenWidth, (245*_n + 490 *(arrCount + 1) + HIC_BottomHeight) *_n);
            for (int i = 0; i <= arrCount; i ++) {
                UIImageView *downImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, topImage.height + 490 * i *_n, HIC_ScreenWidth, 490 *_n)];
                downImage.image = [UIImage imageNamed:@"背景图拼接"];
                downImage.userInteractionEnabled = YES;
                [self.scrollView addSubview:downImage];
            }
        }else{
            for (int i = 0; i <= arrCount + 1; i ++) {
                UIImageView *downImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, topImage.height + 490 *i* _n, HIC_ScreenWidth, 490 *_n)];
                downImage.image = [UIImage imageNamed:@"背景图拼接"];
                downImage.userInteractionEnabled = YES;
                [self.scrollView addSubview:downImage];
            }
            self.scrollView.contentSize = CGSizeMake(HIC_ScreenWidth, (245* _n + 490 *(arrCount + 2)+ HIC_BottomHeight) *_n);
        }
        
    }
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth - 20 - 38, 94, 31*_n, 37.5*_n)];
    image1.image = [UIImage imageNamed:@"关卡-已完成"];
    [topImage addSubview:image1];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(image1.X - 4, image1.Y + image1.height + 4, 40 *_n ,20 * _n)];
    label1.text = NSLocalizableString(@"hasBeenCompleted", nil);
    label1.textColor = [UIColor colorWithHexString:@"#40963C"];
    label1.font = FONT_MEDIUM_13;
    label1.textAlignment = NSTextAlignmentCenter;
    [topImage addSubview:label1];
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth - 20 - 38, label1.Y + label1.height + 12, 31*_n, 37.5*_n)];
    image2.image = [UIImage imageNamed:@"关卡-进行中"];
    [topImage addSubview:image2];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(image1.X - 4, image2.Y + image2.height + 4, 40 *_n, 20 * _n)];
    label2.text = NSLocalizableString(@"ongoing", nil);
    label2.textColor = [UIColor colorWithHexString:@"#40963C"];
    label2.font = FONT_MEDIUM_13;
    label2.textAlignment = NSTextAlignmentCenter;
    [topImage addSubview:label2];
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth - 20 - 38, label2.Y + label2.height + 12, 31*_n, 37.5*_n)];
    image3.image = [UIImage imageNamed:@"关卡-未开始"];
    [topImage addSubview:image3];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(image1.X - 4, image3.Y + image3.height + 4, 40 *_n, 20 * _n)];
    label3.text = NSLocalizableString(@"other", nil);
    label3.textColor = [UIColor colorWithHexString:@"#40963C"];
    label3.font = FONT_MEDIUM_13;
    label3.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:label3];
    
    [self createPoint];
    
}

- (void)createPoint{
    NSInteger allCount = _dataArr.count;
    CGFloat startY = 138.5 *_n;
    CGFloat startBubleY = 101 *_n;
    NSString *title;
    for (int i = 0; i < allCount; i ++) {
        HICMixTrainArrangeListModel*model = _dataArr[i];
        title = [self title:model];
        CGSize levelSize = [title sizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:13] maxSize:CGSizeMake(MAXFLOAT, 19)];
        levelSize.width += 8;
        UIImageView *image;
        //        UIView *view;
        if (i %2) {
            image = [[UIImageView alloc]initWithFrame:CGRectMake(195*_n, startY, 31*_n, 37.5*_n)];
            image.image = [self imageWithModel:model];
            [self.scrollView addSubview:image];
            HICMixTrainTaskBubbleView *bubbleView;
            if (levelSize.width > 159 *_n) {
                bubbleView = [[HICMixTrainTaskBubbleView alloc]initWithFrame:CGRectMake(130 *_n, levelSize.width  > 159 *_n ? startBubleY - 20:startBubleY , 159 *_n, levelSize.width > 159*_n ? 54 *_n:36*_n)];
            }else{
                bubbleView = [[HICMixTrainTaskBubbleView alloc]initWithFrame:CGRectMake((130 + (159 - levelSize.width) /2 ) *_n, levelSize.width  > 159 *_n ? startBubleY - 20:startBubleY , levelSize.width *_n, levelSize.width > 159*_n ? 54 *_n:36*_n)];
            }

            bubbleView.fillColor = [self colorWithImage:image.image];
            [self.scrollView addSubview:bubbleView];
            bubbleView.title = title;
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(120 *_n, startBubleY, 150 *_n, 70 *_n)];
            view.tag = 21730982 + i;
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTpClick:)];
            [view addGestureRecognizer:tap2];
            view.userInteractionEnabled = YES;
            [self.scrollView addSubview:view];
            view.backgroundColor = UIColor.clearColor;
            startBubleY += (85 + 38)*_n;
            startY += (85 + 38)*_n;
        }else{
            image = [[UIImageView alloc]initWithFrame:CGRectMake(150.5*_n, startY, 31*_n, 37.5*_n)];
            //            image.image = [UIImage imageNamed:@"关卡-已完成"];
            image.image = [self imageWithModel:model];
            [self.scrollView addSubview:image];
            HICMixTrainTaskBubbleView *bubbleView;
            if (levelSize.width > 159 *_n) {
                bubbleView = [[HICMixTrainTaskBubbleView alloc]initWithFrame:CGRectMake(88.5 *_n, levelSize.width > 159*_n  ? startBubleY - 20:startBubleY , 159 *_n, levelSize.width > 159 *_n ?54 *_n:36*_n)];
            }else{
                bubbleView = [[HICMixTrainTaskBubbleView alloc]initWithFrame:CGRectMake((88.5 + (159 - levelSize.width) /2 ) *_n, levelSize.width > 159*_n  ? startBubleY - 20:startBubleY , levelSize.width *_n, levelSize.width > 159 *_n ?54 *_n:36*_n)];
            }

            bubbleView.fillColor = [self colorWithImage:image.image];
            [self.scrollView addSubview:bubbleView];
            bubbleView.title = title;
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100 *_n, startBubleY , 150 *_n, 70 *_n)];
            view.tag = 21730982 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTpClick:)];
            view.backgroundColor = UIColor.clearColor;
            [view addGestureRecognizer:tap];
            [self.scrollView addSubview:view];
            startBubleY +=  (85 + 38)*_n;
            startY += (85 + 38)*_n;
        }
    }
}
-(void)tapTpClick:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag - 21730982;
    HICMixTrainArrangeListModel*model = _dataArr[index];
    if ( !(model.taskType == 8 || model.taskType == 10) ) {
        if (model.curTime < model.startTime) {
            [HICToast showWithText:NSLocalizableString(@"notTimeToStudy", nil)];
            return;
        }
    }
    if (model.taskType != 8) {
        if (_trainTerminated == 10) {
            [HICToast showWithText:NSLocalizableString(@"trainingHasBeenCompleted", nil)];
            return;
        }
    }
    if (model.taskType == 3 || model.taskType == 4 || model.taskType == 6 || model.taskType == 7 || model.taskType == 8 ||model.taskType == 2 || model.taskType == 1) {
        // 考试 -- 跳转页面
        // 作业 -- 跳转到作业页面
        // 问卷 -- 跳转到问卷页面
        // 评价 -- 跳转页面
        // 课程 -- 跳转课程页面
        //        if ([self.delegate respondsToSelector:@selector(clickOtherButWithModel:)]) {
        //            [self.delegate clickOtherButWithModel:model];
        //        }
        if (model.taskType == 3){
            // 考试 -- 跳转页面
            HICExamCenterDetailVC *vc = HICExamCenterDetailVC.new;
            vc.examId = [NSString stringWithFormat:@"%@",model.resourceId];
            vc.trainId = [NSString stringWithFormat:@"%@",_trainId];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (model.taskType == 4){
            // 作业 -- 跳转到作业页面
            HICHomeworkListVC *vc = HICHomeworkListVC.new;
            vc.trainId = _trainId;
            vc.workId = [NSNumber numberWithInteger:model.taskId];
            vc.homeworkTitle = model.taskName;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (model.taskType == 6){
            // 问卷 -- 跳转到问卷页面
            HICTrainQuestionVC *vc = HICTrainQuestionVC.new;
            vc.trainId = _trainId;
            vc.taskId = [NSNumber numberWithInteger:model.taskId];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ( model.taskType == 7){
            // 评价 -- 跳转页面
            HICTrainQuestionVC *vc = HICTrainQuestionVC.new;
            vc.trainId = _trainId;
            vc.taskId = [NSNumber numberWithInteger:model.taskId];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (model.taskType == 8){
            // 课程 -- 跳转课程页面
            HICOfflineCourseDetailVC *vc = [HICOfflineCourseDetailVC new];
            vc.trainId = _trainId.integerValue;
            vc.taskId = model.taskId;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (model.taskType == 1){
            //线上课程
            HICLessonsVC *vc = [HICLessonsVC new];
            vc.objectID = model.resourceId;
            vc.trainId = _trainId;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (model.taskType == 2){
            //线上知识
            HICKnowledgeDetailVC *vc = HICKnowledgeDetailVC.new;
            vc.objectId = model.resourceId;
            vc.kType = model.resourceType;
            vc.trainId = _trainId;
            vc.partnerCode = model.partnerCode;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (model.taskType == 9) {//签到
               HICTrainSigninWebVC *vc = HICTrainSigninWebVC.new;
               vc.trainId = _trainId;
               vc.taskId = [NSNumber numberWithInteger:model.taskId];
               [self.navigationController pushViewController:vc animated:YES];
           } else if (model.taskType == 10){//签退
               HICTrainSigninWebVC *vc = HICTrainSigninWebVC.new;
               vc.trainId = _trainId;
               vc.taskId = [NSNumber numberWithInteger:model.taskId];
               [self.navigationController pushViewController:vc animated:YES];
           }else{

           }
}
- (UIColor *)colorWithImage:(UIImage *)image{
    if ([image isEqual:[UIImage imageNamed:@"关卡-未开始"]]) {
        return [UIColor colorWithHexString:@"#000000" alpha:0.5];
    }else if ([image isEqual:[UIImage imageNamed:@"关卡-进行中"]]){
        return [UIColor colorWithHexString:@"#00BED7" alpha:1];
    }else{
        return [UIColor colorWithHexString:@"#F59900" alpha:1];
    }
}
- (UIImage *)imageWithModel:(HICMixTrainArrangeListModel *)model{
    if (model.taskType == HICOfflineTaskKnowledge || model.taskType == HICOnLineTaskCourse) {
        if (model.startTime > model.curTime) {
            return [UIImage imageNamed:@"关卡-未开始"];
        }
        if (model.progress == 100){
            return [UIImage imageNamed:@"关卡-已完成"];
        }else{
            return [UIImage imageNamed:@"关卡-进行中"];
        }
    }else if(model.taskType == HICOfflineCourse){//线下课
        if (model.startTime > model.curTime) {
            return [UIImage imageNamed:@"关卡-未开始"];
        }
        if (model.offlineClassScore >= 0) {
            return [UIImage imageNamed:@"关卡-已完成"];
        }else{
            return [UIImage imageNamed:@"关卡-进行中"];
        }
    }else if (model.taskType == HICOfflineCourseGrade){//成绩
        if (model.offResultStatus == 0) {
            return [UIImage imageNamed:@"关卡-未开始"];
        }
        return [UIImage imageNamed:@"关卡-已完成"];
        
    }else if (model.taskType == HICOfflineTaskExam){//考试
        if (model.startTime > model.curTime) {
            return [UIImage imageNamed:@"关卡-未开始"];
        }
        if (model.examStatus == 2 || model.examStatus == 3){
            return [UIImage imageNamed:@"关卡-已完成"];
        }else{
            return [UIImage imageNamed:@"关卡-进行中"];
        }
    }else if (model.taskType == HICOfflineTaskHomework){//作业
        if (model.startTime > model.curTime) {
            return [UIImage imageNamed:@"关卡-未开始"];
        }
        if (model.commitTime > 0){
            return [UIImage imageNamed:@"关卡-已完成"];
        }else{
            return [UIImage imageNamed:@"关卡-进行中"];
        }
    }else if (model.taskType == HICOfflineTaskSignOn || model.taskType == HICOfflineTaskSignOff){
        if (model.startTime > model.curTime) {
            return [UIImage imageNamed:@"关卡-未开始"];
        }
        if (model.attendanceLastExeTime > 0) {
            return [UIImage imageNamed:@"关卡-已完成"];
        }else{
            return [UIImage imageNamed:@"关卡-进行中"];
        }
    }
    else{//问卷、评价
        if (model.startTime > model.curTime) {
            return [UIImage imageNamed:@"关卡-未开始"];
        }
        if (model.commitTime > 0) {
            return [UIImage imageNamed:@"关卡-已完成"];
        }else{
            return [UIImage imageNamed:@"关卡-进行中"];
        }
    }
    
    return [UIImage imageNamed:@""];
}
////// 任务类型，3-考试，4-作业，6-问卷，7-评价，8-线下课，9-签到，10-签退, 11-线下成绩",
- (NSString *)title:(HICMixTrainArrangeListModel *)model{
    if (model.taskType == HICOfflineTaskExam) {
        return [NSString stringWithFormat:@"%@:%@",NSLocalizableString(@"homework", nil),model.taskName];
    }else if (model.taskType == HICOfflineTaskHomework){
        return [NSString stringWithFormat:@"%@:%@",NSLocalizableString(@"homework", nil),model.taskName];
    }else if (model.taskType == HICOfflineTaskQuestion){
        return [NSString stringWithFormat:@"%@:%@",NSLocalizableString(@"questionnaire", nil),model.taskName];
    }else if (model.taskType == HICOfflineTaskAppraise){
        return [NSString stringWithFormat:@"%@:%@",NSLocalizableString(@"evaluation", nil),model.taskName];
    }else if (model.taskType == HICOfflineCourse){
        return [NSString stringWithFormat:@"%@:%@",NSLocalizableString(@"offlinePrograms", nil),model.taskName];
    }else if (model.taskType == HICOfflineTaskSignOn){
        return [NSString stringWithFormat:@"%@:%@",NSLocalizableString(@"signIn", nil),model.taskName];
    }else if (model.taskType == HICOfflineTaskSignOff){
        return [NSString stringWithFormat:@"%@:%@",NSLocalizableString(@"signBack", nil),model.taskName];
    }else if (model.taskType == HICOfflineCourseGrade){
        NSString *str;
        NSString *scoreStr;
        if (model.offResultStatus == 0) {
            // 未开始
            str = model.taskName;
            scoreStr = @"";
        }else {
            // 已评分的
            if (model.offResultEvalType == 1) {
                // 直接评分 -- 显示分数
                scoreStr = [HICCommonUtils formatFloat:model.offResultScore];
            }else{
                scoreStr = @"";
            }
            if (model.offResultPass == 0) {
                str = [NSString isValidStr:scoreStr] ? [NSString stringWithFormat:@"(%@)",NSLocalizableString(@"unqualified", nil)]:NSLocalizableString(@"unqualified", nil);
            }else if (model.offResultPass == 1){
                str = [NSString isValidStr:scoreStr] ? [NSString stringWithFormat:@"(%@)",NSLocalizableString(@"qualified", nil)]:NSLocalizableString(@"qualified", nil);
            }
        }
        return [NSString stringWithFormat:@"%@:%@%@",NSLocalizableString(@"results", nil),scoreStr,str];
    }else if (model.taskType == HICOfflineTaskKnowledge || model.taskType == HICOnLineTaskCourse){
        return [NSString stringWithFormat:@"%@:%@",NSLocalizableString(@"onlineCourses", nil),model.taskName];
    }
    return @"";
}
//- (UIImage *)image:(NSInteger)type{
//    if () {
//        <#statements#>
//    }
//}
- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_BottomHeight- HIC_NavBarAndStatusBarHeight)];
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"#00BED7"];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
@end
