//
//  cellFrame.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WeiboMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeiboMessageFrame : NSObject

@property (nonatomic, strong)WeiboMessage *message;

//顶部分割视图
@property (nonatomic, assign)CGRect topDividView_frame;

//头像的frame
@property (nonatomic, assign)CGRect user_Img_frame;

//昵称的frame
@property (nonatomic, assign)CGRect screen_name_Lbl_frame;

//发布时间的frame
@property (nonatomic, assign)CGRect created_at_Lbl_frame;

//正文的frame
@property (nonatomic, assign)CGRect text_View_frame;

//缩略配图的frame    (单张图片）
@property (nonatomic, assign)CGRect thumbnail_pic_frame;

//多张图片配图的view
@property (nonatomic, assign)CGRect imgView_frame;

//点赞数的frame
@property (nonatomic, assign)CGRect attitudes_count_Btn_frame;

//转发数的frame
@property (nonatomic, assign)CGRect reposts_count_Btn_frame;

//评论数的frame
@property (nonatomic, assign)CGRect comments_count_Btn_frame;

//收藏按钮的frame
@property (nonatomic, assign)CGRect like_Btn_frame;

//cell的高度
@property (nonatomic, assign)CGFloat rowHeight;

#pragma  mark - 微博转发的部分 （添加RE前缀）
//转发微博的view的frame
@property (nonatomic, assign)CGRect retweeted_status_frame;

//用户昵称
@property (nonatomic, assign)CGRect REscreen_name_Lbl_frame;

//正文的frame
@property (nonatomic, assign)CGRect REtext_View_frame;

//缩略配图的frame    (单张图片）
@property (nonatomic, assign)CGRect REthumbnail_pic_frame;

//多张图片配图的view
@property (nonatomic, assign)CGRect REimgView_frame;

//点赞数的frame
@property (nonatomic, assign)CGRect REattitudes_count_Btn_frame;

@end

NS_ASSUME_NONNULL_END
