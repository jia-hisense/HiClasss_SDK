//
//  CompanyKnowledgeMenuView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "CompanyKnowledgeMenuView.h"

#import "CompanyKnowledgeMenuSoreView.h"
#import "CompanyKnowledgeMenuTypeView.h"
#import "CompanyKnowledgeMenuTimeView.h"

#import "HICCompanyMenuModel.h"

@interface CompanyKnowledgeMenuView ()

/// 菜单的名称数组
@property (nonatomic, strong) NSArray *titles;
/// 菜单栏Item数组
@property (nonatomic, strong) NSMutableArray *menuItemButs;

/// 内容背景图
@property (nonatomic, strong) UIView *contentBackView;

/// 课程分类的View
@property (nonatomic, strong) CompanyKnowledgeMenuSoreView *classSortView;
@property (nonatomic, assign) NSInteger selectSortIndex;
@property (nonatomic, copy) NSString *selectSortCode;

/// 类型筛选的View
@property (nonatomic, strong) CompanyKnowledgeMenuTypeView *typeSelectView;
@property (nonatomic, assign) NSInteger selectTypeIndex;

/// 时间的View
@property (nonatomic, strong) CompanyKnowledgeMenuTimeView *starTimeView;
@property (nonatomic, assign) NSInteger selectTimeIndex;

@end

@implementation CompanyKnowledgeMenuView

-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        _titles = @[NSLocalizableString(@"courseClassification", nil), NSLocalizableString(@"TypeSelection", nil), NSLocalizableString(@"byReleaseTime", nil)];
        _menuItemButs = [NSMutableArray array];
        [self createView];
    }
    return self;
}

-(void)createView {

    CGFloat screenWidth = self.frame.size.width;

    CGFloat menuHeight = 40;
    CGFloat menuItemWidth = screenWidth/3.0;
    // 1. 菜单栏
    UIView *menuBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, menuHeight)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, menuHeight-0.5, screenWidth, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [menuBackView addSubview:lineView];

    // 循环创建item
    for (NSInteger i = 0; i < _titles.count; i++) {
        UIButton *itemBut = [[UIButton alloc] initWithFrame:CGRectMake(i*menuItemWidth, 0, menuItemWidth, menuHeight)];
        [itemBut setTitle:_titles[i] forState:UIControlStateNormal];
        [itemBut setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        [itemBut setTitleColor:[UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1] forState:UIControlStateSelected];
        [itemBut setTitleColor:[UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1] forState:UIControlStateSelected | UIControlStateHighlighted];
        [itemBut setImage:[UIImage imageNamed:@"筛选箭头-灰"] forState:UIControlStateNormal];
        [itemBut setImage:[UIImage imageNamed:@"筛选箭头-蓝绿"] forState:UIControlStateSelected];
        [itemBut setImage:[UIImage imageNamed:@"筛选箭头-蓝绿"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [itemBut setTitleColor:[UIColor colorWithHexString:@"#e6e6e6"] forState:UIControlStateDisabled];
        itemBut.tag = i;
        [itemBut addTarget:self action:@selector(clickMenuBut:) forControlEvents:UIControlEventTouchUpInside];
        // 设置标题
        UIFont *titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        itemBut.titleLabel.font = titleFont;
        itemBut.imageView.bounds = CGRectMake(0, 0, 7, 5);
        // 设置image
        [itemBut setImageEdgeInsets:UIEdgeInsetsMake(menuHeight/2-2.5, menuItemWidth - 20, menuHeight/2-2.5, 10)];
        [menuBackView addSubview:itemBut];
        [itemBut setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 30)];
        [_menuItemButs addObject:itemBut];
    }

    [self addSubview:menuBackView];
}

-(void)addContentViewWithParentView:(UIView *)view {

    // 2. 内容部分填充
    CGFloat screenWidth = self.frame.size.width;
    CGFloat scrrenHeight = UIScreen.mainScreen.bounds.size.height;
    CGFloat menuHeight = self.frame.size.height;
    UIView *contentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, menuHeight+self.frame.origin.y, screenWidth, scrrenHeight-menuHeight-self.frame.origin.y)];
    contentBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    contentBackView.hidden = YES;
    self.contentBackView = contentBackView;

    UIButton *backBut = [[UIButton alloc] initWithFrame:self.contentBackView.bounds];
    [contentBackView addSubview:backBut];
    [backBut addTarget:self action:@selector(clickContenBackBut:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:self.contentBackView];
}

#pragma mark - 页面事件
-(void)clickMenuBut:(UIButton *)but {
    NSInteger tag = but.tag;
    if (tag == 1 && _isNotEnableTypeClick == YES) {
        // 此时需要判断一下是否可以点击
        return;
    }
    BOOL select = but.isSelected;
    but.selected = !select;

    for (UIButton *btn in _menuItemButs) {
        if (btn != but) {
            btn.selected = NO;
        }
    }

    self.contentBackView.hidden = select;
    self.contentBackView.userInteractionEnabled = !select;

    for (UIView *view in self.contentBackView.subviews) {
        if (![view isKindOfClass:UIButton.class]) {
            [view removeFromSuperview];
        }
    }

    if (!select) {
        switch (tag) {
            case 0:
                [self.contentBackView addSubview:self.classSortView];
                break;
            case 1:
                [self.contentBackView addSubview:self.typeSelectView];
                break;
            case 2:
                [self.contentBackView addSubview:self.starTimeView];
                break;
            default:
                break;
        }
    }

    if (select) {
        NSInteger soreId = -1;
        if (self.dataSource.count != 0 && _selectSortIndex > 0) {
            HICCompanyMenuModel *model = self.dataSource[_selectSortIndex-1];
            soreId = model.catalogId.integerValue;
        }
        if ([self.delegate respondsToSelector:@selector(menuView:changeMenuItemWith:andSoreStrId:selectType:selectTime:)]) {
            [self.delegate menuView:self changeMenuItemWith:soreId andSoreStrId:self.selectSortCode selectType:_selectTypeIndex-1 selectTime:_selectTimeIndex];
        }
    }

}

