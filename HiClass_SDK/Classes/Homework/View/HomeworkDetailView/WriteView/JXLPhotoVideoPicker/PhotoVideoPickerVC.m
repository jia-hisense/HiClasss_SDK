//
//  PhotoVideoPickerVC.m
//  HsShare3.5
//
//  Created by wangggang on 2019/10/26.
//  Copyright © 2019 com.hisense. All rights reserved.
//

#import "PhotoVideoPickerVC.h"

#import "PhotoVideoPickerCell.h"


@interface PhotoVideoPickerVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *videos;

/// 记录右侧的按钮，随时更改状态
@property (nonatomic, strong) UIButton *rightBarItem;

/// 当前选中的是那个cell
@property (nonatomic, assign) NSInteger selectCellIndex;

// 选中视频路径
@property (nonatomic, copy) NSString *videoPath;
// 视频时长
@property (nonatomic, assign) NSInteger second;
// 视频宽高比
@property (nonatomic, assign) CGFloat ratio;

@end

@implementation PhotoVideoPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加视图
    [self.view addSubview:self.collectionView];
    
    [self createBarView];
    
    // 初始化参数
    [self loadDataVideos];
    _selectCellIndex = -1;
}

#pragma mark - 创建视图
-(void)createBarView {
    
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(16, 7, 50, 30)];
    [left setTitle:NSLocalizableString(@"cancel", nil) forState:UIControlStateNormal];
    [left addTarget:self action:@selector(clickBarLeft:) forControlEvents:UIControlEventTouchUpInside];
    [left setTitleColor:[UIColor colorWithHexString:@"#03b3cc"]  forState:UIControlStateNormal];
    left.titleLabel.font = FONT_MEDIUM_16

    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(HIC_ScreenWidth-16-50, 7, 50, 30)];
    [right setTitle:NSLocalizableString(@"complete", nil) forState:UIControlStateNormal];
    [right addTarget:self action:@selector(clickBarRight:) forControlEvents:UIControlEventTouchUpInside];
    right.titleLabel.font = FONT_MEDIUM_16

    self.rightBarItem = right;
//    [self changeRightBarItemWithSelect:NO];
    [right setTitleColor:[UIColor colorWithHexString:@"#03b3cc"] forState:UIControlStateNormal];
    

    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_StatusBar_Height, HIC_ScreenWidth, HIC_NavBarHeight)];
    navBar.backgroundColor = [UIColor whiteColor];
    [navBar addSubview:left];
    [navBar addSubview:right];

    [self.view addSubview:navBar];
    
}

#pragma mark 对应view方法
-(void)clickBarLeft:(UIBarButtonItem *)item {
    
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

-(void)clickBarRight:(UIBarButtonItem *)item {
    
    if (_selectCellIndex == -1) {
        return;
    }
    // 正常情况下 导出 mp4的视频压缩转化
    item.enabled = NO;
    [self dealVideoWithPath:self.videoPath];
    
}

-(void)changeRightBarItemWithSelect:(BOOL)isSelect {
    
    if (isSelect) {
        [self.rightBarItem setBackgroundImage:[UIImage imageNamed:@"bg_sendout_complete"] forState:UIControlStateNormal];
    }else {
        [self.rightBarItem setBackgroundImage:[UIImage imageNamed:@"bg_sendout_disable"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - 获取视频数据
-(void)loadDataVideos {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                PHFetchOptions *option = [[PHFetchOptions alloc] init];
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeVideo];
                option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
                
                
                //fetchAssetCollectionsWithType
                PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
//                PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:option];
                NSMutableArray *array = [NSMutableArray array];
                for (PHAssetCollection *collection in smartAlbums) {
                    // 有可能是PHCollectionList类的的对象，过滤掉
                    if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
                    // 过滤空相册
                    if (collection.estimatedAssetCount <= 0) continue;
                    
                    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
//                    dispatch_semaphore_t semp = dispatch_semaphore_create(0);
                    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        PHAsset *phAsset = (PHAsset *)obj;
                        if (phAsset.mediaType == PHAssetMediaTypeVideo && phAsset.mediaSubtypes != PHAssetMediaSubtypeVideoHighFrameRate) {
                            NSTimeInterval   time = phAsset.duration;//avAsset.duration.value/avAsset.duration.timescale;
                            int seconds = ceil(time);
                            if (seconds <= 60*30 && seconds >3 ) {
                                //可通过此PHAsset用下边方法分别获取时常、地址及缩略图
                                if(![array containsObject:phAsset]) {
                                    [array addObject:phAsset];
                                }
                            }
                        }
                    }];

                }

                if (array.count > 0) {
                    self.videos = [array copy];
                    // 刷新视图
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                    });

                }

            });


        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HICToast showWithText:NSLocalizableString(@"openAlbumPermission", nil)];
            });
        }
    }];
    
}

