//
//  HomeWebViewModel.m
//  HiClass
//
//  Created by wangggang on 2020/1/13.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeWebViewModel.h"

@implementation HomeWebViewModel

-(instancetype)init {

    if (self = [super init]) {
        _userConfigNames = [NSMutableArray array]; // 初始化
    }

    return self;
}

-(void)setDefaultConfigNames {

    // 1. 文件上传的接口名称
    [self.userConfigNames addObject:@"uploadImg"];
    // 2. 默认的接口
    [self.userConfigNames addObjectsFromArray:@[@"finish", @"getCustomerId", @"getToken", @"getCustomName", @"openH5Url", @"setStatusBarColor", @"getAppVersion", @"getAppVersionCode", @"getAppVersionName", @"getAppPackageName", @"startExam", @"finishExam", @"getDeviceId", @"startLogin", @"startNativePage", @"getWebSDKVersion",@"jumpToMyCertificate"]];
}

#pragma mark - 网络请求方法
// 1. 图片上传借口
-(void)sendH5SaveImageToSeverWith:(NSDictionary *)parames data:(id)data success:(nonnull void (^)(BOOL, id _Nullable, NSDictionary * _Nonnull))success {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *mArr = [NSMutableArray array];

        // 判断是否为图片数组，是的话循环上传数据，后统一的返回给H5
        if ([data isKindOfClass:NSArray.class]) {
            NSArray *images = (NSArray *)data;
            for (UIImage *image in images) {
                NSDictionary *resDic = [self loadDataWith:[NSString stringWithFormat:@"%@/heduapi/app_api/v1.0/fileUpload",APP_UPLOAD_DOMAIN] parames:parames image:image];
                if (resDic.allKeys.count != 0) {
                    // 字典是否存在key：Value键值对
                    [mArr addObject:resDic];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (mArr.count == images.count) {
                    // 证明此时的 上传数据和获取的图片数据保存是一致的，因此可以统一的回复
                    success(YES, [mArr copy], parames);
                }else {
                    success(NO, [mArr copy], parames);
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 传递过来的参数就不正确
                success(NO, nil, parames);
            });
        }
    });

}

-(NSDictionary *)loadDataWith:(NSString *)urlStr parames:(NSDictionary *)parames image:(UIImage *)image {

    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];

    NSString *paramUrl = [NSString stringWithFormat:@"%@?fileType=1&examId=%@",urlStr, [parames objectForKey:@"examId"]?[parames objectForKey:@"examId"]:@""];
    NSURL *reqURL = [NSURL URLWithString: paramUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:reqURL];

    NSString *boundary = @"wfWiEWrgEFA9A78512weF7106A";
    request.HTTPMethod = @"POST";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = 30.f;

    NSData *imageData = [self imageCompressToData:image withSize:1];

    NSMutableData *paramData = [NSMutableData data];
    NSString *fileName = @"image.png";
    NSString *fileKey = @"fileData";
    NSString *filePair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n",boundary,fileKey,fileName];
    [paramData appendData:[filePair dataUsingEncoding:NSUTF8StringEncoding]];
    [paramData appendData:imageData]; //加入文件的数据
    [paramData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //设置结尾
    [paramData appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody = paramData;
    //设置请求头总数据长度
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)paramData.length] forHTTPHeaderField:@"Content-Length"];

    // 上传
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task;

    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // 解析数据
            NSError *jsonError;
            NSDictionary *pesDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            if (!jsonError) {
                // 正确的解析道服务器数据
                NSNumber *code = [pesDic objectForKey:@"resultCode"];
                if (code.integerValue == 0) {
                    // 此时上传文件成功 -- 失败的情况都不做处理， 返回的数据字典keys值为空
                    NSArray *array = [pesDic objectForKey:@"data"];
//                    NSArray *array = [data objectForKey:@"uploadFileList"];
                    if (array && [array isKindOfClass:NSArray.class] && array.count != 0) {
                        [mDic setDictionary:array.firstObject];
                    }else {
                        DDLogError(@"[WebSDK] -- 上传图片失败,返回的数据类型不正确：%@", pesDic);
                    }

                }
            }
        } else {
            DDLogError(@"[WebSDK] -- 上传图片失败：%@", error);
        }
        dispatch_semaphore_signal(sema);
    }];

    [task resume];

    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return [mDic copy];
}

///压缩图片
-(NSData *)imageCompressToData:(UIImage *)image withSize:(CGFloat)size{
  CGFloat compression = 1;
    NSData *data = [[NSData alloc] init];
    if ([image isKindOfClass:UIImage.class]) {
        data = UIImageJPEGRepresentation(image, compression);
        while (data.length > size*1024*1024 && compression > 0) {
            compression -= 0.09;
            data = UIImageJPEGRepresentation(image, compression); // When compression less than a value, this code dose not work
        }
    }
  return data;
}

@end
