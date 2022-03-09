//
//  HICPhotoPickerVC.m
//  HiClass
//
//  Created by Eddie Ma on 2020/1/14.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Photos/Photos.h>
#import "HICPhotoPickerVC.h"
#import "AlbumsTableViewCell.h"
#import "PhotoCollectionViewCell.h"

static NSString *logName = @"[HIC][PP]";
static NSString *photoCellIdentifier = @"photoCell";
static NSString *ablumCellIdenfer = @"albumCell";

@interface HICPhotoPickerVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_phAssets;
    UICollectionView *_photoCollectionView;
    NSMutableArray *_selectArray;
    NSMutableDictionary *_selectDic;
    NSMutableDictionary *_selectDicBefore;
    UIButton *_rightBtn;
    UITableView *_albumsTableView;
    NSMutableArray *_albums;
    UIButton *_albumsBtn;
    UIImageView *_pickerArrowIV;
    UIView *_albumChangeGroupV;
    UIView *_albumsBtmCoverV;
}

@end

@implementation HICPhotoPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self checkPhotoAuthorization];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)initData {
    _phAssets= [[NSMutableArray alloc] init];
    _selectArray = [[NSMutableArray alloc] init];
    _selectDic = [[NSMutableDictionary alloc] init];
    _selectDicBefore = [[NSMutableDictionary alloc] init];
    _albums = [[NSMutableArray alloc] init];
}

- (void)clearData {
    [_phAssets removeAllObjects];
//    [_selectArray removeAllObjects];
    [_selectDic removeAllObjects];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
    [self initNavigationBar];
    [self initCollectionView];
    [self initTableView];
}

- (void)initNavigationBar {
    UIView *naviBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_NavBarAndStatusBarHeight)];
    naviBarView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self.view addSubview:naviBarView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(12, (HIC_NavBarHeight - 22.5)/2 + HIC_StatusBar_Height, 40, 22.5);
    [leftBtn setTitle:NSLocalizableString(@"cancel", nil) forState: UIControlStateNormal];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    leftBtn.titleLabel.font = FONT_REGULAR_16;
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.tag = 10000;
    [leftBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [naviBarView addSubview:leftBtn];

    _albumChangeGroupV = [[UIView alloc] init];
     _albumChangeGroupV.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(albumChangeGroupClicked:)];
    [tapGesture setNumberOfTapsRequired:1];
    [_albumChangeGroupV addGestureRecognizer:tapGesture];
    [naviBarView addSubview:_albumChangeGroupV];

    _albumsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _albumsBtn.userInteractionEnabled = NO;
    _albumsBtn.frame = CGRectMake(15 + 40 + 15, 0, 0, 25);
    [_albumsBtn setTitle:NSLocalizableString(@"allPicture", nil) forState: UIControlStateNormal];
    _albumsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _albumsBtn.titleLabel.font = FONT_MEDIUM_18;
    [_albumsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_albumChangeGroupV addSubview:_albumsBtn];

    _pickerArrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 16)];
    _pickerArrowIV.image = [UIImage imageNamed:@"相册下拉"];
    [_albumChangeGroupV addSubview:_pickerArrowIV];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *rightBtnTitle = [NSString stringWithFormat:@"完成(0/%ld)", self.maximumPhoto ? ((long)[self.maximumPhoto integerValue] + 1) - self.selectedPhotosBefore : 9 - self.selectedPhotosBefore];
    CGFloat rightBtnWidth = [HICCommonUtils sizeOfString:rightBtnTitle stringWidthBounding:HIC_ScreenWidth font:15 stringOnBtn:YES fontIsRegular: NO].width;
    _rightBtn.frame = CGRectMake(HIC_ScreenWidth - (12 + rightBtnWidth), (HIC_NavBarHeight - 32)/2 + HIC_StatusBar_Height, rightBtnWidth, 32);
    [_rightBtn setTitle:rightBtnTitle forState: UIControlStateNormal];
    _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _rightBtn.titleLabel.font = FONT_MEDIUM_15;
    [_rightBtn setTitleColor: [UIColor colorWithRed:0/255.0 green:190/255.0 blue:215/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    _rightBtn.tag = 10001;
    _rightBtn.alpha = 0.5;
    [_rightBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [naviBarView addSubview:_rightBtn];

}

- (void)albumChangeGroupClicked:(UITapGestureRecognizer *)gesture {
    if (_albumsTableView.frame.size.height == 0) {
        [_albumsTableView reloadData];
        [UIView animateWithDuration:0.2f animations:^{
            self->_albumsTableView.frame = CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, (HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight) * 0.9);
            self->_albumsBtmCoverV.frame = CGRectMake(0, (HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight) * 0.9 + HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - ((HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight) * 0.9) - HIC_NavBarAndStatusBarHeight);
            self->_albumsBtmCoverV.hidden = NO;
             self->_pickerArrowIV.image = [UIImage imageNamed:@"相册收起"];
        }];

    } else {
        [UIView animateWithDuration:0.2f animations:^{
            self->_albumsTableView.frame = CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, 0);
            self->_pickerArrowIV.image = [UIImage imageNamed:@"相册下拉"];
            self->_albumsBtmCoverV.hidden = YES;
        }];
    }
}

