//
//  HICHomeworkListView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/3/11.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICHomeworkListView.h"
#import "HICHomeworkListCell.h"
#import "HomeTaskCenterDefaultView.h"

static NSString *homeworkListCellIdenfer = @"homeworkListCell";

@interface HICHomeworkListView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableDictionary *couseDic;
@property (nonatomic, strong) HomeTaskCenterDefaultView *defaultView;
@end

@implementation HICHomeworkListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
//        [self requestData];
        [self creatUI];
    }
    return self;
}

- (void)initData {
    self.items = [[NSMutableArray alloc] init];
    self.couseDic = [[NSMutableDictionary alloc] init];
}

- (void)requestData {
    NSNumber *trainId = _trainId?_trainId:@0;
    NSNumber *workId = _workId?_workId:@0;
    NSDictionary *dic = @{@"workId":workId, @"trainId":trainId, @"customerId":USER_CID};
    [HICAPI homeWorkDetail:dic success:^(NSDictionary * _Nonnull responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        HICHomeworkModel *workInfo = [HICHomeworkModel mj_objectWithKeyValues:[data objectForKey:@"workInfo"]];
        if (workInfo) {
            [self.items addObject:workInfo];
        }else {
            [self.items addObject:HICHomeworkModel.new];
        }
        
        NSMutableArray *array = [HICHomeworkModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"jobRetList"]];
        if (array) {
            for (HICHomeworkModel *model in array) {
                model.endTime = workInfo.endTime;
            }
            [self.items addObjectsFromArray:[array copy]];
        }
        DDLogDebug(@"====%@", responseObject);
        [self.tableView reloadData];
        [self checkHomeworkData];
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"--- 请求失败 %@", error);
        [self checkHomeworkData];
    }];
}

- (void)creatUI {
    [self createTableView];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    [self addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
}

-(void)checkHomeworkData {
    if (self.items.count == 0) {
        // 证明此时没有数据
        self.defaultView.hidden = NO;
    }else if (self.items.count == 1){
        // 此时只有标题
        HICHomeworkModel *hModel = self.items.firstObject;
        if (![NSString isValidStr:hModel.workName] && ![NSString isValidStr:hModel.coverPic]) {
            // 此时同样为空
            self.defaultView.hidden = NO;
        }
    }
}

#pragma mark tableview dataSorce协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICHomeworkListCell *homeworkListCell = (HICHomeworkListCell *)[tableView dequeueReusableCellWithIdentifier:homeworkListCellIdenfer];
    if (homeworkListCell == nil) {
        homeworkListCell = [[HICHomeworkListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeworkListCellIdenfer];
        [homeworkListCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else {

    }

    HICHomeworkModel *hModel = _items[indexPath.row];
    [homeworkListCell setData:hModel index:indexPath.row];

    return homeworkListCell;

}

#pragma mark tableview delegate协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HICHomeworkModel *hModel = _items[indexPath.row];
    if (indexPath.row == 0) {
        if (![NSString isValidStr:hModel.workName] && ![NSString isValidStr:hModel.coverPic]) {
            return 0;
        }
        return HOMEWORK_FIRST_CELL_HEIGHT;
    }
    DDLogDebug(@"asdasdasd2: %f", 12 + 17 + 10 + [self getContentHeight:hModel.name] + 5 + 20 + 16);
    return 12 + 17 + 10 + [self getContentHeight:hModel.name] + 5 + 20 + 16;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(listView:didCell:model:indexPath:)]) {
        HICHomeworkModel *model = [self.items objectAtIndex:indexPath.row];
        [self.delegate listView:self didCell:nil model:model indexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (CGFloat)getContentHeight:(NSString *)str {
    UILabel *label = [[UILabel alloc] init];
    label.text = str;
    label.font = FONT_REGULAR_16;
    label.numberOfLines = 2;
    CGFloat labelHeight = [HICCommonUtils sizeOfString:str stringWidthBounding:HIC_ScreenWidth - 16 * 2 font:16 stringOnBtn:NO fontIsRegular:YES].height;
    label.frame = CGRectMake(0, 0, HIC_ScreenWidth - 16 * 2, labelHeight);
    [label sizeToFit];
    return label.frame.size.height;
}

#pragma mark - 懒加载
-(HomeTaskCenterDefaultView *)defaultView {
    if (!_defaultView) {
        _defaultView = [[HomeTaskCenterDefaultView alloc] initWithFrame:self.bounds];
        _defaultView.hidden = YES;
        _defaultView.titleStr = NSLocalizableString(@"noHomeworkData", nil);
        [self addSubview:_defaultView];
    }
    return _defaultView;
}

@end
