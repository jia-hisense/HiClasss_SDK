//
//  HICWeakScriptMessageDelegate.m
//  HiClass
//
//  Created by jiafujia on 2021/9/10.
//  Copyright © 2021 hisense. All rights reserved.
//

#import "HICWeakScriptMessageDelegate.h"

@implementation HICWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
