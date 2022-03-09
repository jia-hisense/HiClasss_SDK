//
//  HICMyNoteView.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyNoteView.h"
#import "HICMyNoteCell.h"
#import "HICMyNoteModel.h"
#import "HICChildMineDetailVC.h"
#import "HICCourseModel.h"
static NSString *noteCell =  @"NoteCell";
@interface HICMyNoteView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) HICNetModel *netModel;
@property (nonatomic, strong) UIImageView *blackView;
@property (nonatomic ,strong)UILabel *blackLabel;
@end
@implementation HICMyNoteView
-(UIImageView *)blackView{
    if (!_blackView) {
        _blackView = [[UIImageView alloc]initWithFrame:CGRectMake(HIC_ScreenWidth / 2 - 60, 101.5, 120, 120)];
        _blackView.image = [UIImage imageNamed:@"暂无笔记"];
    }
    return _blackView;
}
- (UILabel *)blackLabel{
    if (!_blackLabel) {
        _blackLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 221.5 + 8, HIC_ScreenWidth, 20)];
        _blackLabel.text = NSLocalizableString(@"noNote", nil);
        _blackLabel.textColor = TEXT_COLOR_LIGHTS;
        _blackLabel.font = FONT_REGULAR_15;
        _blackLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _blackLabel;
}
- (NSMutableArray *)arrData{
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
        [self configTableView];
    }
    return self;
}
- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    if(_dataArr.count == 0){
        [self addSubview:self.blackView];
        [self addSubview:self.blackLabel];
    }
    self.arrData = [NSMutableArray arrayWithArray:dataArr];
    [self reloadData];
}

- (void)createUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
    self.frame = CGRectMake(0, 0 , HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight);
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.separatorColor = [UIColor clearColor];
    if (@available(iOS 15.0, *)) {
        self.sectionHeaderTopPadding = 0;
    }
}
- (void)configTableView {
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[HICMyNoteCell class] forCellReuseIdentifier:noteCell];
}
#pragma mark -uitableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.arrData.count - 1) {
        return 100;
    }else{
        return 93;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HICMyNoteCell *cell = (HICMyNoteCell *)[tableView dequeueReusableCellWithIdentifier:noteCell];
    if (!cell) {
        cell = [[HICMyNoteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noteCell];
    }
    cell.noteModel = [HICMyNoteModel mj_objectWithKeyValues:self.arrData[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSMutableDictionary *postModel = [NSMutableDictionary new];
//    HICMyNoteModel *noteModel = [HICMyNoteModel mj_objectWithKeyValues:self.arrData[indexPath.row]];
//    [postModel setValue:@(1) forKey:@"terminalType"];
//    [postModel setValue:noteModel.noteId forKey:@"noteIds"];
//    [postModel setValue:@0 forKey:@"majorFlag"];
//    [postModel setValue:@2 forKey:@"action"];
//    NSString *url = [NSString stringWithFormat:@"%@?noteIds=%@&majorFlag=0&action=%@", MY_NOTE_MANAGE, [noteModel.noteId toString], @(2)];
//    self.netModel = [[HICNetModel alloc]initWithURL:url  params:postModel];
//    self.netModel.contentType = HTTPContentTypeJsonType;
//    self.netModel.method = HTTPMethodPOST;
//    self.netModel.urlType = DefaultExamURLType;
//    [RoleManager showWindowLoadingView];
//    [NetManager sentHTTPRequest:self.netModel success:^(NSDictionary * _Nonnull responseObject) {
//        [RoleManager hiddenWindowLoadingView];
//        if (responseObject) {
//            if ([[responseObject[@"resultCode"] stringValue] isEqualToString:@"0"]) {
//                [self.arrData removeObjectAtIndex:indexPath.row];
//                [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
//                [HICToast showWithText:@"删除成功"];
//                [self reloadData];
//            }else{
//                [HICToast showWithText:@"删除失败"];
//            }
//
//        }
//    } failure:^(NSError * _Nonnull error) {
//        [RoleManager hiddenWindowLoadingView];
//        [HICToast showWithText:@"删除失败"];
//    }];
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HICMyNoteModel *noteModel = [HICMyNoteModel mj_objectWithKeyValues:self.arrData[indexPath.row]];
    HICCourseModel *course = [HICCourseModel mj_objectWithKeyValues:noteModel.courseKLDInfo];
    HICChildMineDetailVC *vc = [HICChildMineDetailVC new];
    vc.objectId = course.courseKLDId;
    vc.objectType = course.courseKLDType;
    vc.model = course;
    [[HICCommonUtils viewController:self].navigationController pushViewController:vc animated:YES];
}
@end
