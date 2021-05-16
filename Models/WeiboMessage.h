//
//  WeiboMessage.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/9.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


///微博数据模型
@interface WeiboMessage : NSObject

//是否为收藏的微博
@property (nonatomic, strong)NSString *likeMessage;

//原始的传入text （包含路径 正文）
@property (nonatomic, strong)NSString *text;

//微博正文
@property (nonatomic, strong)NSString *subText;

//微博ID
@property (nonatomic, strong)NSNumber *ID;

//正文的富文本
@property (nonatomic, strong)NSAttributedString *attr;

//微博的URL
@property (nonatomic, strong)NSString *url;

//微博创建时间
@property (nonatomic, strong)NSString *created_at;

//微博来源
@property (nonatomic, strong)NSString *source;

//发布者
@property (nonatomic, strong)UserModel *user;

//转发数
@property (nonatomic, strong)NSNumber *reposts_count;

//评论数
@property (nonatomic, strong)NSNumber * comments_count;

//点赞数
@property (nonatomic, strong)NSNumber *attitudes_count;

//缩略图片地址，没有时不返回此字段
@property (nonatomic, strong)NSString *thumbnail_pic;

//中等尺寸图片地址，没有时不返回此字段
@property(nonatomic, strong)NSString *bmiddle_pic;

//原始图片地址，没有时不返回此字段
@property(nonatomic, strong)NSString *original_pic;

//微博配图ID。多图时返回多图ID
@property (nonatomic, strong)NSMutableArray *pic_ids;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+(instancetype)messageWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
