//
//  HICSearchDetailVC.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HICSearchDetailVC.h"

#import "SearchRecommendCell.h"
#import "SearchDeleartAlertView.h"
#import "SearchDefaultView.h"

#import "SearchClassStudyCell.h"
#import "SearchTeacherInfoCell.h"

#import "HICSearchDetailModel.h"
#import "HICLessonsVC.h"
#import "HICKnowledgeDetailVC.h"
#import "HICLectureDetailVC.h"
#import "HICKnowledgeScromAndHtmlVC.h"

#import "WGCollectionViewLayout.h"
#define HistoryDefaultKey @"SearchHistoryDefaultKey"

@interface HICSearchDetailVC ()<UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, WGCollectionViewLayoutDelegate>

@property (nonatomic, strong) NSArray *recommendArray;

@property (nonatomic, strong) NSArray *historyArray;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SearchDeleartAlertView *deleartAlertView;
@property (nonatomic, strong) UIView *historyBackView;

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIScrollView *scrollContentView;
@property (nonatomic, strong) NSMutableArray<UITableView *> *contentTableViews;
// 缺省页面
@property (nonatomic, strong) NSArray<SearchDefaultView *> *defaultViews;

@property (nonatomic, strong) NSMutableArray<UIButton *> *selectButs;
@property (nonatomic, strong) NSMutableArray<UIView *> *selectLines;
@property (nonatomic, assign) NSInteger isSelectIndex;

@property (nonatomic, strong) NSMutableArray *studyArray;
@property (nonatomic, strong) NSMutableArray *teachArray;

//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, copy) NSString *keyString;
@property (nonatomic, assign) NSInteger companyIndex;
@property (nonatomic, assign) NSInteger teacherIndex;
//@property (nonatomic, strong) SearchDefaultView *defaultView;
@property (nonatomic, strong) UIButton *cleanBut;

@end

@implementation HICSearchDetailVC

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;

    _recommendArray = [NSUserDefaults.standardUserDefaults objectForKey:HistoryDefaultKey];
    _selectButs = [NSMutableArray array];
    _selectLines = [NSMutableArray array];
    _isSelectIndex = 0;
    _historyArray = _recommendArray;
    _studyArray = [NSMutableArray array];
    _teachArray = [NSMutableArray array];
    _contentTableViews = [NSMutableArray array];
    _companyIndex = 0;
    _teacherIndex = 0;
    [self createNativeUI];
    [self createHeaderView];
    [self createSelectUI];
    [self createDefaultView];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.inputField becomeFirstResponder];
    if (_historyArray.count != 0 && self.teachArray.count == 0 && self.studyArray.count == 0) {
        self.historyBackView.hidden = NO;
    }
}

