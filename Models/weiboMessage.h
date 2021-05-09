//
//  weiboMessage.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


///微博数据模型
@interface weiboMessage : NSObject

//微博ID
@property (nonatomic)int ID;
//微博信息内容
@property (nonatomic, strong)NSString *text;
//微博创建时间
@property (nonatomic, strong)NSString *created_at;
//微博来源
@property (nonatomic, strong)NSString *source;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+(instancetype)messageWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