-(void)clickContenBackBut:(UIButton *)btn {

    // 此时有一个Item是显示的需要隐藏
    for (UIButton *btn in self.menuItemButs) {
        if (btn.selected) {
            btn.selected = NO;
        }
    }
    self.contentBackView.hidden = YES;
    self.contentBackView.userInteractionEnabled = NO;

    for (UIView *view in self.contentBackView.subviews) {
        if (![view isKindOfClass:UIButton.class]) {
            [view removeFromSuperview];
        }
    }

}

-(CGFloat)getStringWidthWithStr:(NSString *)str strFont:(UIFont *)font {

    CGSize textSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return textSize.width;
}

#pragma mark - 页面赋值
-(void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;

    self.classSortView.dataSource = dataSource;
}

-(void)setIsNotEnableTypeClick:(BOOL)isNotEnableTypeClick {
    _isNotEnableTypeClick = isNotEnableTypeClick;
    if (isNotEnableTypeClick && self.menuItemButs.count >= 1) {
        UIButton *but = [self.menuItemButs objectAtIndex:1];
        but.enabled = NO;
    }
}

-(void)setIsHiddenSoreView:(BOOL)isHiddenSoreView {
    _isHiddenSoreView = isHiddenSoreView;

    // 隐藏分类页面
    if (isHiddenSoreView) {
        UIButton *but = self.menuItemButs.firstObject;
        but.hidden = YES;
        but.frame = CGRectMake(0, 0, 0, 0);
        CGFloat width = HIC_ScreenWidth/2.0;
        CGFloat menuHeight = 40;
        for (NSInteger i = 1; i < self.menuItemButs.count; i++) {
            UIButton *btn = [self.menuItemButs objectAtIndex:i];
            btn.width = width;
            btn.X = width*(i-1);
            // 设置image
            UIFont *titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            CGFloat strWidth = [self getStringWidthWithStr:_titles[i] strFont:titleFont];
            CGFloat left = width/2.0 + strWidth/2.0;
            CGFloat right = width - left + 7;
            [btn setImageEdgeInsets:UIEdgeInsetsMake(menuHeight/2-2.5, left, menuHeight/2-2.5, right)];
            CGFloat titleLeft = width/2.0 - strWidth/2.0-10;
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, titleLeft, 0, width-titleLeft-strWidth)];
        }
    }
}

#pragma mark - 懒加载
-(CompanyKnowledgeMenuSoreView *)classSortView {
    if (!_classSortView) {
        CGFloat viewWidth = self.contentBackView.bounds.size.width;
        CGFloat viewHeight = self.contentBackView.bounds.size.height;
        _classSortView = [[CompanyKnowledgeMenuSoreView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight*6/7)];
        _classSortView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
        _classSortView.changeIndexBlock = ^(NSInteger index, NSString * _Nonnull changeName) {
            weakSelf.selectSortIndex = index;
            weakSelf.selectSortCode = changeName;
            [weakSelf clickMenuBut:weakSelf.menuItemButs.firstObject];
        };
    }
    return _classSortView;
}

-(CompanyKnowledgeMenuTypeView *)typeSelectView {
    if (!_typeSelectView) {
        CGFloat viewWidth = self.contentBackView.bounds.size.width;
        CGFloat viewHeight = self.contentBackView.bounds.size.height;
        _typeSelectView = [[CompanyKnowledgeMenuTypeView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight*3/5)];
        _typeSelectView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
        _typeSelectView.changeIndexBlock = ^(NSInteger index, NSString * _Nonnull changeName) {
            weakSelf.selectTypeIndex = index;
            [weakSelf clickMenuBut:weakSelf.menuItemButs[1]];
        };
    }
    return _typeSelectView;
}

-(CompanyKnowledgeMenuTimeView *)starTimeView {
    if (!_starTimeView) {
        CGFloat viewWidth = self.contentBackView.bounds.size.width;
        CGFloat viewHeight = self.contentBackView.bounds.size.height;
        _starTimeView = [[CompanyKnowledgeMenuTimeView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight*2/5)];
        _starTimeView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf = self;
        _starTimeView.changeIndexBlock = ^(NSInteger index, NSString * _Nonnull changeName) {
            UIButton *but = weakSelf.menuItemButs.lastObject;
            [but setTitle:changeName forState:UIControlStateNormal];
            weakSelf.selectTimeIndex = index;
            [weakSelf clickMenuBut:weakSelf.menuItemButs.lastObject];
        };
    }
    return _starTimeView;
}

@end