#pragma mark - 创建UI
-(void)createNativeUI {
    
    UIApplication *manager = UIApplication.sharedApplication;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    //    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    CGFloat statusHeight = manager.statusBarFrame.size.height;
    CGFloat nativeHeight = 57.f;
    UIView *nativeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, statusHeight + nativeHeight)];
    [self.view addSubview:nativeView];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(16, 13 + statusHeight, screenWidth - 62 - 16, 36)];
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    UIImageView *searchLeft = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 20, 20)];
    searchLeft.image = [UIImage  imageNamed:@"ICON-搜索框-搜索"];
    [searchView addSubview: searchLeft];
    searchView.layer.cornerRadius = 18;
    searchView.layer.masksToBounds = YES;
    UITextField *searchText = [[UITextField alloc] initWithFrame:CGRectMake(32+5, 3, searchView.bounds.size.width-32-5 - 30, 32)];
    searchText.font = FONT_REGULAR_15;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:NSLocalizableString(@"searchKeywords", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#858585"],NSFontAttributeName:searchText.font}];
    searchText.attributedPlaceholder = attrString;
    searchText.keyboardType = UIKeyboardTypeWebSearch;
    searchText.delegate = self;
    searchText.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:searchText];
    // 3. 清空按钮
    self.cleanBut = [[UIButton alloc] initWithFrame:CGRectMake(searchView.bounds.size.width - 30, 8, 20, 20)];
    [self.cleanBut setBackgroundImage:[UIImage imageNamed:@"bt-清空"] forState:UIControlStateNormal];
    [self.cleanBut addTarget:self action:@selector(clickCleanBut:) forControlEvents:UIControlEventTouchUpInside];
    self.cleanBut.hidden = YES; // 默认隐藏
    [searchView addSubview:self.cleanBut];
    
    UIButton *cancelBut = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-16-32, 20 + statusHeight, 32, 22.5)];
    [cancelBut setTitle:NSLocalizableString(@"cancel", nil) forState:UIControlStateNormal];
    [cancelBut setTitleColor:[UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1] forState:UIControlStateNormal];
    [cancelBut addTarget:self action:@selector(clickCancelBut:) forControlEvents:UIControlEventTouchUpInside];
    cancelBut.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    
    [nativeView addSubview:searchView];
    [nativeView addSubview:cancelBut];
    
    self.inputField = searchText;
}
// 创建头文件视图 -- 搜索历史
-(void)createHeaderView {
    UIApplication *manager = UIApplication.sharedApplication;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat statusHeight = manager.statusBarFrame.size.height;
    CGFloat nativeHeight = 57.f;
    CGFloat headerHeight = 168.f;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, statusHeight+nativeHeight, screenWidth, headerHeight)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, screenWidth - 16*2, 20)];
    titleLabel.text = NSLocalizableString(@"searchHistory", nil);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    titleLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    
    UIButton *deleatBut = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-17-20, 12, 20, 20)];
    [deleatBut setImage:[UIImage imageNamed:@"btn_删除历史记录"] forState:UIControlStateNormal];
    [view addSubview:deleatBut];
    [deleatBut addTarget:self action:@selector(clickDelateBut:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(16, 12+20+12, screenWidth - 16*2, headerHeight - 12 - 20 - 12 - 12)];
    WGCollectionViewLayout *layout = [[WGCollectionViewLayout alloc] init];
    layout.itemHVSpace = 8.f;
    layout.itemLRSpace = 5.5f;
    layout.delegate = self;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:contentView.bounds collectionViewLayout:layout];
    [contentView addSubview:collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:SearchRecommendCell.class forCellWithReuseIdentifier:@"RecommendCell"];
    collectionView.backgroundColor = UIColor.whiteColor;
    collectionView.scrollEnabled = NO;
    self.collectionView = collectionView;
    
    [view addSubview:titleLabel];
    [view addSubview:contentView];
    self.historyBackView = view;
    
    // 测试使用 -- 根据历史信息来进行展示和隐藏。
    [self.view addSubview:view];
    view.hidden = YES;
}

// 3. 创建选中UI
-(void)createSelectUI {
    
    UIApplication *manager = UIApplication.sharedApplication;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat statusHeight = manager.statusBarFrame.size.height;
    CGFloat nativeHeight = 57.f;
    CGFloat top = nativeHeight + statusHeight;
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, top, screenWidth, 44)];
    self.selectView = selectView;
    selectView.hidden = YES;
    CGFloat selectWidth = 40;
    
    NSArray *name = @[NSLocalizableString(@"knowledge", nil), NSLocalizableString(@"lecturer", nil)];
    for (NSInteger i = 0; i < 2; i++) {
        UIView *view = [self createSelectViewWith:CGRectMake(12 +(selectWidth+5)*i, 11.5, selectWidth, 32.5) titleName:name[i] tag:i];
        [selectView addSubview:view];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, selectView.frame.size.height-0.5, selectView.frame.size.width, .5)];
    lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [selectView addSubview:lineView];
    
    // 测试时用的 -- 只有搜索结果时才会显示
    [self.view addSubview:selectView];
    //    [self.view addSubview:self.tableView];
    
    CGFloat top1 = selectView.Y + selectView.height;
    CGFloat screenHeight = HIC_ScreenHeight;
    UIScrollView *scrollContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, top1, screenWidth, screenHeight-top1)];
    scrollContentView.hidden = YES;
    self.scrollContentView = scrollContentView;
    
    for (NSInteger i = 0; i < 2; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0+screenWidth*i, 0, screenWidth, screenHeight-top1-HIC_BottomHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = UIColor.whiteColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        [scrollContentView addSubview:tableView];
        tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [self.contentTableViews addObject:tableView];
        tableView.tableFooterView = [UIView new];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:SearchClassStudyCell.class forCellReuseIdentifier:@"ClassStudyCell"];
        [tableView registerClass:SearchTeacherInfoCell.class forCellReuseIdentifier:@"TeacherInfoCell"];
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (_isSelectIndex == 0) {
                _companyIndex ++;
            }else {
                _teacherIndex ++;
            }
            [self loadData];
        }];
        if (@available(iOS 15.0, *)) {
            tableView.sectionHeaderTopPadding = 0;
        }
        
    }
    
    scrollContentView.contentSize = CGSizeMake(screenWidth*2, 0);
    scrollContentView.showsHorizontalScrollIndicator = NO;
    scrollContentView.pagingEnabled = YES;
    scrollContentView.delegate = self;
    [self.view addSubview:scrollContentView];
    
    //    self.defaultView = [[SearchDefaultView alloc] initWithFrame:self.tableView.frame];
    //    [self.view addSubview:self.defaultView];
    //    self.defaultView.hidden = YES;
}
-(UIView *)createSelectViewWith:(CGRect)frame titleName:(NSString *)name tag:(NSInteger)tag{
    UIView *backView = [[UIView alloc] initWithFrame:frame];
    
    UIButton *selectBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 21)];
    [selectBut setTitle:name forState:UIControlStateNormal];
    [selectBut setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [selectBut setTitleColor:[UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1] forState:UIControlStateSelected];
    [selectBut setTitleColor:[UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:0.6] forState:UIControlStateSelected | UIControlStateHighlighted];
    selectBut.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [_selectButs addObject:selectBut];
    if (tag == 0) {
        selectBut.selected = YES;
    }
    [selectBut addTarget:self action:@selector(clickSelectBut:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *selectLineView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width-30)/2, 9 + 21, 30, 2.5)];
    selectLineView.backgroundColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
    selectLineView.hidden = YES;
    [_selectLines addObject:selectLineView];
    if (tag == 0) {
        selectLineView.hidden = NO;
    }
    
    [backView addSubview:selectBut];
    [backView addSubview:selectLineView];
    
    return backView;
}

