//
//  UserModel.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

//用户昵称
@property (nonatomic, strong)NSString *screen_name;

//用户头像
@property (nonatomic, strong)NSString *profile_image_url;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+(instancetype)userWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
