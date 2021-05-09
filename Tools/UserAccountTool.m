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
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:account requiringSecureCoding:YES error:nil];
    
    [data writeToFile:ACCOUNTPATH atomically:YES];
    
    NSLog(@"归档");
    NSLog(@"accountPath----%@",ACCOUNTPATH);
}


//读取账户信息
+ (UserAccount *)account {
    NSData *data = [NSData dataWithContentsOfFile:ACCOUNTPATH];
    
    UserAccount *account = [NSKeyedUnarchiver unarchivedObjectOfClass: [UserAccount class] fromData:data error:nil];
    
    return account;
}

@end
