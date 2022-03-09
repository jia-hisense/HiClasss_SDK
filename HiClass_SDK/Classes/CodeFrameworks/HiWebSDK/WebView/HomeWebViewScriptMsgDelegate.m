//
//  HomeWebViewScriptMsgDelegate.m
//  HiClass
//
//  Created by WorkOffice on 2020/1/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeWebViewScriptMsgDelegate.h"

@implementation HomeWebViewScriptMsgDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate
{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
