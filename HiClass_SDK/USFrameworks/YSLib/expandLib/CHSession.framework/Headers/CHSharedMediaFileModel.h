//
//  CHSharedMediaFileModel.h
//  CHSession
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHSharedMediaFileModel : NSObject

@property (nonatomic, assign) CHMediaState state;

/// url
@property (nonatomic, strong) NSString *fileUrl;

/// Id
@property (nonatomic, strong) NSString *fileId;
/// 文件名
@property (nonatomic, strong) NSString *fileName;

/// 发送者Id
@property (nonatomic, strong) NSString *senderId;

/// 媒体流设备Id
//@property (nonatomic, strong) NSString *sourceId;

/// 媒体流Id
@property (nonatomic, strong) NSString *streamId;

///视频类型
@property (nonatomic, assign) CloudHubMediaType mediaType;

/// 是否视频
@property (nonatomic, assign) BOOL isVideo;

/// 是否暂停
//@property (nonatomic, assign) BOOL pause;

/// 视频尺寸
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

/// 时长，单位：毫秒
@property (nonatomic, assign) NSUInteger duration;
@property (nonatomic, assign) NSUInteger pos;

@property (nonatomic, assign) BOOL isBeforeClassBeigin;

+ (nullable instancetype)sharedMediaFileModelWithDic:(NSDictionary *)dic;
- (void)updateWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
