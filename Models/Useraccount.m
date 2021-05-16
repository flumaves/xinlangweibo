//
//  Account.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/9.
//

#import "UserAccount.h"

@implementation UserAccount

- (NSString *)description {
    return [NSString stringWithFormat:@"access_token: %@ \nuid: %@ \n expires_in: %@",_access_token, _uid, _expires_in];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.access_token   = dictionary[@"access_token"];
        self.uid            = dictionary[@"uid"];
        self.expires_in     = dictionary[@"expires_in"];
    }
    return self;
}

+(instancetype)accountWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}



@end
