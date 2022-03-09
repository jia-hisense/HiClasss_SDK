//
//  GradientView.m
//  
//
//  Created by 尚轩瑕 on 2017/12/10.
//

#import "GradientView.h"

@interface GradientView ()

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GradientView

- (GradientView *)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        [self.layer addSublayer:self.gradientLayer];
        
        self.gradientLayer.startPoint = CGPointMake(0, 0);
        self.gradientLayer.endPoint = CGPointMake(1, 0);
    }
    return self;
}

- (void)setGradientLayerColors:(NSArray *)gradientLayerColors {
    _gradientLayerColors = gradientLayerColors;
    self.gradientLayer.colors = gradientLayerColors;
}

- (void)setGradientLayerLocations:(NSArray *)gradientLayerLocations {
    _gradientLayerLocations = gradientLayerLocations;
    self.gradientLayer.locations = gradientLayerLocations;
}

-(instancetype)initWithImage:(UIImage *)image andFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
        _imageView.image = image;
    }
    return self;
}


@end
