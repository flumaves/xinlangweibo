//
//  MessageTool.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/13.
//

#import <Foundation/Foundation.h>
#import "WeiboMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageTool : NSObject

//储存浏览历史
+ (void)saveHistoryMessage:(NSMutableArray *)historyMessageArray;

//读取浏览历史
+ (NSMutableArray *)historyMessageArray;

//储存我的发表
+ (void)saveLaunchMessage:(NSMutableArray *)launchMessageArray;

//读取我的发表
+ (NSMutableArray *)launchMessageArray;

//储存我的收藏
+ (void)saveLikeMessage:(NSMutableArray *)likeMessageArray;

//读取我的收藏
+ (NSMutableArray *)likeMessageArray;

//储存照片且返回储存照片的路径
+ (NSString *)saveImageWithData:(NSData *)data;

//根据提供的路径返回data数据
+ (NSData *)getImageDataWithURLString:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
