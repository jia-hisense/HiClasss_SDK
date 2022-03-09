//
//  CompanyKnowledgeMenuTypeView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ChangeTypeName)(NSInteger index, NSString *changeName);
@interface CompanyKnowledgeMenuTypeView : UIView

@property (nonatomic, copy) ChangeTypeName changeIndexBlock;

@end

NS_ASSUME_NONNULL_END