// 6. 创建defaultView
-(void)createDefaultView {
    SearchDefaultView *view1 = [[SearchDefaultView alloc] initWithFrame:self.contentTableViews.firstObject.frame];
    SearchDefaultView *view2 = [[SearchDefaultView alloc] initWithFrame:self.contentTableViews.lastObject.frame];
    
    self.defaultViews = @[view1, view2];
}
//输入框清空事件
-(void)clickCleanBut:(UIButton *)btn {
    self.inputField.text = @"";
    // 判断当前phoneField是否为第一响应者
    if (!self.inputField.isFirstResponder) {
        btn.hidden = YES;
    }
}
#pragma mark - TextField的协议方法
// 将要开始编辑
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (textField == self.inputField) {

        if(self.inputField.text.length > 0){
            self.cleanBut.hidden = NO;
        }

    }

    return YES;

}
// 开始编辑的内容
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.inputField) {
           if(self.inputField.text.length > 0){
               self.cleanBut.hidden = NO;
           }
       }

    return YES;

}
// 将要结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField {

    // 将要结束编辑
    if(textField == self.inputField) {
        if (textField.text.length <= 0) {
            // 此时没有输入任何信息
            self.cleanBut.hidden = YES;
        }
    }

}
#pragma mark - CollectionDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _historyArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendCell" forIndexPath:indexPath];
    
    cell.model = _historyArray[indexPath.row];
    
    return cell;
}
#pragma mark - CollectionDelegateLayout
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    CGFloat width = [SearchRecommendCell getTitleLabelHeightWith:_recommendArray[indexPath.row][@"title"]] + 20;
//    CGSize size = CGSizeMake(width, 32);
//    return size;
//}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(WGCollectionViewLayout *)collectionViewLayout wideForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [SearchRecommendCell getTitleLabelHeightWith:_recommendArray[indexPath.row][@"title"]] + 20;
    if (width > collectionView.width) {
        width = collectionView.width - 20;
    }
    return width;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.historyArray[indexPath.row];
    self.inputField.text = [dic objectForKey:@"title"];
    self.keyString = self.inputField.text;
    self.historyBackView.hidden = YES;
    [self loadData];
}

#pragma mark - TableDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSelectIndex == 0) {
        return self.studyArray.count;
    }
    return self.teachArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isSelectIndex == 0) {
        SearchClassStudyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassStudyCell" forIndexPath:indexPath];
        cell.infoModel = self.studyArray[indexPath.row];
        return cell;
    }
    SearchTeacherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeacherInfoCell" forIndexPath:indexPath];
    cell.infoModel = self.teachArray[indexPath.row];
    return cell;
}

