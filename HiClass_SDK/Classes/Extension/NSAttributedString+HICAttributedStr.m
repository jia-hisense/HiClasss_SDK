//
//  NSAttributedString+HICAttributedStr.m
//  HiClass
//
//  Created by 铁柱， on 2020/1/16.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "NSAttributedString+HICAttributedStr.h"
@implementation NSAttributedString (HICAttributedStr)
+(NSAttributedString *)stringInsertImageWithImageName:(NSString *)imageName imageReact:(CGRect)imageReact content:(NSString *)content stringColor:(UIColor *)stringColor stringFont:(UIFont *)stringFont{
    //创建富文本
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:7];
    //修改富文本中的文字样式文本颜色,文本大小
    [attributedStr addAttributes:@{NSForegroundColorAttributeName:stringColor,NSFontAttributeName:stringFont,NSParagraphStyleAttributeName:paragraphStyle}  range:NSMakeRange(0, content.length)];
    //创建文本附件图片 插入到富文本中
    NSTextAttachment *attchImage = [[NSTextAttachment alloc]init];
    attchImage.image = [UIImage imageNamed:imageName];
    attchImage.bounds = imageReact;
    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
//    [attributedStr appendAttributedString:stringImage];//在文字最后添加图片
    //图片插入位置
    [attributedStr insertAttributedString:stringImage atIndex:0];
    return attributedStr;
}
@end
