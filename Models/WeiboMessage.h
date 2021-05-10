//
//  WeiboMessage.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/9.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN


///微博数据模型
@interface WeiboMessage : NSObject

//微博信息内容
@property (nonatomic, strong)NSString *text;

//微博创建时间
@property (nonatomic, strong)NSString *created_at;

//微博来源
@property (nonatomic, strong)NSString *source;

//发布者
@property (nonatomic, strong)UserModel *user;

//转发数
@property (nonatomic, strong)NSNumber *reposts_count;

//评论数
@property (nonatomic, strong)NSNumber * comments_count;

//点赞数
@property (nonatomic, strong)NSNumber *attitudes_count;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+(instancetype)messageWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
