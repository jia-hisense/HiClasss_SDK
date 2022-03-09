//
//  HICFinishedExam.m
//  HiClass
//
//  Created by 铁柱， on 2020/1/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICFinishedExam.h"
#import "HICExamCell.h"
#import "HICExamModel.h"
#import "HICExamCenterDetailVC.h"
static NSString *finishCell = @"finishCell";
@interface HICFinishedExam ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataArr;
@end
@implementation HICFinishedExam
- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
- (void)setDataArray:(NSMutableArray *)dataArray{
    self.dataArr = [NSMutableArray arrayWithArray:dataArray];
    [self reloadData];
}
- (void)createUI {
    self.backgroundColor = BACKGROUNG_COLOR;
    self.frame = CGRectMake(HIC_ScreenWidth *2, 0 , HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight - 50 - 6);
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.separatorColor = [UIColor clearColor];
    [self configTableView];
}
- (void)configTableView {
    self.delegate = self;
    self.dataSource = self;
    self.estimatedRowHeight = 251;
    self.rowHeight = UITableViewAutomaticDimension;
    [self registerClass:[HICExamCell class] forCellReuseIdentifier:finishCell];
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
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
//        labelHeight = 47;
//    }
    return label.frame.size.height;
}
#pragma mark -tableviewdelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICExamCell *cell = (HICExamCell *)[tableView dequeueReusableCellWithIdentifier:finishCell];
    if (cell == nil) {
        cell = [[HICExamCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:finishCell];
    }
    cell.model = [HICExamModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    [cell setBorderStyleWithTableView:tableView indexPath:indexPath];
    return cell;
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
    if ([dic[@"status"] isEqual:@1]) {
        return [self getContentHeight:nameStr] + 8+ 32 + 68 + 12;
    }else{
        return [self getContentHeight:nameStr] + 8+ 92.5 + 95 + 12;//+ 40 + 108 + 56 + 42
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HICExamCenterDetailVC *detailVC = HICExamCenterDetailVC.new;
    NSDictionary *dic = self.dataArr[indexPath.row][@"baseInfo"];
    NSNumber *examID = [dic valueForKey:@"id"];
    detailVC.examId = [NSString stringWithFormat:@"%@", examID];
    ///日志上报
       HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICTaskTabClick];
       reportModel.tab = NSLocalizableString(@"hasBeenCompleted", nil);
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
