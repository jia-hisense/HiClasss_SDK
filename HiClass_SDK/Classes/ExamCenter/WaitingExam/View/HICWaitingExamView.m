//
//  HICWaitingExamView.m
//  HiClass
//
//  Created by 铁柱， on 2020/1/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICWaitingExamView.h"
#import "HICExamCell.h"
#import "HICExamModel.h"
#import "HICExamCenterDetailVC.h"
#import "HICExamBaseVC.h"
static NSString *waitCell = @"waitCell";
@interface HICWaitingExamView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSIndexPath *cellIndexPath;
@property (nonatomic, strong)NSMutableArray *dataArr;
@end
@implementation HICWaitingExamView
- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUI:) name:@"labeladd" object:nil];
    }
    return self;
}
- (void)setDataArray:(NSMutableArray *)dataArray{
    self.dataArr = [NSMutableArray arrayWithArray:dataArray];
    [self reloadData];
}
- (void)createUI {
    self.backgroundColor = BACKGROUNG_COLOR;
    self.frame = CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 50 - 6);
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.separatorColor = [UIColor clearColor];
    [self configTableView];
}
- (void)configTableView {
    self.delegate = self;
    self.dataSource = self;
    
    self.estimatedRowHeight = 270;
    self.rowHeight = UITableViewAutomaticDimension;
    [self registerClass:[HICExamCell class] forCellReuseIdentifier:waitCell];
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
}
#pragma mark -HICExamBaseVCDelegate
- (void)reloadUI:(NSNotification *)noti{
    NSInteger index = [noti.userInfo[@"index"] integerValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    self.cellIndexPath = indexPath;
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -tableviewdelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICExamCell *cell = (HICExamCell *)[tableView dequeueReusableCellWithIdentifier:waitCell];
    if (cell == nil) {
        cell = [[HICExamCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:waitCell];
    }
    cell.model = [HICExamModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    if (self.cellIndexPath) {
        if (self.cellIndexPath == indexPath) {
            cell.isLabelHidden = NO;
        }
    }
    [cell setBorderStyleWithTableView:tableView indexPath:indexPath];
    return cell;
}
- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_MEDIUM_17;
    label.numberOfLines = 2;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 60 font:17 stringOnBtn:NO fontIsRegular:NO].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 60, labelHeight);
    [label sizeToFit];
//    if (labelHeight > 47) {
//           return 47;
//    }else{
//       return labelHeight;
//    }
    return label.frame.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArr[indexPath.row][@"baseInfo"];
    NSString *nameStr;
    if ([dic[@"tags"] isEqualToString:@"makeUp"]) {
        nameStr = [dic[@"name"] stringByAppendingFormat:NSLocalizableString(@"makeUpExamination", nil)];
    }else if([dic[@"tags"] isEqualToString:@"mulExam"] || [dic[@"tags"] isEqualToString:@""] ){
         nameStr = dic[@"name"];
    }else{
       nameStr = [dic[@"name"] stringByAppendingFormat:NSLocalizableString(@"important", nil)];
    }
    if ([dic[@"status"] intValue] == 0 || [dic[@"status"] intValue] == 4 || [dic[@"status"] intValue] == 1) {
           return [self getContentHeight:nameStr]  + 8 + 32 + 68 + 12;
       }else{
            return [self getContentHeight:nameStr] + 8 + 92.5 + 95 + 12;
       }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HICExamCenterDetailVC *detailVC = HICExamCenterDetailVC.new;
    NSDictionary *dic = self.dataArr[indexPath.row][@"baseInfo"];
    NSNumber *examID = [dic valueForKey:@"id"];
    detailVC.examId = [NSString stringWithFormat:@"%@", examID];
     [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"examListIndex"];
    ///日志上报
    HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICTaskTabClick];
    reportModel.tab = NSLocalizableString(@"waitKao", nil);
    reportModel.mediaid = [dic valueForKey:@"id"];
    reportModel.tasktype = [NSNumber numberWithInteger:HICReportExamType];
    reportModel.trainmode = @-1;
    NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
    [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICTaskTabClick]];
    [LogManager reportSerLogWithDict:report];
    [[HICCommonUtils viewController:self].navigationController pushViewController:detailVC animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 6)];
    line.backgroundColor = BACKGROUNG_COLOR;
    return line;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.backgroundColor = [UIColor clearColor];
}

@end
