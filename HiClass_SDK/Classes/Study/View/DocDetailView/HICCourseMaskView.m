//
//  HICCourseMaskView.m
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCourseMaskView.h"
#import "HICExercisesListItemCell.h"
#define CDVTopMargin  (72 - 20 + HIC_StatusBar_Height)
#define CDVTitleSectionHeight  72
#define CDVBtmViewHeight  120
static NSString *ExercisesCell = @"ExercisesCell";
@interface HICCourseMaskView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) NSMutableArray *extraViewArr;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end
@implementation HICCourseMaskView
-(instancetype)initWithTitle:(NSString *)titleName andDataArr:(NSMutableArray *)arr{
    if (self = [super init]) {
        self.dataArr = arr;
        self.titleName = titleName;
        [self initData];
        [self createUI];
    }
    return self;
}
- (void)initData {
    [self.tableView registerClass:HICExercisesListItemCell.class forCellReuseIdentifier:ExercisesCell];
}
- (void)createUI{
    self.frame = CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight);
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
    
    _container = [[UIView alloc] init];
    [self addSubview: _container];
    _container.frame = CGRectMake(0, HIC_ScreenHeight, self.frame.size.width, self.frame.size.height - CDVTopMargin);
    [UIView animateWithDuration:0.3 animations:^{
        self->_container.frame = CGRectMake(0, CDVTopMargin, self.frame.size.width, self.frame.size.height - CDVTopMargin);
    }];
    [HICCommonUtils setRoundingCornersWithView:_container TopLeft:YES TopRight:YES bottomLeft:NO bottomRight:NO cornerRadius:15];
    _container.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [_container addSubview:titleLabel];
    titleLabel.frame = CGRectMake(16, 15, 68, 24);
    titleLabel.font = FONT_MEDIUM_17;
    titleLabel.text = self.titleName;
    titleLabel.textColor = TEXT_COLOR_DARK;
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [_container addSubview: cancelBtn];
    cancelBtn.tag = 10000;
    [cancelBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"关闭弹窗"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(_container.frame.size.width - 20 - 16, 15, 20, 20);
    
    UIView *dividedLine = [[UIView alloc] initWithFrame:CGRectMake(0, CDVTitleSectionHeight - 0.5, _container.frame.size.width, 0.5)];
    [_container addSubview: dividedLine];
    dividedLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
    [self initTableView];
}
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CDVTitleSectionHeight, _container.frame.size.width, _container.frame.size.height - CDVTitleSectionHeight - CDVBtmViewHeight - HIC_BottomHeight + 50) style:UITableViewStylePlain];
    [_container addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
}
- (void)btnClicked {
    [UIView animateWithDuration:0.3 animations:^{
               self->_container.frame = CGRectMake(0, HIC_ScreenHeight, self.frame.size.width, self.frame.size.height - 72);
           }];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self removeFromSuperview];
           });
}
#pragma mark -uitableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ExercisesCell forIndexPath:indexPath];
    return cell;
}
@end
