//
//  HICNetModel.m
//  HiClass
//
//  Created by Eddie Ma on 2020/1/2.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICNetModel.h"

@interface HICNetModel()
@property (readwrite) NSString *url;
@property (readwrite) NSDictionary *params;
@end

@implementation HICNetModel

- (instancetype)initWithURL:(NSString *)url params:(NSDictionary * _Nullable)dic {
    if (self = [super init]) {
        self.url = url;
        self.params = dic;
    }
    return self;
}

@end
