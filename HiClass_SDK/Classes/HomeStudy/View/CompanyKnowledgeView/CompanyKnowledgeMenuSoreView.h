//
//  CompanyKnowledgeMenuClassSoreView.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ChangeSoreName)(NSInteger index, NSString *changeName);
@interface CompanyKnowledgeMenuSoreView : UIView

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, copy) ChangeSoreName changeIndexBlock;

@end

NS_ASSUME_NONNULL_END
