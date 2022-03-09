//
//  CKMenuTypeCell.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/12.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CKMenuTypeCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *cellIndexPath;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) NSString *titleStr;

@end

NS_ASSUME_NONNULL_END
