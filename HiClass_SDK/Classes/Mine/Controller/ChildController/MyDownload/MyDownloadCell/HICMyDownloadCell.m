//
//  HICMyDownloadCell.m
//  HiClass
//
//  Created by Eddie_Ma on 23/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyDownloadCell.h"
#import "HICCircleProgressView.h"

#define circleViewW  30

@interface HICMyDownloadCell()<HICDownloadManagerDelegate>//

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *downloadLabel;
@property (nonatomic, strong) UIImageView *downloadStatusIV;
@property (nonatomic, strong) UIButton *circleBtn;
@property (nonatomic, strong) HICCircleProgressView *circleView;
@property (nonatomic, strong) UILabel *courseTag;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) HICKnowledgeDownloadModel *kModel;
@property (nonatomic, assign) BOOL isPureKnowledge;
@property (nonatomic, strong) UIImageView *checkIV;
@property (nonatomic, assign) CGFloat leftMargin;

@end

@implementation HICMyDownloadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
//        DLManager.delegate = self;
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];

    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 130, 73)];
    [self.contentView addSubview: _imgView];
    _imgView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
    _imgView.layer.cornerRadius = 4;
    _imgView.layer.masksToBounds = YES;

    self.courseTag = [[UILabel alloc] init];
    [_imgView addSubview:_courseTag];
    _courseTag.frame = CGRectMake(0, 0, 36, 16);
    _courseTag.layer.cornerRadius = 1.5;
    _courseTag.layer.masksToBounds = YES;
    _courseTag.hidden = YES;
    _courseTag.text = NSLocalizableString(@"coursePackage", nil);
    _courseTag.textColor = [UIColor whiteColor];
    _courseTag.font = FONT_MEDIUM_11;
    _courseTag.textAlignment = NSTextAlignmentCenter;
    _courseTag.backgroundColor = [UIColor colorWithHexString:@"#00E2D8"];

    self.checkIV = [[UIImageView alloc] init];
    [self.contentView addSubview: _checkIV];
    _checkIV.frame = CGRectMake(12, (MY_DOWNLOAD_CELL_HEIGHT - _imgView.frame.size.height) + (_imgView.frame.size.height - 24)/2, 24, 24);
    _checkIV.image = [UIImage imageNamed:@"未选择"];
    _checkIV.hidden = YES;

    self.title = [[UILabel alloc] init];
    [self.contentView addSubview:_title];
    _title.font = FONT_MEDIUM_15;
    _title.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    _title.numberOfLines = 2;

    _downloadLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_downloadLabel];
    _downloadLabel.font = FONT_REGULAR_13;
    _downloadLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1/1.0];

    _circleBtn = [[UIButton alloc] initWithFrame:CGRectMake(HIC_ScreenWidth - circleViewW - 20, MY_DOWNLOAD_CELL_HEIGHT - circleViewW + 5, circleViewW, circleViewW)];
    [self.contentView addSubview:_circleBtn];
     _circleBtn.tag = 10000;
    [_circleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    _circleView = [[HICCircleProgressView alloc] initWithFrame:CGRectMake(0,0, circleViewW, circleViewW)];
    [_circleBtn addSubview: _circleView];
    _circleView.userInteractionEnabled = NO;

    _downloadStatusIV = [[UIImageView alloc] init];
    [_circleView addSubview:_downloadStatusIV];

}

- (void)setData:(HICKnowledgeDownloadModel *)kModel index:(NSInteger)index isPureKnowledge:(BOOL)isPureKnowledge isEditing:(BOOL)isEditing checked:(NSArray *)checkArr {
    self.index = index;
    self.kModel = kModel;
    self.isPureKnowledge = isPureKnowledge;

    if (isEditing) {
        _checkIV.hidden = NO;
        _leftMargin = 12 + 24 + 12.5;
    } else {
        _checkIV.hidden = YES;
        _leftMargin = 16;
    }
    _checkIV.image = [UIImage imageNamed:@"未选择"];
    _imgView.frame = CGRectMake(_leftMargin, 16, 130, 73);

    for (HICKnowledgeDownloadModel *temKModel in checkArr) {
        if ([temKModel.mediaId isEqual:kModel.mediaId]) {
            _checkIV.image = [UIImage imageNamed:@"勾选"];
            break;
        }
    }

    NSString *titleStr = kModel.mediaName;
    if (kModel.mediaSingle != 1 && !_isPureKnowledge) { // 是整个课程被下载
        titleStr = kModel.cMediaName;
        if ([NSString isValidStr:kModel.cCoverPic]) {
            [_imgView sd_setImageWithURL:[NSURL URLWithString:kModel.cCoverPic]];
        }
    } else {
        if ([NSString isValidStr:kModel.coverPic]) {
            [_imgView sd_setImageWithURL:[NSURL URLWithString:kModel.coverPic]];
        }
    }
    _title.text = titleStr;
    CGFloat titleW = HIC_ScreenWidth - (_leftMargin + _imgView.frame.size.width + 12 + 16);
    CGSize titleSize = [HICCommonUtils sizeOfString:_title.text stringWidthBounding:HIC_ScreenWidth font:15 stringOnBtn:NO fontIsRegular:NO];
    _title.frame = CGRectMake(_leftMargin + _imgView.frame.size.width + 12, 16, titleW, titleSize.height);
    [_title sizeToFit];

    [self setProcessUIWith:kModel percent: kModel.mediaStatus == HICDownloadFinish ? 1 : [kModel.mediaDownloadSize doubleValue]/[kModel.mediaSize doubleValue]];
}

