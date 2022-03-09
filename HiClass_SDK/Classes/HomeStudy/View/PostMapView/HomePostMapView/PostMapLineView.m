//
//  PostMapLineView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "PostMapLineView.h"

#import "PostMapSingleButView.h"
#import "PostMapAlertProgressView.h"

#define ToRadian(radian)            (radian*(M_PI/180.0))
#define RateWidth(screenWidth)      (screenWidth/375.0)
#define RateHeight(screenHeight)    (screenHeight/740.0)

@interface PostMapLineView ()<PostMapSingleButViewDelegate>

@property (nonatomic, strong) NSMutableArray<PostMapSingleButView *> *butArray;

@property (nonatomic, strong) PostMapAlertProgressView *alertProgress;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray<PostMapSingleButView *> *showButArray;

@end

@implementation PostMapLineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //1\. 注：如果没有获取context时，是什么都不做的（背景无变化）
    [super drawRect:rect];

    CGFloat screenWidth = rect.size.width;
    CGFloat screenHeight = rect.size.height;

    // 绘制图片
    UIImage *image = [UIImage imageNamed:@"背景"];
    [image drawInRect:CGRectMake(0, 0, screenWidth, screenHeight)];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat lineWidth = 14*RateWidth(screenWidth);
    CGFloat viewCenterWidth = rect.size.width/2.0;
    CGFloat headerViewHeight = 124*RateHeight(screenHeight);
    //第一条线
    CGFloat firstLineHeight = 32.5*RateHeight(screenHeight) + headerViewHeight;
    CGFloat firstRate = 30*RateWidth(screenWidth);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextMoveToPoint(ctx, viewCenterWidth, headerViewHeight);
    CGContextAddLineToPoint(ctx, viewCenterWidth, firstLineHeight);

    PostMapSingleButView *view = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth, firstLineHeight)];
    [self addSubview:view];

    // 第一拐加直线
    CGContextAddArc(ctx, viewCenterWidth+firstRate, firstLineHeight, firstRate, ToRadian(-180), ToRadian(90), 1);
    CGFloat firstLineWidth = 43*RateWidth(screenWidth);
    CGContextAddLineToPoint(ctx, viewCenterWidth+firstRate+firstLineWidth, firstLineHeight+firstRate);
    
    // 第二拐
    CGFloat allRate = 53*RateHeight(screenHeight);
    CGContextAddArc(ctx, viewCenterWidth+firstRate+firstLineWidth, firstLineHeight+firstRate+allRate, allRate, ToRadian(-90), ToRadian(90), 0);

    PostMapSingleButView *view1 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth+firstRate+firstLineWidth+allRate, firstLineHeight+firstRate+allRate)];
    [self addSubview:view1];

    // 第二横线
    CGFloat twoY = firstLineHeight+firstRate+allRate*2;
    CGFloat allLineWith = 73*RateWidth(screenWidth);
    CGContextAddLineToPoint(ctx, viewCenterWidth-allLineWith, twoY);

    PostMapSingleButView *view2 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth, twoY)];
    [self addSubview:view2];

    // 第三拐
    CGContextAddArc(ctx, viewCenterWidth-allLineWith, twoY+allRate, allRate, ToRadian(-90), ToRadian(90), 1);

    PostMapSingleButView *view3 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth-allLineWith-allRate, twoY+allRate)];
    [self addSubview:view3];

    // 第三横线
    CGFloat thirdY = twoY + allRate*2;
    CGContextAddLineToPoint(ctx, viewCenterWidth+allLineWith, thirdY);

    PostMapSingleButView *view4 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth, thirdY)];
    [self addSubview:view4];

    // 第四拐
    CGContextAddArc(ctx, viewCenterWidth+allLineWith, thirdY+allRate, allRate, ToRadian(-90), ToRadian(90), 0);

    PostMapSingleButView *view5 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth+allLineWith+allRate, thirdY+allRate)];
    [self addSubview:view5];

    // 第四横线
    CGFloat fourY = thirdY + allRate*2;
    CGContextAddLineToPoint(ctx, viewCenterWidth-allLineWith, fourY);

    PostMapSingleButView *view6 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth, fourY)];
    [self addSubview:view6];

    // 第五拐
    CGContextAddArc(ctx, viewCenterWidth-allLineWith, fourY+allRate, allRate, ToRadian(-90), ToRadian(90), 1);

    PostMapSingleButView *view7 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth-allLineWith-allRate, fourY+allRate)];
    [self addSubview:view7];

    // 第五横线
    CGFloat fiveY = fourY+allRate*2;
    CGContextAddLineToPoint(ctx, viewCenterWidth, fiveY);

    PostMapSingleButView *view8 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth, fiveY)];
    [self addSubview:view8];

    CGContextStrokePath(ctx);


}*/

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        _currentIndex = -1;
        _butArray = [NSMutableArray array];
        UIBezierPath *path = [[UIBezierPath alloc] init];

        CGFloat screenWidth = frame.size.width;
        CGFloat screenHeight = frame.size.height;

        CGFloat lineWidth = 7*RateWidth(screenWidth);
        CGFloat viewCenterWidth = screenWidth/2.0;
        CGFloat headerViewHeight = 124*RateHeight(screenHeight);

        CGFloat firstLineHeight = 32.5*RateHeight(screenHeight) + headerViewHeight;
        CGFloat firstRate = 30*RateWidth(screenWidth);
        CGFloat firstLineWidth = 43*RateWidth(screenWidth);
        // 起点
        [path moveToPoint:CGPointMake(viewCenterWidth, headerViewHeight)];

        // 竖直线
        [path addLineToPoint:CGPointMake(viewCenterWidth, firstLineHeight)];
        // 第一拐点
        [path addArcWithCenter:CGPointMake(viewCenterWidth+firstRate, firstLineHeight) radius:firstRate startAngle:ToRadian(-180) endAngle:ToRadian(90) clockwise:0];
        // 第一横线
        [path addLineToPoint:CGPointMake(viewCenterWidth+firstRate+firstLineWidth, firstLineHeight+firstRate)];

        // 第二拐点
        CGFloat allRate = 53*RateHeight(screenHeight);
        [path addArcWithCenter:CGPointMake(viewCenterWidth+firstRate+firstLineWidth, firstLineHeight+firstRate+allRate) radius:allRate startAngle:ToRadian(-90) endAngle:ToRadian(90) clockwise:1];
        // 第二横线
        CGFloat twoY = firstLineHeight+firstRate+allRate*2;
        CGFloat allLineWith = 73*RateWidth(screenWidth);
        [path addLineToPoint:CGPointMake(viewCenterWidth-allLineWith, twoY)];
        // 第三拐点
        [path addArcWithCenter:CGPointMake(viewCenterWidth-allLineWith, twoY+allRate) radius:allRate startAngle:ToRadian(-90) endAngle:ToRadian(90) clockwise:0];
        // 第三横线
        CGFloat thirdY = twoY + allRate*2;
        [path addLineToPoint:CGPointMake(viewCenterWidth+allLineWith, thirdY)];
        // 第四拐点
        [path addArcWithCenter:CGPointMake(viewCenterWidth+allLineWith, thirdY+allRate) radius:allRate startAngle:ToRadian(-90) endAngle:ToRadian(90) clockwise:1];
        // 第四横线
        CGFloat fourY = thirdY + allRate*2;
        [path addLineToPoint:CGPointMake(viewCenterWidth-allLineWith, fourY)];
        // 第五拐点
        [path addArcWithCenter:CGPointMake(viewCenterWidth-allLineWith, fourY+allRate) radius:allRate startAngle:ToRadian(-90) endAngle:ToRadian(90) clockwise:0];
        // 第五横线
        CGFloat fiveY = fourY + allRate*2;
        [path addLineToPoint:CGPointMake(viewCenterWidth, fiveY)];

        CAShapeLayer *layer = CAShapeLayer.new;
        layer.lineWidth = lineWidth;
        layer.path = path.CGPath;
        layer.fillColor = UIColor.clearColor.CGColor;
        layer.strokeColor = UIColor.whiteColor.CGColor;

        // 划线动画取消
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        animation.fromValue = @0;
//        animation.toValue = @1;
//        animation.duration = 5;
//        [layer addAnimation:animation forKey:@""];

        [self.layer addSublayer:layer];
        self.layer.contents = (id)[UIImage imageNamed:@"背景"].CGImage;

        // 添加按钮
        
        PostMapSingleButView *view = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth, firstLineHeight)];
        [self addSubview:view];
        [_butArray addObject:view];
        PostMapSingleButView *view1 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth+firstRate+firstLineWidth+allRate, firstLineHeight+firstRate+allRate)];
        [self addSubview:view1];
        [_butArray addObject:view1];
        PostMapSingleButView *view2 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth, twoY)];
        [self addSubview:view2];
        [_butArray addObject:view2];
        PostMapSingleButView *view3 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth-allLineWith-allRate, twoY+allRate)];
        [self addSubview:view3];
        [_butArray addObject:view3];
        PostMapSingleButView *view4 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth, thirdY)];
        [self addSubview:view4];
        [_butArray addObject:view4];
        PostMapSingleButView *view5 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth+allLineWith+allRate, thirdY+allRate)];
        [self addSubview:view5];
        [_butArray addObject:view5];
        PostMapSingleButView *view6 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth, fourY)];
        [self addSubview:view6];
        [_butArray addObject:view6];
        PostMapSingleButView *view7 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth-allLineWith-allRate, fourY+allRate)];
        [self addSubview:view7];
        [_butArray addObject:view7];
        PostMapSingleButView *view8 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth, fiveY)];
        [self addSubview:view8];
        [_butArray addObject:view8];

        // 增加其余多余的点 -- 其他控制的4个点
        PostMapSingleButView *view9 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth+firstRate+firstLineWidth/2.0, firstLineHeight+firstRate)];
        [self addSubview:view9];
        [_butArray addObject:view9];
        PostMapSingleButView *view10 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth-allLineWith+firstLineWidth/2.0, twoY)];
        [self addSubview:view10];
        [_butArray addObject:view10];
        PostMapSingleButView *view11 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth+allLineWith-firstLineWidth/2.0, thirdY)];
        [self addSubview:view11];
        [_butArray addObject:view11];
        PostMapSingleButView *view12 = [[PostMapSingleButView alloc] initWithPoint:CGPointMake(viewCenterWidth-allLineWith+firstLineWidth/2.0, fourY)];
        [self addSubview:view12];
        [_butArray addObject:view12];

        for (PostMapSingleButView *btn in _butArray) {
            btn.hidden = YES;
            btn.alpha = 0;
            btn.delegate = self;
        }

        [self createBottomView];
    }
    return self;
}
// 显示动画
-(void)animationWithView:(UIView *)view {
    view.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
       view.alpha = 1;
    }];
}
// 当前点的动画 -- 节点的放大缩小  -View其实是PostMapSingleButView
-(void)currentViewAnimationWithView:(UIView *)view {
    PostMapSingleButView *postView = (PostMapSingleButView *)view;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = YES;
    animation.repeatCount = 2.f;//HUGE_VALF;//OC使用MAXFLOAT 或者HUGE_VALF
    animation.duration = 0.7;
    //仅仅设置了fromValue，动画将在fromValue与图层当前值之间渐变
    animation.fromValue = @1;
    animation.toValue = @0.6;
    //函数对动画进行了一次copy，然后把copy的这份添加在了图层上
    [postView.titleBut.layer addAnimation:animation forKey:@"scale"];

}
// 创建底部图例
-(void)createBottomView {

    CGFloat screenWidth = self.frame.size.width;
    CGFloat screenHeight = self.frame.size.height;

    CGFloat firstLeft = 20;
    CGFloat viewHight = 21;
    CGFloat viewWidth = 16+8+70;
    CGFloat space = (screenWidth-20-20-viewWidth*3)/2;
    CGFloat bottom = screenHeight - (16+21)*RateHeight(screenHeight);

    NSArray *images = @[[UIImage imageNamed:@"前序"], [UIImage imageNamed:@"当前"], [UIImage imageNamed:@"晋升"]];
    NSArray *titles = @[NSLocalizableString(@"prefaceJobs", nil), NSLocalizableString(@"currentPosition", nil), NSLocalizableString(@"promotionJob", nil)];
    for (NSInteger i = 0; i < 3; i++) {
        CGRect frame = CGRectMake(firstLeft+i*(viewWidth+space), bottom, viewWidth, viewHight);
        UIView *view = [self createWarnViewWith:frame image:images[i] text:titles[i]];
        [self addSubview:view];
    }
}
-(UIView *)createWarnViewWith:(CGRect)frame image:(UIImage *)image text:(NSString *)text {

    CGFloat screenWidth = self.frame.size.width;
    UIView *view = [[UIView alloc] initWithFrame:frame];

    CGFloat imageWidth = 16*RateWidth(screenWidth);
    CGFloat space = 8*RateWidth(screenWidth);
    CGFloat titleWidth = frame.size.width - imageWidth - space;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (frame.size.height-imageWidth)/2.0, imageWidth, imageWidth)];
    imageView.image = image;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth+space, 0, titleWidth, frame.size.height)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    titleLabel.text = text;

    [view addSubview:imageView];
    [view addSubview:titleLabel];

    return view;
}