#pragma mark 处理视频(压缩、分辨率)
- (void)dealVideoWithPath:(NSString *)path{
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //获取文件资源
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    //导出预设参数
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    //是否包含中分辨率，如果是低分辨率AVAssetExportPresetLowQuality则不清晰
    if ([presets containsObject:AVAssetExportPresetMediumQuality]) {
        
        //重定义资源属性（画质设置成中等）
        AVAssetExportSession *dealSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        //压缩后的文件路径
        NSString *dealPath = [kHMBPath_video stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", [HICCommonUtils getTimeWithZone]]];
        
        //存在的话就删除
        if ([[NSFileManager defaultManager] fileExistsAtPath:dealPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:dealPath error:nil];
        }
        
        //导出路径
        dealSession.outputURL = [NSURL fileURLWithPath:dealPath];
        //导出类型
        dealSession.outputFileType = AVFileTypeMPEG4;
        //是否对网络进行优化
        dealSession.shouldOptimizeForNetworkUse = YES;
        
        __weak typeof(self) weakSelf = self;
        //导出
        [dealSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([dealSession status]) {
                case AVAssetExportSessionStatusFailed://失败
                {
                    DDLogDebug(@"failed, error:%@.", dealSession.error);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.rightBarItem.enabled = YES;
                        [HICToast showAtDefWithText:NSLocalizableString(@"videoNoPermissionPrompt", nil)];
                    });
                }
                    break;
                case AVAssetExportSessionStatusCancelled://转换中
                    break;
                case AVAssetExportSessionStatusCompleted://完成
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([weakSelf.delegate respondsToSelector:@selector(videoPickerVC:clickVideoFile:durat:ratio:)]) {
                            [weakSelf.delegate videoPickerVC:weakSelf
                                          clickVideoFile:dealPath
                                                   durat:weakSelf.second
                                                   ratio:weakSelf.ratio];
                        }
                        
                        weakSelf.rightBarItem.enabled = YES;
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    });
                }
                    break;
                default:
                    break;
            }
        }];
    }
}

#pragma mark - collectionView的协议方法
#pragma mark dataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.videos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PhotoVideoPickerCell *cell = (PhotoVideoPickerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
    
    cell.asset = [self.videos objectAtIndex:indexPath.row];
    cell.cellIndexPath = indexPath;
    cell.isSelectBut = NO;
    
    if (_selectCellIndex == indexPath.row) {
        
        cell.isSelectBut = YES;
        
    }
    
    cell.clickSelectBut = ^(BOOL isSelect, NSIndexPath * _Nonnull cellIndexPath, NSString * _Nonnull filePath, NSInteger durat, CGFloat ratio) {
      
        if(!filePath || [filePath isEqualToString:@""]) {
            _selectCellIndex = -1;
            [collectionView reloadData];
            return;
        }
        
        [self changeRightBarItemWithSelect:isSelect];
        
        if (isSelect) {
            
            self.videoPath = filePath;
            self.second = durat;
            self.ratio = ratio;

            // 当前为选中状态
            if(_selectCellIndex == -1) {
                // 此时之前没有选中
                _selectCellIndex = cellIndexPath.row;
                
            }else {
                // 之前有选中
                NSIndexPath *oldPath = [NSIndexPath indexPathForRow:_selectCellIndex inSection:0];
                _selectCellIndex = cellIndexPath.row;
                [collectionView reloadItemsAtIndexPaths:@[oldPath, cellIndexPath]];
            }
            
        }else {
            // 当前为取消选中状态
            _selectCellIndex = -1;
            
            self.videoPath = nil;
            self.second = 0;
            self.ratio = 0;
        }
        
    };
    
    return cell;
    
}

#pragma mark delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 点击某一个视频需要播放
    PhotoVideoPickerCell *cell = (PhotoVideoPickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell clickCellPlayVideo:self];
    
}

#pragma mark - 懒加载
-(UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(phCollectionCellHeight, phCollectionCellHeight);
        layout.minimumLineSpacing = 1.0;
        layout.minimumInteritemSpacing = 1.0;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        CGFloat bottom = HIC_BottomHeight;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, HIC_StatusBar_Height+44, HIC_ScreenWidth, HIC_ScreenHeight-(HIC_StatusBar_Height+44)-bottom) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[PhotoVideoPickerCell class] forCellWithReuseIdentifier:@"videoCell"];
    }
    return _collectionView;
    
}

@end