- (void)clickButton:(UIButton *)sender {
    if (sender.tag == 10000) {
        DDLogDebug(@"%@ Clicked cancel", logName);
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        DDLogDebug(@"%@ Clicked Done Btn，photos selected %ld before", logName, (long)self.selectedPhotosBefore);
        NSArray *keyArray = [_selectDic allKeys];
        NSArray *keyBeforeArray = [_selectDicBefore allKeys];
        [_selectArray removeAllObjects];
        for (NSString *key in keyArray) {
            UIImage *image = [_selectDic objectForKey:key];
            if (image && [image isKindOfClass:UIImage.class]) {
                [_selectArray addObject:image];
            }

        }
        for (NSString *key in keyBeforeArray) {
            NSDictionary *imageDic = [_selectDicBefore objectForKey:key];
            NSArray *imageBeforeArray = [imageDic allValues];
            if (imageBeforeArray.count > 0) {
                for (UIImage *image in imageBeforeArray) {
                    if ([image isKindOfClass:UIImage.class] && ![_selectArray containsObject:image]) {
                        [_selectArray addObject:image];
                    }
                }
            }
        }
        if (_selectArray.count > 0) {
            DDLogDebug(@"%@ Total photo is %ld",logName, (long)_selectArray.count + self.selectedPhotosBefore);
            [self dismissViewControllerAnimated:YES completion:nil];
            if ([self.delegate respondsToSelector:@selector(photoSelecedDone:)]) {
                [self.delegate photoSelecedDone:_selectArray];
            }
        } else {
            [HICToast showAtDefWithText:NSLocalizableString(@"chooseAtLeastOneImage", nil)];
        }
    }
}

- (void)checkPhotoAuthorization {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            DDLogDebug(@"%@ 用户允许授权相册", logName);
            [self initAlbums];
        }else {
            DDLogDebug(@"%@ 用户拒绝授权相册", logName);
            dispatch_async(dispatch_get_main_queue(), ^{
                [HICToast showWithText:NSLocalizableString(@"enableAlbumPermission", nil)];
            });
        }
    }];
}

- (void)initAlbums {
    PHFetchOptions *smartAlbumsOptions = [PHFetchOptions new];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:smartAlbumsOptions];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        PHAsset *asset = (PHAsset *)assetsFetchResult.firstObject;
        if (asset.mediaType == PHAssetMediaTypeImage) {
            [self->_albums addObject:collection];
        }
    }];
    
    PHFetchOptions *userAlbumsOptions = [PHFetchOptions new];
    userAlbumsOptions.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:userAlbumsOptions];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
        [self->_albums addObject:collection];
    }];

    DDLogDebug(@"%@ Albums amount: %ld", logName, (long)_albums.count);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_albumsTableView reloadData];
        PHAssetCollection *collection = (PHAssetCollection *)self->_albums.firstObject;
        CGFloat albumsBtnWidth = [HICCommonUtils sizeOfString:collection.localizedTitle stringWidthBounding:HIC_ScreenWidth font:18 stringOnBtn:YES fontIsRegular: NO].width;
        self->_albumChangeGroupV.frame = CGRectMake((HIC_ScreenWidth - (albumsBtnWidth + 3 + 16))/2, HIC_StatusBar_Height, albumsBtnWidth + 3 + 16, HIC_NavBarHeight);
        self->_albumsBtn.frame = CGRectMake(0, (HIC_NavBarHeight - self->_albumsBtn.frame.size.height)/2, albumsBtnWidth, self->_albumsBtn.frame.size.height) ;
        [self->_albumsBtn setTitle:collection.localizedTitle forState: UIControlStateNormal];
        self->_pickerArrowIV.frame = CGRectMake(albumsBtnWidth + 3, (HIC_NavBarHeight - 16)/2, 16, 16);
        self->_phAssets =  [self getAllAssetInPhotoAblumWithAscending:NO isCollection:YES collection:collection];
        NSMutableDictionary *temDic = [[NSMutableDictionary alloc] init];
        [self->_selectDicBefore setValue:temDic forKey:collection.localizedTitle];
        DDLogDebug(@"%@ Init Photos: %ld", logName, (unsigned long)self->_phAssets.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_photoCollectionView reloadData];
        });
    });
}

