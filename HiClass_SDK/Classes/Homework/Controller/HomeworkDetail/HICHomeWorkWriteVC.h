//
//  HICHomeWorkWriteVC.h
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeworkDetailModel.h"
#import "HICHomeWorkDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeworkImageModel : NSObject

/// 是否是撤回从新提交的， 是的情况下，保留数据
@property (nonatomic, assign) BOOL isAgainWrite;

/// 撤回重新编辑的类型
@property (nonatomic, assign) HICHomeworkAgainFileType againFileType;

/// 资源类型
@property (nonatomic, assign) HMBMessageFileType type;

/// 资源路径 -- 语音和视频使用
@property (nonatomic, copy) NSString *filePath;

/// 图片资源中的图片 
@property (nonatomic, strong) UIImage *image;

/// 图片的名称
@property (nonatomic, copy) NSString *imageName;

/// 上传文件的返回字典
@property (nonatomic, strong) NSDictionary *fileDic;

@property (nonatomic, strong) HomeworkDetailAttachmentModel *attachmentModel;

/// 构造方法
/// @param type 资源类型
/// @param filePath 资源路径
/// @param image 图片信息
+(instancetype)createModelWith:(HMBMessageFileType)type filePath:(NSString * _Nullable)filePath image:(UIImage * _Nullable)image;

@end


@interface HICHomeWorkWriteVC : UIViewController

/// 1：视频，2：音频，3：文字，4：图片
@property (nonatomic, strong) NSArray *toolBars;

@property (nonatomic, strong) HomeworkDetailModel *detailModel;

@property (nonatomic, weak) HICHomeWorkDetail *detailVC;

@property (nonatomic, assign) BOOL isAgainWrite;

@end

NS_ASSUME_NONNULL_END
