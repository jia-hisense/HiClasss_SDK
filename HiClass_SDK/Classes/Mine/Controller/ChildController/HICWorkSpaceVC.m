//
//  HICWorkSpaceVC.m
//  HiClass
//
//  Created by 铁柱， on 2020/9/9.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICWorkSpaceVC.h"
#import "HICMyInfoCell.h"
#import "HICPushCustoWebVC.h"
#import "HICMyspaceModel.h"
#import "HICMyWorkSpaceCell.h"
static NSString *workSpaceCell = @"workSpaceCell";
@interface HICWorkSpaceVC ()<HICCustomNaviViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong)NSMutableArray *dataArr;
@property (nonatomic ,strong)NSArray *checkArr;
@property (nonatomic, strong)HICCustomNaviView *navi;
@property (nonatomic ,strong)UICollectionView *collectionView;
@property (nonatomic ,strong)UIImageView *topView;
@property (nonatomic ,strong)NSNumber *coursesCount;
@property (nonatomic ,strong)NSNumber *questionsCount;
@property (nonatomic ,strong)NSNumber *papersCount;
@property (nonatomic ,strong)NSNumber *registersCount;
@end

@implementation HICWorkSpaceVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self createNavi];
    [self configView];
}
- (void)requestData {
    [HICAPI auditedTasksNum:^(NSDictionary * _Nonnull responseObject) {
        NSDictionary *data = [responseObject valueForKey:@"data"];
        if ([HICCommonUtils isValidObject:data]) {
            /* "coursesCount": "integer,课程/知识数量",
             "questionsCount": "integer,试题数据 ",
             "papersCount": "integer,试卷数量",
             "registersCount": "integer,报名数量"*/
            if ([data valueForKey:@"coursesCount"]) {
                self.coursesCount = [data valueForKey:@"coursesCount"];
            }
            if ([data valueForKey:@"questionsCount"]) {
                self.questionsCount = [data valueForKey:@"questionsCount"];
            }
            if ([data valueForKey:@"papersCount"]) {
                self.papersCount = [data valueForKey:@"papersCount"];
            }
            if ([data valueForKey:@"registersCount"]) {
                self.registersCount = [data valueForKey:@"registersCount"];
            }
            [self initData];
            
        }else{
            [self initData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self initData];
    }];
}
- (void)initData{
    self.dataArr = [NSMutableArray array];
    
    if ([RoleManager isSuccessMenu]) {
          if ([RoleManager menuCodes].count > 0) {
              if ([[RoleManager menuCodes] containsObject:@"Check"]) {
                  HICMyspaceModel *model = [HICMyspaceModel new];
                  model.name = NSLocalizableString(@"speakingReview", nil);
                  model.type = HICGradeAudit;
                  [self.dataArr addObject:model];
              }
              if ([[RoleManager menuCodes] containsObject:@"PaperAudit"]){
                  HICMyspaceModel *model = [HICMyspaceModel new];
                  model.name = NSLocalizableString(@"examinationPaperReview", nil);
                  model.type = HICExamAudit;
                  if (self.papersCount) {
                      model.num = self.papersCount;
                  }
                  [self.dataArr addObject:model];
              }
              if ([[RoleManager menuCodes] containsObject:@"QuestionAudit"]){
                  HICMyspaceModel *model = [HICMyspaceModel new];
                  model.name = NSLocalizableString(@"tryReview", nil);
                  model.type = HICQuestionAudit;
                  if (self.questionsCount) {
                      model.num = self.questionsCount;
                  }
                  [self.dataArr addObject:model];
              }
              if ([[RoleManager menuCodes] containsObject:@"KnowledgeAudit"]){
                  HICMyspaceModel *model = [HICMyspaceModel new];
                  model.name = NSLocalizableString(@"curriculumReview", nil);
                  if (self.coursesCount) {
                      model.num = self.coursesCount;
                  }
                  model.type = HICKnowledgeAudit;
                  [self.dataArr addObject:model];
              }
              if ([[RoleManager menuCodes] containsObject:@"RegistrationAudit"]){
                  HICMyspaceModel *model = [HICMyspaceModel new];
                  model.name = NSLocalizableString(@"signUpReview", nil);
                  model.type = HICMyRegisterAudit;
                  if (self.registersCount) {
                      model.num = self.registersCount;
                  }
                  [self.dataArr addObject:model];
              }
          }
    }
    [self.collectionView reloadData];
}
- (void)createNavi {
    self.navi = [[HICCustomNaviView alloc] initWithTitle:NSLocalizableString(@"workbench", nil) rightBtnName:nil showBtnLine:NO];
    _navi.delegate = self;
    [self.view addSubview:_navi];
}
- (void)configView{
    [self.view addSubview:self.topView];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[HICMyWorkSpaceCell class] forCellWithReuseIdentifier:workSpaceCell];
}
#pragma mark - - - HICCustomNaviViewDelegate  - - -
- (void)leftBtnClicked {
    if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark---collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HICMyWorkSpaceCell *cell = (HICMyWorkSpaceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:workSpaceCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[HICMyWorkSpaceCell alloc]init];
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HICMyspaceModel *model = self.dataArr[indexPath.row];
     HICPushCustoWebVC *vc = [HICPushCustoWebVC new];
     vc.isCompanyUrl = YES;
    if (model.type == HICGradeAudit) {
        vc.urlStr = [NSString stringWithFormat:@"%@/mweb/index.html#/post-route", APP_Web_DOMAIN];
        DDLogDebug(@"实操批阅跳转链接：%@", vc.urlStr);

    }else {
        vc.urlStr = [NSString stringWithFormat:@"%@/mweb/index.html#/audit-list?activeIndex=%ld", APP_Web_DOMAIN, (long)model.type];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ---lazyload
-(NSArray *)checkArr{
    if (!_checkArr) {
        _checkArr = @[NSLocalizableString(@"fieldPerformance", nil)];
    }
    return _checkArr;
}
-(UIImageView *)topView{
    if (!_topView) {
        CGFloat ratio = HIC_ScreenWidth / 375;
        _topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, 210 * ratio)];
        _topView.image = [UIImage imageNamed:@"bg_gongzuotai"];
    }
    return _topView;
}
-(UICollectionView *)collectionView{
     if (!_collectionView) {
           UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
           flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
           // 每一列cell之间的间距
           flowLayout.minimumInteritemSpacing = 8;
           flowLayout.sectionInset = UIEdgeInsetsMake(8, 0, 0, 8);
           flowLayout.itemSize = CGSizeMake((HIC_ScreenWidth-16 - 24 - 8)/3 , 156);
         CGFloat ratio = HIC_ScreenWidth / 375;
         _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(12, HIC_NavBarAndStatusBarHeight + 190 *ratio - 8,  HIC_ScreenWidth - 16,HIC_ScreenHeight -HIC_NavBarAndStatusBarHeight - HIC_BottomHeight - 190*ratio + 8) collectionViewLayout:flowLayout];
           _collectionView.showsHorizontalScrollIndicator = NO;
         _collectionView.backgroundColor = UIColor.clearColor;
         _collectionView.delegate = self;
         _collectionView.dataSource = self;
       }
       return _collectionView;
}
@end
