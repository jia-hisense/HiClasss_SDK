//
//  HiWebViewPerson.m
//  HiClass
//
//  Created by WorkOffice on 2020/1/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HiWebViewPerson.h"

@implementation HiWebViewPerson

static HiWebViewPerson *_inst;
+(instancetype)sharePerson {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inst = [HiWebViewPerson new];
    });
    return _inst;
}

@end