#pragma mark - TableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isSelectIndex == 0) {
        return 95.f;
    }
    
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isSelectIndex == 0) {
        SearchDetailInfoModel *model = self.studyArray[indexPath.row];
        if (model.kldType == 6) {//kecheng
            HICLessonsVC *vc = [HICLessonsVC new];
            vc.objectID = [NSNumber numberWithInteger:model.infoId];
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICFirstSearch];
            ///日志上报
            reportModel.mediaid = [NSNumber numberWithInteger:model.infoId];
            reportModel.knowtype = @-1;
            reportModel.mediatype = [NSNumber numberWithInteger:HICReportCourseType];
            reportModel.teacherid = @-1;
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstSearch]];
            [LogManager reportSerLogWithDict:report];
            [self.navigationController pushViewController:vc animated:YES];
        } else { 
            HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICFirstSearch];
            ///日志上报
            reportModel.mediaid = [NSNumber numberWithInteger:model.infoId];
            reportModel.knowtype = [NSNumber numberWithInteger:model.resourceType];
            reportModel.mediatype = [NSNumber numberWithInteger:HICReportKnowledgeType];
            reportModel.teacherid = @-1;
            NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
            [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstSearch]];
            [LogManager reportSerLogWithDict:report];
            HICKnowledgeDetailVC *vc = [HICKnowledgeDetailVC new];
            vc.objectId = [NSNumber numberWithInteger:model.infoId];
            vc.kType = model.resourceType;
            vc.partnerCode = model.partnerCode;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        SearchDetailInfoModel *model = self.teachArray[indexPath.row];
        DDLogDebug(@"-- 点击选中  教师---");
        HICLectureDetailVC *vc = [HICLectureDetailVC new];
        vc.lecturerId = model.infoId;
        HICStudyLogReportModel *reportModel = [[HICStudyLogReportModel alloc]initWithType:HICFirstSearch];
        ///日志上报
        reportModel.mediaid = @-1;
        reportModel.knowtype = @-1;
        reportModel.mediatype = @-1;
        reportModel.teacherid = [NSNumber numberWithInteger:model.infoId];
        NSMutableDictionary *report = [NSMutableDictionary dictionaryWithDictionary:[reportModel getParamDict]];
        [report setValuesForKeysWithDictionary:[LogManager getSerLogEventDictWithType:HICFirstSearch]];
        [LogManager reportSerLogWithDict:report];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - ScrollerViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self.scrollContentView) {
        return;
    }
    CGPoint point = scrollView.contentOffset;
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    
    NSInteger index = point.x/width;
    
    switch (index) {
        case 0:
            [self changeSelectBut:_selectButs.firstObject];
            break;
        case 1:
            [self changeSelectBut:_selectButs.lastObject];
            break;
        default:
            break;
    }
}

#pragma mark - TextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (![NSString isValidStr:textField.text]) {
        return YES;
    }
    // 键盘done完成
    [_studyArray removeAllObjects];
    [_teachArray removeAllObjects];
    for (UITableView *view in self.contentTableViews) {
        [view reloadData];
    }
    _companyIndex = 0;
    _teacherIndex = 0; // 重置状态
    self.keyString = textField.text;
    [self loadData]; // 网络数据请求
    self.selectView.hidden = YES;
    //    self.tableView.hidden = YES;
    self.scrollContentView.hidden = YES;
    self.historyBackView.hidden = YES;
    
    // 保存到历史数据中
    if (textField.text && ![textField.text isEqualToString:@""]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_historyArray];
        for (NSDictionary *dic in array) {
            if ([[dic objectForKey:@"title"] isEqualToString:textField.text]) {
                return YES;
            }
        }
        if (array.count > 0) {
            [array insertObject:@{@"title":textField.text} atIndex:0];
        }else {
            [array addObject:@{@"title":textField.text}];
        }
        [NSUserDefaults.standardUserDefaults setObject:[array copy] forKey:HistoryDefaultKey];
    }
    
    return YES;
}

#pragma mark - 网络数据请求
-(void)loadData {
    
    NSInteger page = 0;
    if (self.isSelectIndex == 1) {
        [self.defaultViews.lastObject removeFromSuperview];
        page = _teacherIndex;
    }else {
        [self.defaultViews.firstObject removeFromSuperview];
        page = _companyIndex;
    }
    [self.inputField resignFirstResponder];
    NSString *keyWord = self.keyString?self.keyString:@"";
    NSDictionary *dic = @{@"type":[NSNumber numberWithInteger:_isSelectIndex], @"pageNum":[NSNumber numberWithInteger:page], @"pageSize":@20, @"keyWords":keyWord};
    [HICAPI searchTeacherAndCourse:dic success:^(NSDictionary * _Nonnull responseObject) {
        self.selectView.hidden = NO;
        self.scrollContentView.hidden = NO;
        HICSearchDetailModel *mod = [HICSearchDetailModel createModelWithSourceData:responseObject];
        if (self.isSelectIndex == 1) {
            [self.teachArray addObjectsFromArray:mod.content];
            if (self.teachArray.count == 0) {
                [self.scrollContentView addSubview:self.defaultViews.lastObject];
            }
            if (mod.content.count == 0) {
                [self.contentTableViews[self.isSelectIndex].mj_footer endRefreshingWithNoMoreData];
                self.teacherIndex = self.teacherIndex <= 0?0: self.teacherIndex-1;
            }else {
                [self.contentTableViews[self.isSelectIndex].mj_footer endRefreshing];
            }
        }else {
            [self.studyArray addObjectsFromArray:mod.content];
            if (self.studyArray.count == 0) {
                [self.scrollContentView addSubview:self.defaultViews.firstObject];
            }
            if (mod.content.count == 0) {
                [self.contentTableViews[self.isSelectIndex].mj_footer endRefreshingWithNoMoreData];
                self.companyIndex = self.companyIndex <= 0?0: self.companyIndex-1;
            }else {
                [self.contentTableViews[self.isSelectIndex].mj_footer endRefreshing];
            }
        }
        [self.contentTableViews[self.isSelectIndex] reloadData];
    } failure:^(NSError * _Nonnull error) {
        if (self.isSelectIndex == 1) {
            _teacherIndex = _teacherIndex <= 0?0: _teacherIndex-1;
        }else {
            _companyIndex = _companyIndex <= 0?0: _companyIndex-1;
        }
        [self.contentTableViews[self.isSelectIndex].mj_footer endRefreshing];
    }];
}

