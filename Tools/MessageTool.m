//
//  MessageTool.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/13.
//

#import "MessageTool.h"
#import "UserAccountTool.h"
#import "UserAccount.h"

#define IMAGEPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"image.archive"]

@interface MessageTool ()
//储存登陆的账户
@property (nonatomic, strong)UserAccount *account;

@end

@implementation MessageTool

- (UserAccount *)account {
    if (_account == nil) {
        _account = [UserAccountTool account];
    }
    return _account;
}


#pragma mark - 获取存储的路径
//浏览历史
- (NSString *)getHistoryPath {
    NSString *string = [NSString stringWithFormat:@"%@_history.archive",self.account.uid];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:string];
    
    return path;
}

+ (NSString *)getHistoryPath {
    MessageTool *tool = [[MessageTool alloc] init];
    NSString *path = [tool getHistoryPath];
    return path;
}

//我的发表
- (NSString *)getLaunchPath {
    NSString *string = [NSString stringWithFormat:@"%@_launch.archive",self.account.uid];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:string];
    
    return path;
}

+ (NSString *)getLaunchPath {
    MessageTool *tool = [[MessageTool alloc] init];
    NSString *path = [tool getLaunchPath];
    return path;
}

//我的收藏
- (NSString *)getLikePath {
    NSString *string = [NSString stringWithFormat:@"%@_like.archive",self.account.uid];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:string];
    
    return path;
}

+ (NSString *)getLikePath {
    MessageTool *tool = [[MessageTool alloc] init];
    NSString *path = [tool getLikePath];
    return path;
}


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
            @"pic_urls"          : message.pic_urls ? message.pic_urls : @"",
            @"likeMessage"      : message.likeMessage
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
        @"pic_urls"          : message.pic_urls ? message.pic_urls : @"",
        @"likeMessage"      : message.likeMessage
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
    }
    return messageArray;
}


#pragma mark - 历史记录
//储存历史记录
+ (void)saveHistoryMessage:(NSMutableArray *)historyMessageArray {
    //将数组转为NSData
    NSData *data = [MessageTool getDataWithMessageArray:historyMessageArray];
    
    [data writeToFile:[self getHistoryPath] atomically:YES];
    
    NSLog(@"归档_浏览历史");
    NSLog(@"%@",[self getHistoryPath]);
}

//读取浏览历史
+ (NSMutableArray *)historyMessageArray {
    //解档获取数据
    NSData *data = [NSData dataWithContentsOfFile:[self getHistoryPath]];
    //转为数组
    NSMutableArray *historyMessageArray = [MessageTool messageArrayWithData:data];
    
    NSLog(@"解档_浏览历史");
    
    return historyMessageArray;
}


#pragma mark - 我的发表
//储存我的发表
+ (void)saveLaunchMessage:(NSMutableArray *)launchMessageArray {
    
    NSData *data = [MessageTool getDataWithMessageArray:launchMessageArray];
    
    [data writeToFile:[self getLaunchPath] atomically:YES];
    
    NSLog(@"归档_我的发表");
    NSLog(@"%@",[self getLaunchPath]);
}

//读取我的发表
+ (NSMutableArray *)launchMessageArray {
    NSData *data = [NSData dataWithContentsOfFile:[self getLaunchPath]];
    
    NSMutableArray *launchMessageArray = [MessageTool messageArrayWithData:data];
    
    NSLog(@"解档_我的发表");
    return launchMessageArray;
}


#pragma mark - 我的收藏
//储存我的收藏
+ (void)saveLikeMessage:(NSMutableArray *)likeMessageArray {
    NSData *data = [MessageTool getDataWithMessageArray:likeMessageArray];
    
    [data writeToFile:[self getLikePath] atomically:YES];
    
    NSLog(@"归档_我的收藏");
    NSLog(@"%@",[self getLikePath]);
}

//读取我的收藏
+ (NSMutableArray *)likeMessageArray {
    NSData *data = [NSData dataWithContentsOfFile:[self getLikePath]];
    
    NSMutableArray *likeMessageArray = [MessageTool messageArrayWithData:data];
    
    NSLog(@"解档_我的收藏");
    return likeMessageArray;
}


#pragma mark - 照片的存储
+ (void)saveImage:(NSData *)data {
    [data writeToFile:IMAGEPATH atomically:YES];
    
}

+ (NSURL *)getImageURL {
    return [NSURL URLWithString:IMAGEPATH];
}
@end
