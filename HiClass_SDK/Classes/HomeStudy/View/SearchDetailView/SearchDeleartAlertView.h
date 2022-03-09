//
//  SearchDeleartAlertView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickAlertSure)(void);
@interface SearchDeleartAlertView : UIView

@property (nonatomic, copy) ClickAlertSure clickSureBlock;

@end

NS_ASSUME_NONNULL_END
