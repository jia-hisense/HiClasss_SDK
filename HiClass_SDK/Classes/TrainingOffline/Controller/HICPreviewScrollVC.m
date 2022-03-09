//
//  HICPreviewScrollVC.m
//  自定义Layout标签
//
//  Created by Sir_Jing on 2020/5/9.
//  Copyright © 2020 崔志伟. All rights reserved.
//

#import "HICPreviewScrollVC.h"
#import "NSString+String.h"
#import <SDWebImage/SDWebImage.h>
#import "HICNavgationBar.h"

@interface HICPreviewScrollVCCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *backScrollView;

@property (nonatomic, strong) UIImageView *photoImageView;

@end

@implementation HICPreviewScrollVCCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView {
    UIScrollView *backScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    backScrollView.maximumZoomScale = 2.f;
    backScrollView.minimumZoomScale = 0.8f;
    [self.contentView addSubview:backScrollView];
    _backScrollView = backScrollView;
    _backScrollView.delegate = self;

    _photoImageView = [[UIImageView alloc] initWithFrame:backScrollView.bounds];
    [backScrollView addSubview:_photoImageView];
    _photoImageView.userInteractionEnabled = YES;
    _photoImageView.contentMode = UIViewContentModeScaleAspectFit;

    // 1. 添加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击

    [_photoImageView addGestureRecognizer:singleTap];
    [_photoImageView addGestureRecognizer:doubleRecognizer];
    [singleTap requireGestureRecognizerToFail:doubleRecognizer];
}

-(void)singleTap:(UITapGestureRecognizer *)but {
    DDLogDebug(@"单击事件");
    if ([self.delegate respondsToSelector:@selector(previewCell:didClickBackTap:other:)]) {
        [self.delegate previewCell:self didClickBackTap:but other:nil];
    }
}
// 双击缩放
-(void)doubleTap:(UITapGestureRecognizer *)but {
    DDLogDebug(@"双击事件");
    CGFloat zoomScale = self.backScrollView.zoomScale;
    zoomScale = (zoomScale == 2.0) ? 1.0 : 2.0;
    CGRect zoomRect = [self zoomRectForScale:zoomScale withCenter:[but locationInView:but.view]];
    [self.backScrollView zoomToRect:zoomRect animated:YES];
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =self.frame.size.height / scale;
    zoomRect.size.width  =self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}
#pragma mark - 滚动视图的协议
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _photoImageView;
}
/* scrollview已经发生了Zoom事件 */
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {

    if(view.frame.size.width < scrollView.frame.size.width){
        view.frame = CGRectMake((scrollView.frame.size.width-view.frame.size.width)/2, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        
    }
    if(view.frame.size.height < scrollView.frame.size.height){
        view.frame = CGRectMake(view.frame.origin.x, (scrollView.frame.size.height-view.frame.size.height)/2, view.frame.size.width, view.frame.size.height);
    }

}

#pragma mark - 页面赋值
-(void)setUrlString:(NSString *)urlString {
    _urlString = urlString;

    if ([NSString isValidString:urlString]) {
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        if (url) {
            [self.photoImageView sd_setImageWithURL:url];
        }
    }
}

@end

@interface HICPreviewScrollVC ()<UICollectionViewDelegate, UICollectionViewDataSource, HICPreviewScrollVCCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionVeiw;

@property (nonatomic, assign) UIStatusBarStyle barStyle;

@property (nonatomic, strong) HICNavgationBar *barView;

@end

@implementation HICPreviewScrollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];


    self.view.backgroundColor = UIColor.whiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.collectionVeiw]; // 添加滚动视图
    self.barView = [[HICNavgationBar alloc] initWithTitle:@"" bgColor:[UIColor clearColor] leftBtnImage:@"头部-返回-白色" rightBtnImg:nil];
    __weak typeof(self) weakSelf = self;
    [self.barView setItemClicked:^(HICNavgationTapType tapType) {
        switch (tapType) {
            case LeftTap:
                if (weakSelf.presentingViewController && weakSelf.navigationController.viewControllers.count == 1) {
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                break;
            case RightTap:

                break;

            default:
                break;
        }
    }];
    [self.view addSubview:self.barView];
    self.barView.title = [NSString stringWithFormat:@"1/%lu", (unsigned long)self.dataSource.count];

    self.barStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.barStyle = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.barStyle;
}

#pragma mark - 协议CollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HICPreviewScrollVCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.backScrollView.zoomScale = 1.0;
    cell.urlString = [self.dataSource objectAtIndex:indexPath.row];
    cell.delegate = self;

    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionVeiw) {
        NSInteger index = scrollView.contentOffset.x/HIC_ScreenWidth + 1;
        if (index <= 0) {
            index = 1;
        }
        if (index > self.dataSource.count) {
            index = self.dataSource.count;
        }
        self.barView.title = [NSString stringWithFormat:@"%ld/%ld ",(long)index,(long)self.dataSource.count];
    }
}

#pragma mark - 自定义cell协议方法
-(void)previewCell:(HICPreviewScrollVCCell *)cell didClickBackTap:(UITapGestureRecognizer *)tap other:(id)data {
    /*
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }*/
}

#pragma mark - 懒加载
-(UICollectionView *)collectionVeiw {
    if (!_collectionVeiw) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = UIScreen.mainScreen.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionVeiw = [[UICollectionView alloc] initWithFrame:UIScreen.mainScreen.bounds collectionViewLayout:layout];
        [_collectionVeiw registerClass:HICPreviewScrollVCCell.class forCellWithReuseIdentifier:@"cell"];
        _collectionVeiw.backgroundColor = UIColor.blackColor;
        _collectionVeiw.pagingEnabled = YES;
        _collectionVeiw.delegate = self;
        _collectionVeiw.dataSource = self;
    }
    return _collectionVeiw;
}

@end
