//
//  NSAttributedString+HICAttributedStr.h
//  HiClass
//
//  Created by 铁柱， on 2020/1/16.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (HICAttributedStr)
+(NSAttributedString *)stringInsertImageWithImageName:(NSString *)imageName imageReact:(CGRect)imageReact content:(NSString *)content stringColor:(UIColor *)stringColor stringFont:(UIFont *)stringFont;
@end

NS_ASSUME_NONNULL_END
