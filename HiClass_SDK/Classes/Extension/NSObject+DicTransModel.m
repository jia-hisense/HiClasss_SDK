//
//  NSObject+DicTransModel.m
//  HiClass
//
//  Created by 铁柱， on 2020/1/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "NSObject+DicTransModel.h"
#import <objc/runtime.h>


@implementation NSObject (DicTransModel)
+ (NSArray *)propertList
{
    unsigned int count = 0;
   //获取模型属性, 返回值是所有属性的数组 objc_property_t
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    NSMutableArray *arr = [NSMutableArray array];
    //便利数组
    for (int i = 0; i< count; i++) {
    //获取属性
    objc_property_t property = propertyList[i];
    //获取属性名称
    const char *cName = property_getName(property);
    NSString *name = [[NSString alloc]initWithUTF8String:cName];
    //添加到数组中
    [arr addObject:name];
    }
    //释放属性组
    free(propertyList);
    return arr.copy;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict {
   
    id obj = [self new];
    // 遍历属性数组
    for (NSString *property in [dict allKeys]) {
        // 判断字典中是否包含这个key
        if ([property isEqualToString: @"id"]) {
             [obj setValue:dict[property] forKey:property];
        } else {
            if ([HICCommonUtils isValidObject:dict[property]] && [[self propertList] containsObject:property]) {
                // 使用 KVC 赋值
                [obj setValue:dict[property] forKey:property];
            }
        }
        
    }
       
    return obj;
}
+(instancetype)modelWithDictArr:(NSMutableArray *)dictArr {
    id obj = [self new];
    for (int i = 0; i < dictArr.count; i ++) {
           // 遍历属性数组
           for (NSString *property in [self propertList]) {
           // 判断字典中是否包含这个key
           if (dictArr[i][property]) {
               // 使用 KVC 赋值
               [obj setValue:dictArr[i][property] forKey:property];
               }
           }
    }
    return obj;
}
@end