-(void)showAlertProgressWith:(CGRect)frame {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addSubview:self.alertProgress];
        [self.alertProgress setViewFrame:frame];
    });
}
-(void)showAgainAlertProgressWith:(CGRect)frame {
    [self addSubview:self.alertProgress];
    [self.alertProgress setViewFrame:frame];
}
#pragma mark - 页面赋值
-(void)setModel:(HICPostMapLineModel *)model {
    _model = model;

    NSInteger totalNum = 9;
    NSArray *detail = model.wayDetail;
    NSMutableArray *nodeModels = [NSMutableArray array];
    NSMutableArray *nodeArray = [NSMutableArray array];
    NSInteger currentIndex = -1;
    // 1. 获取当前节点
    for (NSInteger i = 0; i < detail.count; i++) {
        MapLineInfoModel *info = detail[i];
        if (info.isCurrentNode == 1) {
            currentIndex = i;
            break;
        }
    }
    if (self.butArray.count < 13) {
        // 标注小于13个点的话，下边会出错，过滤掉 -- 只显示线路和背景
        return;
    }
    // 数据是从下往上的， 标点是从上往下的
    // 此时地图的标点多于数据返回的
    if (detail.count < totalNum && detail.count != 0) {
        NSInteger index = detail.count - 1;
        if (index == 0) {
            // 表示只有一个点， 直接取最后一个点
            [nodeArray addObject:self.butArray[8]];
        }else if (index == 1) {
            // 表示只有两个点
            [nodeArray addObject:self.butArray[8]];
            [nodeArray addObject:self.butArray[2]];
        }else if (index == 2) {
            [nodeArray addObject:self.butArray[8]];
            [nodeArray addObject:self.butArray[4]];
            [nodeArray addObject:self.butArray[0]];
        }else if (index == 3) {
            [nodeArray addObject:self.butArray[8]];
            [nodeArray addObject:self.butArray[5]];
            [nodeArray addObject:self.butArray[3]];
            [nodeArray addObject:self.butArray[0]];
        }else if (index == 4) {
            [nodeArray addObject:self.butArray[8]];
            [nodeArray addObject:self.butArray[12]];
            [nodeArray addObject:self.butArray[11]];
            [nodeArray addObject:self.butArray[10]];
            [nodeArray addObject:self.butArray[9]];
        }else if (index == 5) {
            [nodeArray addObject:self.butArray[8]];
            [nodeArray addObject:self.butArray[12]];
            [nodeArray addObject:self.butArray[11]];
            [nodeArray addObject:self.butArray[10]];
            [nodeArray addObject:self.butArray[1]];
            [nodeArray addObject:self.butArray[0]];
        }else if (index == 6) {
            [nodeArray addObject:self.butArray[8]];
            [nodeArray addObject:self.butArray[7]];
            [nodeArray addObject:self.butArray[12]];
            [nodeArray addObject:self.butArray[5]];
            [nodeArray addObject:self.butArray[11]];
            [nodeArray addObject:self.butArray[10]];
            [nodeArray addObject:self.butArray[9]];
        }else if (index == 7) {
            [nodeArray addObject:self.butArray[8]];
            [nodeArray addObject:self.butArray[7]];
            [nodeArray addObject:self.butArray[6]];
            [nodeArray addObject:self.butArray[5]];
            [nodeArray addObject:self.butArray[4]];
            [nodeArray addObject:self.butArray[3]];
            [nodeArray addObject:self.butArray[2]];
            [nodeArray addObject:self.butArray[0]];
        }else {
            // 表示大于八个点 - 应进入下一个循环的 -- 此处不处理
//            index -= 1;
//            NSInteger modelCount = detail.count-1-2;
//            [nodeArray addObject:self.butArray.lastObject];
//            for (NSInteger i = modelCount+(7-modelCount)/2+1; i >= (7-modelCount)/2+1  ; i--) {
//                [nodeArray addObject:self.butArray[i]];
//            }
//            [nodeArray addObject:self.butArray.firstObject];
        }
    }else if (detail.count == totalNum) {
        // 当前正好 9个标点
        NSInteger index = totalNum - 1;
        for (NSInteger i = 0; i <= index; i++) {
            [nodeArray addObject:self.butArray[index-i]];
        }
    }else if (detail.count > totalNum) {
        for (NSInteger i = 8; i >= 0; i--) {
            [nodeArray addObject:self.butArray[i]];
        }
        // 当前大于 9个标点  --
        if (currentIndex == -1) {
            // 没有当前节点
            for (NSInteger i = 0; i < totalNum; i++) {
                [nodeModels addObject:detail[i]];
            }
        }else {
            // 当前节点 前后截取
            NSInteger willIndex = detail.count - 1 - currentIndex;
            if (willIndex >= totalNum - 1) {
                // 当前节点的后续节点超过 9个
                for (NSInteger i = currentIndex; i < totalNum+currentIndex; i++) {
                    [nodeModels addObject:detail[i]];
                }
                currentIndex = 0;
            }else {
                // 当前节点的后续少于 9个
                NSInteger didIndex = currentIndex - (totalNum - willIndex - 1) ;
                for (NSInteger i = didIndex; i < detail.count; i++) {
                    [nodeModels addObject:detail[i]];
                }
                currentIndex = totalNum - 1 - willIndex;
            }
            
        }
    }
    if (nodeModels.count != 0) {
        // 当前节点的模型数据存在
        detail = [nodeModels copy];
    }

    if (detail.count < nodeArray.count) {
        DDLogDebug(@"节点出错");
        return;
    }
    // 最后显示节点
    _currentIndex = currentIndex;
    _showButArray = nodeArray;
    NSInteger index = 0;
    for (PostMapSingleButView *view in nodeArray) {
        MapLineInfoModel *infoModel = detail[index];
        view.infoModel = infoModel;
        BOOL isClickAll = model.isShowAll == 0? YES:NO;
        if (currentIndex == -1) {
            // 没有当前节点
            view.type = 2;
            if (isClickAll) {
                view.isClickDidNode = YES;
            }else {
                if (index == 0) {
                    view.isClickDidNode = YES;
                }else {
                    view.isClickDidNode = NO;
                }
            }


        }else {
            // 存在当前节点
            if (index < currentIndex) {
                view.type = 0;
            }else if (index == currentIndex) {
                view.type = 1;
                [self showAlertProgressWith:view.frame];
                self.alertProgress.progress = infoModel.taskProgress;
                [self currentViewAnimationWithView:view];
            }else {
                view.type = 2;
            }
            if (isClickAll) {
                view.isClickDidNode = YES;
            }else {
                view.isClickDidNode = NO;
                if (index == currentIndex) {
                    view.isClickDidNode = YES;
                }else if (index == currentIndex+1) {
                    // 后续一个节点
                    view.isClickDidNode = YES;
                }
            }
        }
        index++;
//        [self performSelector:@selector(animationWithView:) withObject:view afterDelay:4];
        [self animationWithView:view];
    }
    
}
-(void)setIsShowCurrentProgress:(BOOL)isShowCurrentProgress {
    _isShowCurrentProgress = isShowCurrentProgress;
    if (isShowCurrentProgress) {
        if (self.currentIndex != -1 && self.currentIndex < self.showButArray.count) {
            UIView *view = [self.showButArray objectAtIndex:self.currentIndex];
            [self showAgainAlertProgressWith:view.frame];
        }
    }
}

-(void)setRefreshModel:(HICPostMapLineModel *)refreshModel {
    _refreshModel = refreshModel;
    // 重置数据
    self.currentIndex = -1;
    _showButArray = @[];
    for (PostMapSingleButView *btn in _butArray) {
        btn.hidden = YES;
        btn.alpha = 0;
    }

    self.model = refreshModel; // 去调用setModel的方法重新加载点
}

#pragma mark - 节点的协议方法
-(void)singleButView:(PostMapSingleButView *)view clickBut:(UIButton *)but type:(NSInteger)type itemModel:(MapLineInfoModel *)infoModel other:(id)data {

    if ([self.delegate respondsToSelector:@selector(lineView:didClickNode:type:other:)]) {
        [self.delegate lineView:self didClickNode:infoModel type:type other:data];
    }
}

#pragma mark - 懒加载
-(PostMapAlertProgressView *)alertProgress {
    if (!_alertProgress) {
        _alertProgress = [[PostMapAlertProgressView alloc] initWithFrame:CGRectZero];
    }
    return _alertProgress;
}

@end
