//
//  HICKonwledgeMaskTableView.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/27.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICKonwledgeMaskTableView.h"
#import "HICStudyVideoPlayRelatedCell.h"
#import "HICExercisesListItemCell.h"
#import "HICKnowledgeDetailVC.h"
#import "HICCourseModel.h"
#import "HICContributeKnowledgeCell.h"
#import "HICLessonsVC.h"
@interface HICKonwledgeMaskTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSNumber *type;
@property (nonatomic ,strong)NSArray *dataArr;
@end
@implementation HICKonwledgeMaskTableView
-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.frame = CGRectMake(0, 0, HIC_ScreenWidth, 500);
    self.backgroundColor = UIColor.whiteColor;
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:[HICContributeKnowledgeCell class] forCellReuseIdentifier:@"related"];
    [self registerClass:[HICExercisesListItemCell class] forCellReuseIdentifier:@"excise"];
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
}
-(void)setDataArr:(NSArray *)dataArr andType:(NSNumber *)type{
    self.dataArr = [NSArray arrayWithArray:dataArr];
    self.type = type;
    [self reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if ([self.type isEqual:@0]) {
//        return self.dataArr.count;
//    }else{
//        return 1;
//    }
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqual:@0]) {
//        HICStudyVideoPlayExercisesCell *cell = (HICStudyVideoPlayExercisesCell *)[tableView dequeueReusableCellWithIdentifier:@"excise"];
//        if (!cell) {
//            cell = [[HICStudyVideoPlayExercisesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"excise"];
//        }
//        return cell;
        HICExercisesListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"excise" forIndexPath:indexPath];
        if (!cell) {
            cell = [[HICExercisesListItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"excise"];
        }
        cell.exciseModel = [HICExerciseModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
        return cell;
    }else{
        HICContributeKnowledgeCell *cell = (HICContributeKnowledgeCell *)[tableView dequeueReusableCellWithIdentifier:@"related"];
               if (!cell) {
                   cell = [[HICContributeKnowledgeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"related"];
               }
//        cell.isAll = YES;
//        cell.dataArr = self.dataArr;
        cell.courseModel = [HICCourseModel mj_objectWithKeyValues:self.dataArr[indexPath.row][@"courseKLDInfo"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqual:@0]) {
        return 50;
    }else{
        if (indexPath.row == 0) {
            return 106;
        }else{
          return 100;
        }
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HICCourseModel *courseModel = [HICCourseModel mj_objectWithKeyValues:self.dataArr[indexPath.row][@"courseKLDInfo"]];
    
    if (courseModel.courseKLDType == 6) {
        HICLessonsVC *vc = [HICLessonsVC new];
        vc.objectID = courseModel.courseKLDId;
        [[HICCommonUtils viewController:self].navigationController pushViewController:vc animated:YES];
    }else{
       HICKnowledgeDetailVC *vc = [HICKnowledgeDetailVC new];
        vc.kType = courseModel.resourceType;
        vc.objectId = courseModel.courseKLDId;
        vc.partnerCode = courseModel.partnerCode;
        [[HICCommonUtils viewController:self].navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark
-(void)studyVideoPlayCell:(HICStudyVideoPlayBaseCell *)cell clickItemBut:(UIButton * _Nullable)btn cellType:(StudyVideoPlayCellType)cellType itemModel:(nonnull id)data{
    
//    HICCourseModel *mdoel = [HICCourseModel modelWithDict:self.dataArr[data inte][@"courseInfo"]];
    
}
@end
