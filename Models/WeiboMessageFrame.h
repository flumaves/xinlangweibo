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

//缩略配图的frame
@property (nonatomic, assign)CGRect thumbnail_pic_frame;

//点赞数的frame
@property (nonatomic, assign)CGRect attitudes_count_Btn_frame;

//转发数的frame
@property (nonatomic, assign)CGRect reposts_count_Btn_frame;

//评论数的frame
@property (nonatomic, assign)CGRect comments_count_Btn_frame;

//cell的高度
@property (nonatomic, assign)CGFloat rowHeight;

@end

NS_ASSUME_NONNULL_END
