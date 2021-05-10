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

+ (BOOL)supportsSecureCoding {
    return YES;
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

//对象的归档方法
-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.access_token forKey:@"access_token"];
    [coder encodeObject:self.uid          forKey:@"uid"];
    [coder encodeObject:self.expires_in   forKey:@"expires_in"];
}

//对象的解档方法
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.access_token = [coder decodeObjectForKey:@"access_token"];
        self.uid          = [coder decodeObjectForKey:@"uid"];
        self.expires_in   = [coder decodeObjectForKey:@"expires_in"];
    }
    return self;
}


@end