// 获取相册内所有照片资源
- (NSMutableArray*)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending isCollection:(BOOL)isCollection collection:(PHAssetCollection *)collection {
    NSMutableArray*assets = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = isCollection ? [PHAsset fetchAssetsInAssetCollection:collection options:option] : [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        [assets addObject:asset];
    }];
    return assets;
}

// 从图片asset里获取UIImage
- (UIImage *)getUIImage:(PHAsset *)set showOriginImg:(BOOL)show{
    UIImage __block *aImg;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous=YES;
    options.networkAccessAllowed = YES;
    // 设置图片大小(像素)
    NSUInteger pw = HIC_ScreenWidth * 1.5;
    NSUInteger ph = pw * set.pixelHeight / set.pixelWidth;
    CGSize imageSize = show ? CGSizeMake(pw, ph) : CGSizeMake(240*HIC_Divisor, 135*HIC_DivisorH);
    [[PHImageManager defaultManager] requestImageForAsset:set targetSize:imageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        aImg = result;
    }];
    return aImg;
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];//竖直滑动
    _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight - HIC_NavBarAndStatusBarHeight) collectionViewLayout: flow];
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    _photoCollectionView.showsHorizontalScrollIndicator = NO;
    _photoCollectionView.showsVerticalScrollIndicator = YES;
    _photoCollectionView.alwaysBounceVertical = YES;
    _photoCollectionView.backgroundColor = [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1/1.0];
    [_photoCollectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:photoCellIdentifier];
    [self.view addSubview:_photoCollectionView];
}

// 设置分组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

// 单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _phAssets.count;
}

// 单元格内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:photoCellIdentifier forIndexPath:indexPath];
    UIImage *image = [self getUIImage:_phAssets[indexPath.row] showOriginImg:NO];
    NSArray *keyArray = [_selectDic allKeys];
    if (keyArray.count == 0) {
        if ([[_selectDicBefore allKeys] containsObject: _albumsBtn.titleLabel.text]) {
            NSMutableDictionary *temDic = _selectDicBefore[ _albumsBtn.titleLabel.text];
            keyArray = [temDic allKeys];
            [_selectDic setDictionary:temDic];
        }
    }
    [cell setData:image index:indexPath.row selectedArry:keyArray];
    return cell;
}

// 点击单元格触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIImage *image = [self getUIImage:_phAssets[indexPath.row] showOriginImg:YES];
    //判断是否超过9张
    NSInteger selectedLeft = (self.maximumPhoto ? [self.maximumPhoto integerValue] : 8) - self.selectedPhotosBefore;
    if ((_selectArray.count > selectedLeft) && ([cell unSelectedImg])) { // 大于9张
        NSInteger maxPhotos = self.maximumPhoto ? [self.maximumPhoto integerValue] + 1 - self.selectedPhotosBefore : 9 - self.selectedPhotosBefore;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%ld%@", NSLocalizableString(@"photosCannotExceed", nil),(long)maxPhotos,NSLocalizableString(@"zhang", nil)] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizableString(@"determine", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:confirmAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    } else {
        if ([cell unSelectedImg]) {
            [_selectArray addObject:image];
            [_selectDic setObject:image forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
            if (_selectDic.count > 0) {
                [self setBtnAlpha:_rightBtn alpha:1.0];
            }
            [cell showUnselectedView:NO];
        } else {
            [cell showUnselectedView:YES];
            [_selectArray removeLastObject];
            [_selectDic removeObjectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
            if (_selectDic.count == 0) {
                [self setBtnAlpha:_rightBtn alpha:0.5];
            }
        }
        NSString *rightBtnTitle = [NSString stringWithFormat:@"完成(%ld/%ld)", (long)_selectArray.count, self.maximumPhoto ? ((long)[self.maximumPhoto integerValue] + 1) - self.selectedPhotosBefore : 9 - self.selectedPhotosBefore];
        [_rightBtn setTitle:rightBtnTitle forState: UIControlStateNormal];
    }
    DDLogDebug(@"%@ Selected index: %ld, total seleted: %ld photos", logName, (long)indexPath.row, (long)_selectArray.count);
}


// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(PH_COLLECTION_CELL_HEIGHT, PH_COLLECTION_CELL_HEIGHT);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // UIEdgeInsets insets = {top, left, bottom, right};
    return UIEdgeInsetsMake(PH_COLLECTION_CELL_INTER_ITEM_SAPCING, PH_COLLECTION_CELL_INTER_ITEM_SAPCING, PH_COLLECTION_CELL_INTER_ITEM_SAPCING, PH_COLLECTION_CELL_INTER_ITEM_SAPCING);
}

