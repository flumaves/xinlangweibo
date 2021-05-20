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
        self.ID              = dictionary[@"id"];
        self.source          = dictionary[@"source"];
        self.text            = dictionary[@"text"];
        self.created_at      = dictionary[@"created_at"];
        self.reposts_count   = dictionary[@"reposts_count"];
        self.attitudes_count = dictionary[@"attitudes_count"];
        self.comments_count  = dictionary[@"comments_count"];
        self.user            = [UserModel userWithDictionary:dictionary[@"user"]];
        self.thumbnail_pic   = dictionary[@"thumbnail_pic"];
        self.bmiddle_pic     = dictionary[@"bmiddle_pic"];
        self.original_pic    = dictionary[@"original_pic"];
        self.pic_urls        = dictionary[@"pic_urls"];
        self.url             = [self getOriginalUrl];
        self.subText         = [self getSubText];
        self.attr            = [self setAttributedString];
        self.likeMessage     = dictionary[@"likeMessage"] ? dictionary[@"likeMessage"] : @"NO";  //网络请求的cell 传入的dictionar中没有likeMessage 则设置成@"NO"
    }
    return self;
}

+(instancetype)messageWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n \ntext:%@ \nsource:%@ \ncreated_at:%@ \nreposts_count:%@ \n attitudes_count:%@ \n comments_count:%@ \nuser:%@ \nthumbnail_pic: %@ \nbmiddle_pic:%@ \noriginal_pic:%@ \npic_ids:%@", _text, _source, _created_at, _reposts_count, _attitudes_count, _comments_count, _user, _thumbnail_pic, _bmiddle_pic, _original_pic, _pic_urls];
}

#pragma mark - 从传来的originText中截取正文
- (NSString *)getSubText {
    NSString *text = [NSString string];
    if ([_text containsString:@"http"]) {    //判断text中是否拥有路径
        NSRange range_0 = [_text rangeOfString:@"http"];
        NSString *subString_0 = [_text substringToIndex:range_0.location]; //截去路径
        if ([subString_0 containsString:@"全文"]) {
            //国与中...全文： http://m     截去全文后面的内容
            NSRange range_1 = [subString_0 rangeOfString:@"全文"];
            NSString *subString_1 = [subString_0 substringToIndex:range_1.location + range_1.length];
            text = subString_1;
        } else {
            text = subString_0;
        }
    } else {
        text = _text;
    }
    return text;
}

#pragma mark - 从text中截取网页的URL
- (NSString *)getOriginalUrl {
    NSString *url_0 = [NSString string];
    if ([_text containsString:@"http"]) {    //判断text中是否拥有路径
        NSRange range = [_text rangeOfString:@"http"];
        NSString *urlString = [_text substringFromIndex:range.location];
        url_0 = urlString;
        
        NSMutableString *url_1 = [NSMutableString stringWithString:url_0];
        [url_1 insertString:@"s" atIndex:4];        // http 转为 https
        url_0 = (NSString *)url_1;
    }
    
    if ([url_0 containsString:@" "]) {  //去掉空格
        NSRange range = [url_0 rangeOfString:@" "];
        NSString *urlString = [url_0 substringToIndex:range.location];
        url_0 = urlString;
    }
    
    if ([url_0 containsString:@"@"]) {  //http://t.cn/A6VZMLzh @澎湃新闻 去掉@后面的内容
        NSRange range = [url_0 rangeOfString:@"@"];
        NSString *urlSting = [url_0 substringFromIndex:range.location];
        url_0 = urlSting;
    }
    
    
    return url_0;
}

#pragma mark //正文的富文本
- (NSAttributedString *)setAttributedString {
    NSString *text = [self getSubText]; //截取正文
    
    //创建富文本对象
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];

    if ([text containsString:@"全文"]) {
        NSRange range = [text rangeOfString:@"全文"];
        //设置字体为蓝色
        [attr addAttribute:NSForegroundColorAttributeName value: [UIColor blueColor] range:range];
        
        [attr addAttribute:NSLinkAttributeName value:@"quanwen://" range:range];
    }
    
    //设置字体大小
    [attr addAttribute:NSFontAttributeName value: [UIFont systemFontOfSize:17] range: NSMakeRange(0, text.length)];
    
    return attr;
}

@end
