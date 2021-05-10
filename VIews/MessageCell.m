//
//  MessageCell.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/10.
//

#import "MessageCell.h"

@interface MessageCell ()

//用户的头像
@property (nonatomic, strong)UIImageView *user_Img;

//用户的昵称
@property (nonatomic, strong)UILabel *screen_name_Lbl;

//发布时间
@property (nonatomic, strong)UILabel *created_at_Lbl;

//点赞数
@property (nonatomic, strong)UILabel *attitudes_count_Lbl;

//转发数
@property (nonatomic, strong)UILabel *reposts_count_Lbl;

//评论数
@property (nonatomic, strong)UILabel *comments_count_Lbl;

//正文
@property (nonatomic, strong)UILabel *text_Lbl;

@end

@implementation MessageCell

#pragma mark  初始化控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
    }
    return self;
}


#pragma mark 加载控件布局
- (void)loadCellWithMessageFrame:(WeiboMessageFrame *)messageFrame {
    //用户图片
    _user_Img = [[UIImageView alloc] initWithFrame:messageFrame.user_Img_frame];
    
    [self addSubview:_user_Img];
    
    //用户的昵称
    _screen_name_Lbl = [[UILabel alloc] initWithFrame:messageFrame.screen_name_Lbl_frame];
    
    _screen_name_Lbl.text = messageFrame.message.user.screen_name;
    
    [self addSubview:_screen_name_Lbl];
    
    //发布时间
    _created_at_Lbl = [[UILabel alloc] initWithFrame:messageFrame.created_at_Lbl_frame];
    
    _created_at_Lbl.text = messageFrame.message.created_at;
    _created_at_Lbl.font = [UIFont systemFontOfSize:12];
    _created_at_Lbl.textColor = [UIColor grayColor];
    
    [self addSubview:_created_at_Lbl];
    
    //正文
    _text_Lbl = [[UILabel alloc] initWithFrame:messageFrame.text_Lbl_frame];
    
    _text_Lbl.numberOfLines = 0;    //设置自动换行
    _text_Lbl.text = messageFrame.message.text;
    
    [self addSubview:_text_Lbl];
    
    //点赞数
    _attitudes_count_Lbl = [[UILabel alloc] initWithFrame:messageFrame.attitudes_count_Lbl_frame];
    _attitudes_count_Lbl.textAlignment = NSTextAlignmentCenter;
    
    _attitudes_count_Lbl.text = [messageFrame.message.attitudes_count stringValue];
    
    [self addSubview:_attitudes_count_Lbl];
    
    //转发数
    _reposts_count_Lbl = [[UILabel alloc] initWithFrame:messageFrame.reposts_count_Lbl_frame];
    _reposts_count_Lbl.textAlignment = NSTextAlignmentCenter;
    
    _reposts_count_Lbl.text = [messageFrame.message.reposts_count stringValue];
    
    [self addSubview:_reposts_count_Lbl];
    
    //评论数
    _comments_count_Lbl = [[UILabel alloc] initWithFrame:messageFrame.comments_count_Lbl_frame];
    _comments_count_Lbl.textAlignment = NSTextAlignmentCenter;
    
    _comments_count_Lbl.text = [messageFrame.message.comments_count stringValue];
    
    [self addSubview:_comments_count_Lbl];
}

@end
