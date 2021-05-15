//
//  MessageTool.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/13.
//

#import "MessageTool.h"

#define HISTORYPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"history.archive"]

#define LIKEPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"like.archive"]

#define LAUNCHPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"launch.archive"]

@implementation MessageTool

#pragma mark - 将模型数组转化为NSData
+ (NSData *)getDataWithMessageArray:(NSMutableArray *)messageArray {
    NSMutableArray *array = [NSMutableArray array];
    
    for (WeiboMessage *message in messageArray) {
        //转成字典储存
        //用户
        NSDictionary *userDict = [message.user dictionaryWithValuesForKeys:@[@"screen_name", @"profile_image_url"]];
        
        NSDictionary *messageDict = @{
            @"id"               : message.ID,
            @"text"             : message.text ? message.text : @"",    //防止传入为nil
            @"created_at"       : message.created_at,
            @"source"           : message.source ? message.source : @"",
            @"user"             : userDict,
            @"reposts_count"    : message.reposts_count,
            @"comments_count"   : message.comments_count,
            @"attitudes_count"  : message.attitudes_count,
            @"thumbnail_pic"    : message.thumbnail_pic ? message.thumbnail_pic : @"",
            @"bmiddle_pic"      : message.bmiddle_pic ? message.bmiddle_pic : @"",
            @"original_pic"     : message.original_pic ? message.original_pic : @"",
            @"pic_ids"          : message.pic_ids ? message.pic_ids : @""
        };
        
        [array addObject:messageDict];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    
    return data;
}


#pragma mark - 将单个模型转化为data
+ (NSData *)getDataWithMessage:(WeiboMessage *)message {
    //转成字典储存
    //用户
    NSDictionary *userDict = [message.user dictionaryWithValuesForKeys:@[@"screen_name", @"profile_image_url"]];
    
    NSDictionary *messageDict = @{
        @"id"               : message.ID,
        @"text"             : message.text ? message.text : @"",    //防止传入为nil
        @"created_at"       : message.created_at,
        @"source"           : message.source ? message.source : @"",
        @"user"             : userDict,
        @"reposts_count"    : message.reposts_count,
        @"comments_count"   : message.comments_count,
        @"attitudes_count"  : message.attitudes_count,
        @"thumbnail_pic"    : message.thumbnail_pic ? message.thumbnail_pic : @"",
        @"bmiddle_pic"      : message.bmiddle_pic ? message.bmiddle_pic : @"",
        @"original_pic"     : message.original_pic ? message.original_pic : @"",
        @"pic_ids"          : message.pic_ids ? message.pic_ids : @""
    };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:messageDict options:NSJSONWritingPrettyPrinted error:nil];
    
    return data;
}


#pragma mark — 将data转化为单个模型
+ (WeiboMessage *)messageWithData:(NSData *)data {
    NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    WeiboMessage *message = [WeiboMessage messageWithDictionary:messageDict];
    
    return message;
}


#pragma mark - 将data转化为模型数组
+ (NSMutableArray *)messageArrayWithData:(NSData *)data {
    NSMutableArray *messageArray = [NSMutableArray array];
    
    if (data != nil) {  //判断解档的数据是否为空
        NSMutableArray *multableArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
        //数据格式转化
        for (NSDictionary *dict in multableArray) {
            WeiboMessage *message = [WeiboMessage messageWithDictionary:dict];
            [messageArray addObject:message];
        }
    
        NSLog(@"解档_浏览历史");
        NSLog(@"%@",HISTORYPATH);
    }
    return messageArray;
}


#pragma mark - 历史记录
//储存历史记录
+ (void)saveHistoryMessage:(NSMutableArray *)historyMessageArray {
    //将数组转为NSData
    NSData *data = [MessageTool getDataWithMessageArray:historyMessageArray];
    
    [data writeToFile:HISTORYPATH atomically:YES];
    
    NSLog(@"归档_浏览历史");
}

//读取浏览历史
+ (NSMutableArray *)historyMessageArray {
    //解档获取数据
    NSData *data = [NSData dataWithContentsOfFile:HISTORYPATH];
    //转为数组
    NSMutableArray *historyMessageArray = [MessageTool messageArrayWithData:data];
    
    return historyMessageArray;
}


#pragma mark - 我的发表
//储存我的发表
+ (void)saveLaunchMessage:(NSMutableArray *)launchMessageArray {
    
    NSData *data = [MessageTool getDataWithMessageArray:launchMessageArray];
    
    [data writeToFile:LAUNCHPATH atomically:YES];
    
    NSLog(@"归档_我的发表");
}

//读取我的发表
+ (NSMutableArray *)launchMessageArray {
    NSData *data = [NSData dataWithContentsOfFile:LAUNCHPATH];
    
    NSMutableArray *launchMessageArray = [MessageTool messageArrayWithData:data];
    
    NSLog(@"解档_我的发表");
    return launchMessageArray;
}


#pragma mark - 我的收藏
//储存我的收藏
+ (void)saveLikeMessage:(NSMutableArray *)likeMessageArray {
    NSData *data = [MessageTool getDataWithMessageArray:likeMessageArray];
    
    [data writeToFile:LIKEPATH atomically:YES];
    
    NSLog(@"归档_我的收藏");
}

//读取我的收藏
+ (NSMutableArray *)likeMessageArray {
    NSData *data = [NSData dataWithContentsOfFile:LIKEPATH];
    
    NSMutableArray *likeMessageArray = [MessageTool messageArrayWithData:data];
    
    NSLog(@"解档_我的收藏");
    return likeMessageArray;
}
@end
