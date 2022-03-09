//
//  HICMixTrainArrangeCell.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICMixTrainArrangeCell.h"
#import "HICMixAllView.h"
@interface HICMixTrainArrangeCell ()<HICMixTrainBaseViewDelegate>
@property (nonatomic, strong)NSMutableArray *trainList;
@property (nonatomic, strong)UILabel *chapterNameLabel;
@property (nonatomic, strong)UIButton *extensionbutton;
@property (nonatomic, strong)UIView *cellContent;
@property (nonatomic, strong)UIView *devideLine;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *bottomLabel;
@property (nonatomic ,strong)UILabel *rightLabel;
@property (nonatomic ,strong)UIProgressView *progressView;
@property (nonatomic ,strong)UILabel *progressLabel;
@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic ,strong)NSNumber *sectionId;
@property (nonatomic ,strong)NSNumber *curTime;
@property (nonatomic ,assign)NSInteger isEnd;
@property (nonatomic ,strong)OfflineTrainingListModel *stageModel;
@property (nonatomic ,assign)CGFloat startHeight;
@property (nonatomic ,strong)UIView *tapView;
@property (nonatomic ,strong)HICMixAllView *allView;
@property (nonatomic ,strong)NSMutableArray *heightArr;
@end
@implementation HICMixTrainArrangeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    [super awakeFromNib];
     if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self createUI];
        [self updateConstraintsIfNeeded];
       }
    return self;
}

- (void)createUI{
    self.chapterNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 18.5, HIC_ScreenWidth - 32 - 20, 24)];
    self.chapterNameLabel.textColor = TEXT_COLOR_DARK;
    self.chapterNameLabel.font = FONT_REGULAR_17;
    self.chapterNameLabel.numberOfLines = 1;
    self.chapterNameLabel.lineBreakMode = NSLineBreakByTruncatingTail |NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.chapterNameLabel];
    UIImage * btnImageup = [UIImage imageNamed:@"箭头-章节收起"];
    UIImage * btnImagedown = [UIImage imageNamed:@"箭头-章节展开"];
    self.extensionbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.extensionbutton setImage:btnImagedown forState:UIControlStateNormal];
    [self.extensionbutton setImage:btnImageup forState:UIControlStateSelected];
    [self.extensionbutton addTarget:self action:@selector(btnClickExtension) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.extensionbutton];
    [self.extensionbutton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(23);
        make.right.equalTo(self.contentView).offset(-20);
        make.width.offset(22);
        make.height.offset(22);
    }];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, HIC_ScreenWidth, 0.5)];
    line.backgroundColor = BACKGROUNG_COLOR;
    [self.contentView addSubview:line];
    self.maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, 60)];
    self.maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickExtension)];
    [self.maskView addGestureRecognizer:tap];
    [self.contentView addSubview:self.maskView];
    self.cellContent = [[UIView alloc]init];
    [self.contentView addSubview:self.cellContent];
    self.allView = [[HICMixAllView alloc]init];
    self.allView.delegate = self;
    
}
- (void)setModel:(HICMixTrainArrangeModel *)model {
    if (_model == model) {
        return;
    }
    _model = model;
    self.chapterNameLabel.text = model.stageName;
    self.sectionId = model.stageId;
    self.curTime = model.curTime;
    self.isEnd = model.trainTerminated;
//    if (self.contentView.subviews.count > 0) {
//        [self.cellContent.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    }
    self.trainList = [HICMixTrainArrangeListModel mj_objectArrayWithKeyValuesArray:model.stageActionList];
    self.cellHeight = 12;
    self.startHeight = 12;
     
    
}
- (void)setCellModel:(OfflineMixTrainCellModel *)cellModel{
    if (_cellModel == cellModel) {
        return;
    }
    _cellModel = cellModel;
    [self addCellView];
}
//-(void)setTrainTerminated:(NSInteger)trainTerminated{
//    self.allView.trainTerminated = trainTerminated;
//}
- (void)setTrainId:(NSInteger)trainId{
    self.allView.trainId = trainId;
}
- (void)addCellView{
    CGFloat height = 0;
    for (int i = 0; i < _cellModel.listCellHeight.count; i++) {
        height += [_cellModel.listCellHeight[i] floatValue];
    }
    self.cellHeight = height;
    [self.cellContent.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.cellContent.frame = CGRectMake(0, 60, HIC_ScreenWidth, height);
    self.cellContent.hidden = YES;
    self.cellContent.backgroundColor = BACKGROUNG_COLOR;
    self.allView = [[HICMixAllView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, height + 12)];
    self.allView.trainTerminated = _trainTerminated;
    self.allView.modelDatas = _cellModel.listModels;
    __weak typeof(self) weakSelf = self;
    weakSelf.allView.refreshBlock = ^(NSInteger type) {
        if ([weakSelf.extensionDelegate respondsToSelector:@selector(refreshData)]) {
            [weakSelf.extensionDelegate refreshData];
        }
    };
   [self.cellContent addSubview:self.allView];
}
- (void)setIsShowContent:(BOOL)isShowContent{
    self.cellContent.hidden = !isShowContent;
    self.extensionbutton.selected = isShowContent;
}
- (void)btnClickExtension{
    self.extensionbutton.selected = !self.extensionbutton.selected;
    self.cellContent.hidden = !self.extensionbutton.selected;
    if (self.extensionDelegate && [self.extensionDelegate respondsToSelector:@selector(clickExtension:andIndex:andIsShowContent:)]) {
        if (self.cellContent.hidden) {
            [self.extensionDelegate clickExtension:60 andIndex:_indexPath.row andIsShowContent:NO];
        }else{
            CGFloat height = self.allView.height + 60.0;
            [self.extensionDelegate clickExtension:self.trainList.count > 0 ?height :60 andIndex:_indexPath.row andIsShowContent:YES];
        }
    }
}
@end
