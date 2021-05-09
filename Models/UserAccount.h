//
//  UserAccount.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/8.
//

///账号信息模型，储存于沙盒
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserAccount : NSObject <NSSecureCoding>

//用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别。
@property (nonatomic, copy)NSString *access_token;

//access_token的生命周期，单位是秒数
@property (nonatomic, copy)NSString *expires_in;

//授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。
@property (nonatomic, copy)NSString *uid;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+(instancetype)accountWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