- (void)setProcessUIWith:(HICKnowledgeDownloadModel *)kModel percent:(CGFloat)percent {
    if (kModel.mediaId == _kModel.mediaId) {
        NSString *imgName = @"";
         CGFloat imgHeight = 0;
         CGFloat imgWidth = 0;
        NSString __block *downloadLabel = @"";
         _circleBtn.hidden = NO;
        if (kModel.mediaStatus == HICDownloading || kModel.mediaStatus == HICDownloadResume) {
             imgName = @"暂停";
             imgWidth = 8;
             imgHeight = 10;
            downloadLabel = [NSString stringWithFormat:@"%@...%.f%@",NSLocalizableString(@"isDownloading", nil), percent *100, @"%"];
         } else if (kModel.mediaStatus == HICDownloadStop) {
             imgName = @"点击下载";
             imgWidth = 11;
             imgHeight = 11;
             downloadLabel = NSLocalizableString(@"hasSuspended", nil);
         } else if (kModel.mediaStatus == HICDownloadFinish) {
             imgName = @"下载完成";
             imgWidth = 14;
             imgHeight = 14;
             downloadLabel = NSLocalizableString(@"haveDownloaded", nil);
             _circleBtn.hidden = YES;
         } else {}

        if (kModel.mediaSingle != 1 && !_isPureKnowledge) { // 是整个课程被下载
            _courseTag.hidden = NO;
            _circleBtn.hidden = YES;
        } else { // 是单个知识被下载
            _courseTag.hidden = YES;
        }
        [self.circleView updateProgressStatus:percent];

        self.downloadStatusIV.image = [UIImage imageNamed:imgName];
        self.downloadStatusIV.frame = CGRectMake(circleViewW/2 - imgWidth/2, circleViewW/2 - imgHeight/2, imgWidth, imgHeight);

        dispatch_async([DBManager database_queue], ^{
            if (kModel.mediaSingle != 1 && !_isPureKnowledge) {
                downloadLabel = [NSString stringWithFormat:@"%ld%@", (long)[DBManager selectMediasByMediaId:kModel.cMediaId isCourseId:YES].count,NSLocalizableString(@"downloadKnowledge", nil)]; //kModel.mediaDownloadCount
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                CGSize downloadLabelSize = [HICCommonUtils sizeOfString:downloadLabel stringWidthBounding:HIC_ScreenWidth font:13 stringOnBtn:NO fontIsRegular:YES];
                self.downloadLabel.frame = CGRectMake(self.leftMargin + self.imgView.frame.size.width + 12, MY_DOWNLOAD_CELL_HEIGHT - downloadLabelSize.height, downloadLabelSize.width, downloadLabelSize.height);
                self.downloadLabel.text = downloadLabel;
            });
        });
    }
}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 10000) {
        NSString *imgName = @"";
        CGFloat imgHeight = 0;
        CGFloat imgWidth = 0;
        NSString *downloadLabel = @"";
        if (_kModel.mediaStatus == HICDownloading || _kModel.mediaStatus == HICDownloadResume) {
            imgName = @"点击下载";
            imgWidth = 11;
            imgHeight = 11;
           downloadLabel = NSLocalizableString(@"hasSuspended", nil);
            _kModel.mediaStatus = HICDownloadStop;
            [DLManager pauseWith:_kModel.mediaId];
        } else if (_kModel.mediaStatus == HICDownloadStop) {
            imgName = @"暂停";
            imgWidth = 8;
            imgHeight = 10;
            downloadLabel = [NSString stringWithFormat:@"%@...",NSLocalizableString(@"isDownloading", nil)];
             _kModel.mediaStatus = HICDownloadResume;
            [DLManager resumeWith:_kModel.mediaId];
        } else if (_kModel.mediaStatus == HICDownloadFinish) {
            imgName = @"下载完成";
            imgWidth = 14;
            imgHeight = 14;
            downloadLabel = NSLocalizableString(@"haveDownloaded", nil);
        } else {}
        self.downloadStatusIV.image = [UIImage imageNamed:imgName];
        self.downloadStatusIV.frame = CGRectMake(circleViewW/2 - imgWidth/2, circleViewW/2 - imgHeight/2, imgWidth, imgHeight);
        CGSize downloadLabelSize = [HICCommonUtils sizeOfString:downloadLabel stringWidthBounding:HIC_ScreenWidth font:13 stringOnBtn:NO fontIsRegular:YES];
        _downloadLabel.frame = CGRectMake(16 + _imgView.frame.size.width + 12, MY_DOWNLOAD_CELL_HEIGHT - downloadLabelSize.height, downloadLabelSize.width, downloadLabelSize.height);
        _downloadLabel.text = downloadLabel;
    }
}

//#pragma mark - - - HICDownloadManagerDelegate - - - Start
//- (void)downloadProcess:(CGFloat)percent kModel:(HICKnowledgeDownloadModel *)kModel {
//    [self setProcessUIWith:kModel percent:percent];
//}
//#pragma mark - - - HICDownloadManagerDelegate - - - End

@end
