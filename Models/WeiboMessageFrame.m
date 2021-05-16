//
//  cellFrame.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/10.
//

#import "WeiboMessageFrame.h"

#define TEXTFONT [UIFont systemFontOfSize:17]
//#define TEXTKERN

@implementation WeiboMessageFrame

//重写模型message属性的set方法，使其同时计算控件的frame
- (void)setMessage:(WeiboMessage *)message {
    _message = message;
 
    ////计算frame 行高
    //控件间距
    CGFloat magin = 10;
    
    //顶部分割视图
    CGFloat topDividViewX = 0;
    CGFloat topDividViewY = 0;
    CGFloat topDividViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat topDividViewH = 15;
    
    _topDividView_frame = CGRectMake(topDividViewX, topDividViewY, topDividViewW, topDividViewH);
    
    //用户的头像
    CGFloat imgL = 50;
    CGFloat imgX = magin;
    CGFloat imgY = magin + CGRectGetMaxY(_topDividView_frame);
    
    _user_Img_frame = CGRectMake(imgX, imgY, imgL, imgL);
    
    //用户的昵称
    CGFloat nameLblX = CGRectGetMaxX(_user_Img_frame) + magin;
    CGFloat nameLblY = imgY + magin;
    CGFloat nameLblW = 200;
    CGFloat nameLblH = 20;
    _screen_name_Lbl_frame = CGRectMake(nameLblX, nameLblY, nameLblW, nameLblH);
    
    //发布时间
    CGFloat created_at_X = CGRectGetMaxX(_user_Img_frame) + magin;
    CGFloat created_at_Y = CGRectGetMaxY(_screen_name_Lbl_frame);
    CGFloat created_at_W = 150;
    CGFloat created_at_H = 20;
    _created_at_Lbl_frame = CGRectMake(created_at_X, created_at_Y, created_at_W, created_at_H);
    
    //正文
    CGFloat textX = magin;
    CGFloat textY = CGRectGetMaxY(_created_at_Lbl_frame) + magin;
    
        //计算text的行高
    NSString *text = _message.subText;
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * magin, [UIScreen mainScreen].bounds.size.height * 10) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: TEXTFONT} context:nil].size;
 
    _text_View_frame = CGRectMake(textX, textY, textSize.width + 3, textSize.height + 21);  //预留一行的空间
    
    //缩略图
    if (_message.thumbnail_pic.length > 0) {
        NSString *urlString = _message.original_pic;    //获取图片
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *imgData = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:imgData];
        
        CGFloat thumbnailImgW = 300;
        CGFloat thumbnailImgH  =300 * img.size.height / img.size.width; //比例缩放图片
        CGFloat thumbnailImgX = magin;
        CGFloat thumbnailImgY = CGRectGetMaxY(_text_View_frame) + magin;
        _thumbnail_pic_frame = CGRectMake(thumbnailImgX, thumbnailImgY, thumbnailImgW, thumbnailImgH);
    }
    
    //底下三个控件统一宽度    高度  Y
    CGFloat lblW = [UIScreen mainScreen].bounds.size.width / 4;
    CGFloat lblH = 30;
    CGFloat lblY;
    if (_message.thumbnail_pic.length > 0) {
        lblY = CGRectGetMaxY(_thumbnail_pic_frame) +magin;
    } else {
        lblY = CGRectGetMaxY(_text_View_frame);
    }
    
    //点赞数
    CGFloat attitudeLblX = 0 * lblW;
    _attitudes_count_Btn_frame = CGRectMake(attitudeLblX, lblY, lblW, lblH);
    
    //转发数
    CGFloat repostX = 1 *lblW;

    _reposts_count_Btn_frame = CGRectMake(repostX, lblY, lblW, lblH);
    
    //评论数
    CGFloat commentX = 2 * lblW;
    _comments_count_Btn_frame = CGRectMake(commentX, lblY, lblW, lblH);
    
    //收藏按钮
    CGFloat likeX = 3 * lblW;
    _like_Btn_frame = CGRectMake(likeX, lblY, lblW, lblH);
    
    _rowHeight = CGRectGetMaxY(_attitudes_count_Btn_frame);
}
@end
