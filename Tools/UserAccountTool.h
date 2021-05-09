//
//  UserAccountTool.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/9.
//

#import <Foundation/Foundation.h>
#import "UserAccount.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserAccountTool : NSObject

//储存账号信息
+ (void)saveAccount:(UserAccount *)account;

//读取账号信息
+ (UserAccount *)account;

@end

NS_ASSUME_NONNULL_END
