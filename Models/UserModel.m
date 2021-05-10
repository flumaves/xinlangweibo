//
//  UserModel.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/10.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self == [super init]) {
        self.profile_image_url = dictionary[@"profile_image_url"];
        self.screen_name       = dictionary[@"screen_name"];
    }
    return self;
}

+(instancetype)userWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

@end
