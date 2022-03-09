//
//  CHWhiteBoardUtil.h
//  CHWhiteBoard
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHWhiteBoardUtil : NSObject

+ (BOOL)pubWhiteBoardMsg:(NSString *)msgName
                  msgID:(NSString *)msgID
                   data:(NSDictionary * _Nullable)dataDic
          extensionData:(NSDictionary * _Nullable)extensionData
        associatedMsgID:(NSString * _Nullable)associatedMsgID;

+ (BOOL)delWhiteBoardMsg:(NSString *)msgName
                  msgID:(NSString *)msgID
                   data:(NSObject * _Nullable)data;

+ (nullable NSString *)getFileIdFromSourceInstanceId:(NSString *)sourceInstanceId;
+ (NSString *)getSourceInstanceIdFromFileId:(nullable NSString *)fileId;
+ (NSString *)getwhiteboardIdFromFileId:(nullable NSString *)fileId;

+ (NSString *)absoluteFileUrl:(NSString*)fileUrl withServerDic:(NSDictionary *)serverDic;


#if 0

+ (NSString *)change_WithUserId:(NSString *)userId;
+ (NSString *)unchange_WithUserId:(NSString *)userId;

#endif

@end

NS_ASSUME_NONNULL_END