#pragma mark - 页面事件处理
// 点击搜索的取消
-(void)clickCancelBut:(UIButton *)btn {
    DDLogDebug(@"取消");
    [self.navigationController popViewControllerAnimated:YES];
}
// 点击历史的删除
-(void)clickDelateBut:(UIButton *)btn {
    
    [self.view addSubview:self.deleartAlertView];
}

// 点击选择but --- 切换都会走下边两个方法
-(void)clickSelectBut:(UIButton *)but {
    NSInteger index = 0;
    for (NSInteger i = 0; i < _selectButs.count; i++) {
        if (but == _selectButs[i]) {
            [_selectButs[i] setSelected:YES];
            _selectLines[i].hidden = NO;
            index = i;
        }else {
            [_selectButs[i] setSelected:NO];
            _selectLines[i].hidden = YES;
        }
    }
    for (UITableView *tableview in self.contentTableViews) {
        CGPoint offset = tableview.contentOffset;
         (tableview.contentOffset.y > 0) ? offset.y-- : offset.y++;
        [tableview setContentOffset:offset animated:NO];
    }

    // 当前选中的是哪个but
    _isSelectIndex = index;
    if (_isSelectIndex == 0 && self.studyArray.count == 0) {
        [self loadData];
    }else if (_isSelectIndex == 1 && self.teachArray.count == 0) {
        [self loadData];
    }
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    self.scrollContentView.contentOffset = CGPointMake(width*index, 0);
    _isSelectIndex = index;
}

// 改变选中的but -- 滑动切换会走
-(void)changeSelectBut:(UIButton *)but {
    for (NSInteger i = 0; i < _selectButs.count; i++) {
        if (but == _selectButs[i]) {
            [_selectButs[i] setSelected:YES];
            _selectLines[i].hidden = NO;
            _isSelectIndex = i;
        }else {
            [_selectButs[i] setSelected:NO];
            _selectLines[i].hidden = YES;
        }
    }
    
    if (_isSelectIndex == 0 && self.studyArray.count == 0) {
        [self loadData];
    }else if (_isSelectIndex == 1 && self.teachArray.count == 0) {
        [self loadData];
    }
}

#pragma mark - 懒加载
//-(UITableView *)tableView {
//    if (!_tableView) {
//        UIApplication *manager = UIApplication.sharedApplication;
//        CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
//        CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
//        CGFloat statusHeight = manager.statusBarFrame.size.height;
//        CGFloat nativeHeight = 57.f + 44.f;
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusHeight+nativeHeight, screenWidth, screenHeight-statusHeight-nativeHeight) style:UITableViewStylePlain];
//        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
////        _tableView.backgroundColor = UIColor.redColor;
//
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//        _tableView.tableFooterView = [UIView new];
//        _tableView.hidden = YES;
//    }
//    return _tableView;
//}

-(SearchDeleartAlertView *)deleartAlertView {
    if (!_deleartAlertView) {
        _deleartAlertView = [[SearchDeleartAlertView alloc] initWithFrame:self.view.bounds];
        __weak typeof(self) weakSelf = self;
        _deleartAlertView.clickSureBlock = ^{
            [NSUserDefaults.standardUserDefaults setObject:@[] forKey:HistoryDefaultKey];
            weakSelf.historyBackView.hidden = YES;
            weakSelf.historyArray = @[];
        };
    }
    return _deleartAlertView;
}

@end
