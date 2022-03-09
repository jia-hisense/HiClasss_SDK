//
//  CompanyKnowledgeMenuTimeView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ChangeTitleName)(NSInteger index, NSString *changeName);
@interface CompanyKnowledgeMenuTimeView : UIView

@property (nonatomic, copy) ChangeTitleName changeIndexBlock;

@end

NS_ASSUME_NONNULL_END
