//
//  weiboMessage.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/9.
//

#import "weiboMessage.h"

@implementation weiboMessage

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.ID = dictionary[@"ID"];
        self.text = dictionary[@"text"];
        self.source = dictionary[@"source"];
        self.created_at = dictionary[@"created_at"];
    }
    return self;
}

+(instancetype)messageWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%d\n%@\n%@\n%@",_ID, _text, _source, _created_at];
}

@end
