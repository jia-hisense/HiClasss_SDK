//
//  HICMediaInfoModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/27.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICMediaInfoModel : NSObject
/**
            "fileId":"long,媒资文件ID",
          "fileType":"integer,是否原文件：0-否  1-是",
          "type":"integer,媒资文件类型（0-图片，1-视频，2-音频，3-文档，4-压缩包，5-scrom,6-html）",
          "definition":"integer,清晰度类型：11-标清 21-高清 31-超清 41-4K",
          "suffixName":"string,文件后缀名（fileType=1适用））",
          "url":"string,具体URL",
          "size":"long,文件大小（单位：byte）",
          "totalNumber":"long,总时长/总页数（时长单位：ms）"

*/
@property (nonatomic ,strong)NSNumber *fileId;//long,媒资文件ID",
@property (nonatomic ,strong)NSNumber *size;//long,文件大小（单位：byte）"
@property (nonatomic ,strong)NSNumber *totalNumber;//long,总时长/总页数（时长单位：ms)
@property (nonatomic ,assign)NSInteger fileType;//"integer,是否原文件：0-否  1-是",
@property (nonatomic ,assign)NSInteger type;//媒资文件类型（0-图片，1-视频，2-音频，3-文档，4-压缩包，5-scrom,6-html）
@property (nonatomic ,assign)NSInteger definition;//:"integer,清晰度类型：11-标清 21-高清 31-超清 41-4K",
@property (nonatomic ,strong)NSString *suffixName;//string,文件后缀名（fileType=1适用）
@property (nonatomic ,strong)NSString *url;//,文件大小（单位：byte）",
@end


NS_ASSUME_NONNULL_END