// 两行cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return PH_COLLECTION_CELL_INTER_ITEM_SAPCING;
}

// 两列cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return PH_COLLECTION_CELL_INTER_ITEM_SAPCING;
}

- (void)setBtnAlpha:(UIButton *)btn alpha:(CGFloat)a {
    btn.alpha = a;
}

- (void)initTableView {
    _albumsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, 0) style:UITableViewStylePlain];
    _albumsTableView.backgroundColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1/1.0];
    _albumsTableView.dataSource = self;
    _albumsTableView.delegate = self;
    if (@available(iOS 15.0, *)) {
        _albumsTableView.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:_albumsTableView];

    _albumsBtmCoverV = [[UIView alloc] init];
    _albumsBtmCoverV.hidden = YES;
    _albumsBtmCoverV.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    [self.view addSubview:_albumsBtmCoverV];
}

#pragma mark tableview dataSorce协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumsTableViewCell *albumCell = (AlbumsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ablumCellIdenfer];
    if (albumCell == nil) {
        albumCell = [[AlbumsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ablumCellIdenfer];
        [albumCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    PHAssetCollection *collection = _albums[indexPath.row];
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];

    PHAsset *asset = (PHAsset *)assetsFetchResult.firstObject;
    UIImage *image = nil;
    if (asset.mediaType == PHAssetMediaTypeImage ) {
        image = [self getUIImage:asset showOriginImg:NO];
    }
    BOOL showPicked = NO;
    if ([collection.localizedTitle containsString:_albumsBtn.titleLabel.text]) {
        showPicked = YES;
    }
    [albumCell setDataWith:collection.localizedTitle photo:image amount:assetsFetchResult.count showPicked:showPicked];
    return albumCell;
    
}

#pragma mark tableview delegate协议方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PH_TABLE_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PH_TABLE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAssetCollection *collection = _albums[indexPath.row];
    // 保存之前相册选定的照片
    NSMutableDictionary *temSelectDic = [[NSMutableDictionary alloc]initWithDictionary:[_selectDic copy]];
    if ([[_selectDicBefore allKeys] containsObject: _albumsBtn.titleLabel.text]) {
//        NSMutableDictionary *temDic = _selectDicBefore[_albumsBtn.titleLabel.text];
        NSMutableDictionary *temDic = [[NSMutableDictionary alloc] init];
        [_selectDicBefore removeObjectForKey:_albumsBtn.titleLabel.text];
        NSArray *selectDicKey = [temSelectDic allKeys];
        for (NSString *key in selectDicKey) {
            [temDic setValue:temSelectDic[key] forKey:key];
        }
        [_selectDicBefore setValue:temDic forKey:_albumsBtn.titleLabel.text];
    } else {
        [_selectDicBefore setValue:temSelectDic forKey:_albumsBtn.titleLabel.text];
    }

    [self clearData];
    _phAssets =  [self getAllAssetInPhotoAblumWithAscending:NO isCollection:YES collection:collection];
    DDLogDebug(@"%@ '%@' album selected, %lu photos in this album", logName, collection.localizedTitle, (unsigned long)_phAssets.count);
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2f animations:^{
            self->_albumsTableView.frame = CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, 0);
        }];
        [self->_photoCollectionView reloadData];
        CGFloat albumsBtnWidth = [HICCommonUtils sizeOfString:collection.localizedTitle stringWidthBounding:HIC_ScreenWidth font:18 stringOnBtn:YES fontIsRegular:NO].width;
        self->_albumChangeGroupV.frame = CGRectMake((HIC_ScreenWidth - (albumsBtnWidth + 3 + 16))/2, HIC_StatusBar_Height, albumsBtnWidth + 3 + 16, HIC_NavBarHeight);
        self->_albumsBtn.frame = CGRectMake(0, (HIC_NavBarHeight - self->_albumsBtn.frame.size.height)/2, albumsBtnWidth, self->_albumsBtn.frame.size.height) ;
        [self->_albumsBtn setTitle:collection.localizedTitle forState: UIControlStateNormal];
        self->_pickerArrowIV.frame = CGRectMake(albumsBtnWidth + 3, (HIC_NavBarHeight - 16)/2, 16, 16);

        [self->_albumsBtn setTitle:collection.localizedTitle forState: UIControlStateNormal];
        self->_pickerArrowIV.image = [UIImage imageNamed:@"相册下拉"];
        self->_albumsBtmCoverV.hidden = YES;
    });
}


@end
