//
//  UserAccountTool.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/9.
//

#import "UserAccountTool.h"

#define ACCOUNTPATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation UserAccountTool

//储存账户信息
+ (void)saveAccount:(UserAccount *)account {
    NSDictionary *accountDict = [account dictionaryWithValuesForKeys:@[@"access_token", @"expires_in", @"uid"]];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:accountDict options:NSJSONWritingPrettyPrinted error:nil];
    
    [data writeToFile:ACCOUNTPATH atomically:YES];
}


//读取账户信息
+ (UserAccount *)account {
    NSData *data = [NSData dataWithContentsOfFile:ACCOUNTPATH];
    
    NSLog(@"%@",ACCOUNTPATH);
    
    UserAccount *account = [UserAccountTool accountWithData:data];
    
    return account;
}

//由data转为account
+ (UserAccount *)accountWithData:(NSData *)data {
    if (data != nil) {
        NSDictionary *accountDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        UserAccount *account = [UserAccount accountWithDictionary:accountDict];
        return account;
    } else {
        UserAccount *account = [[UserAccount alloc] init];
        return account;
    }
}
@end
