//
//  WeiboMessage.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/9.
//

#import "WeiboMessage.h"

@implementation WeiboMessage

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.text            = dictionary[@"text"];
        self.source          = dictionary[@"source"];
        self.created_at      = dictionary[@"created_at"];
        self.reposts_count   = dictionary[@"reposts_count"];
        self.attitudes_count = dictionary[@"attitudes_count"];
        self.comments_count  = dictionary[@"comments_count"];
        self.user            = [UserModel userWithDictionary:dictionary[@"user"]];
        
    }
    return self;
}

+(instancetype)messageWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n \ntext:%@ \nsource:%@ \ncreated_at:%@ \nreposts_count:%@ \n attitudes_count:%@ \n comments_count:%@ \nuser:%@", _text, _source, _created_at, _reposts_count, _attitudes_count, _comments_count, _user];
}

@end
