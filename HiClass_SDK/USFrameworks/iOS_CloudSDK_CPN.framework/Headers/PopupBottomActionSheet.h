//
//  PopupBottomActionSheet.h
//  iOSEdu
//
//  Created by 王继伟 on 2017/1/5.
//  Copyright © 2017年 Hisense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "ItemCell.h"

@protocol DownSheetDelegate <NSObject>

-(void)didSelectIndex : (NSInteger) index;
@end

@interface PopupBottomActionSheet : UIView

@property (nonatomic , assign) id<DownSheetDelegate> delegate;

-(id)initWithList : (NSArray *)list title : (NSString *) title;

-(void) showInView : (UIViewController *)controller;

@property (nonatomic , strong) UITableView *tableview;
@end
