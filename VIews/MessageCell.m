//
//  MessageCell.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/10.
//

#import "MessageCell.h"

@interface MessageCell () <UITextViewDelegate>
//是否为收藏的微博
@property (nonatomic, strong)NSString *likeMessage;

//顶部分割视图
@property (nonatomic, strong)UIView *topDividView;

//用户的头像
@property (nonatomic, strong)UIImageView *user_Img;

//用户的昵称
@property (nonatomic, strong)UILabel *screen_name_Lbl;

//发布时间
@property (nonatomic, strong)UILabel *created_at_Lbl;

//点赞数
@property (nonatomic, strong)UIButton *attitudes_count_Btn;

//转发数
@property (nonatomic, strong)UIButton *reposts_count_Btn;

//评论数
@property (nonatomic, strong)UIButton *comments_count_Btn;

//正文
@property (nonatomic, strong)UITextView *text_View;

//缩略图
@property (nonatomic, strong)UIImageView *thumbnail_pic;

@end

@implementation MessageCell

#pragma mark  初始化控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        //顶部分割
        _topDividView = [[UIView alloc] init];
        _topDividView.backgroundColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_topDividView];
        
        //用户头像
        _user_Img = [[UIImageView alloc] init];
        [self.contentView addSubview:_user_Img];

        //用户名称
        _screen_name_Lbl = [[UILabel alloc] init];
        [self.contentView addSubview:_screen_name_Lbl];

        //发布时间
        _created_at_Lbl = [[UILabel alloc] init];
        _created_at_Lbl.font = [UIFont systemFontOfSize:12];
        _created_at_Lbl.textColor = [UIColor grayColor];
        [self.contentView addSubview:_created_at_Lbl];
        
        
        //点赞数
        _attitudes_count_Btn = [[UIButton alloc] init];
        [_attitudes_count_Btn setImage: [UIImage imageNamed:@"dianzan"] forState:UIControlStateNormal];
        [self.contentView addSubview:_attitudes_count_Btn];

        //转发数
        _reposts_count_Btn = [[UIButton alloc] init];
        [_reposts_count_Btn setImage: [UIImage imageNamed:@"zhuanfa"] forState:UIControlStateNormal];
        [self.contentView addSubview:_reposts_count_Btn];

        //评论数
        _comments_count_Btn = [[UIButton alloc] init];
        [_comments_count_Btn setImage: [UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
        [self.contentView addSubview:_comments_count_Btn];
        
        //点赞按钮
        _like_Btn = [[UIButton alloc] init];
        [_like_Btn addTarget:self action:@selector(likeMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_like_Btn];

        //正文
        _text_View = [[UITextView alloc] init];
        _text_View.editable = NO;       //不可编辑
        _text_View.scrollEnabled = NO;
        _text_View.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _text_View.delegate = self;
        [self.contentView addSubview:_text_View];

        //缩略图
        _thumbnail_pic = [[UIImageView alloc] init];
//        _thumbnail_pic.contentMode = UIViewContentModeScaleAspectFill;
//        _thumbnail_pic.clipsToBounds = YES;
        [self.contentView addSubview:_thumbnail_pic];
    }
    return self;
}


#pragma mark 加载控件布局
- (void)loadCellWithMessageFrame:(WeiboMessageFrame *)messageFrame {
    _messageFrame = messageFrame;
    
    //顶部分割视图
    _topDividView.frame = messageFrame.topDividView_frame;
    
    //用户图片
    _user_Img.frame = messageFrame.user_Img_frame;
    //获取用户头像
    self.user_Img.image = [self getImgWithUrlString:messageFrame.message.user.profile_image_url];

    //用户的昵称
    _screen_name_Lbl.frame = messageFrame.screen_name_Lbl_frame;
    _screen_name_Lbl.text = messageFrame.message.user.screen_name;

    //发布时间
    _created_at_Lbl.frame = messageFrame.created_at_Lbl_frame;
    _created_at_Lbl.text = [self messureTheTime];

    //正文
    _text_View.frame = messageFrame.text_View_frame;
    _text_View.text = messageFrame.message.text;
    _text_View.attributedText = messageFrame.message.attr;

    //点赞数
    _attitudes_count_Btn.frame = messageFrame.attitudes_count_Btn_frame;
    [_attitudes_count_Btn setTitle: [messageFrame.message.attitudes_count stringValue] forState:UIControlStateNormal];
    [_attitudes_count_Btn setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];

    //转发数
    _reposts_count_Btn.frame = messageFrame.reposts_count_Btn_frame;
    [_reposts_count_Btn setTitle: [messageFrame.message.reposts_count stringValue] forState:UIControlStateNormal];
    [_reposts_count_Btn setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];

    //评论数
    _comments_count_Btn.frame = messageFrame.comments_count_Btn_frame;
    [_comments_count_Btn setTitle: [messageFrame.message.comments_count stringValue] forState:UIControlStateNormal];
    [_comments_count_Btn setTitleColor: [UIColor grayColor] forState: UIControlStateNormal];
    
    //收藏按钮
    _like_Btn.frame = messageFrame.like_Btn_frame;
    self.likeMessage = messageFrame.message.likeMessage;
    if ([self.likeMessage isEqual:@"NO"]) {
        [_like_Btn setImage: [UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
    } else {
        [_like_Btn setImage: [UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }
    
    //缩略图
    _thumbnail_pic.frame = messageFrame.thumbnail_pic_frame;
    if (messageFrame.message.thumbnail_pic == NULL) {
        _thumbnail_pic.hidden = YES;
    } else {
        _thumbnail_pic.hidden = NO;
        _thumbnail_pic.image = [self getImgWithUrlString:messageFrame.message.original_pic];
    }
}


//通过url获取图片
- (UIImage *)getImgWithUrlString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData *imgData = [NSData dataWithContentsOfURL:url];
    
    UIImage *img = [UIImage imageWithData:imgData];
    
    return img;
}

//点击收藏按钮
- (void)likeMessage:(WeiboMessage *)message {
    if ([self.likeMessage isEqual:@"YES"]) {     //取消收藏
        _likeMessage = @"NO";
        _messageFrame.message.likeMessage = @"NO";
        [_like_Btn setImage: [UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(deleteLikeMessageWithMessage:)]) {  //从收藏的数据中删除
            [self.delegate deleteLikeMessageWithMessage:self.messageFrame.message];
        }
    } else {                                     //收藏
        _likeMessage = @"YES";
        _messageFrame.message.likeMessage = @"YES";
        [_like_Btn setImage: [UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(addLikeMessageWithMessage:)]) {
            [self.delegate addLikeMessageWithMessage:self.messageFrame.message];
            //添加微博到收藏的数据中
        }
    }
}

//转化成几分钟前的格式
- (NSString *)messureTheTime {
    //获取发布时间的时间戳
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss +0800 yyyy";
    
    NSDate *date = [dateFormatter dateFromString:self.messageFrame.message.created_at];
    NSTimeInterval creatTime = [date timeIntervalSince1970];
    
    //获取当前的时间戳
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    
    //时间差
    NSTimeInterval time = currentTime - creatTime;
    
    NSInteger sec = time / 60;
    if (sec < 60) {
        return [NSString stringWithFormat:@"%ld分钟前",sec];
    }
    //秒转小时
    NSInteger hour = sec / 60;
    if (hour < 24) {
        return [NSString stringWithFormat:@"%ld小时前",hour];
    }
    //小时转天数
    NSInteger day = hour / 24;
    if (day < 30) {
        return [NSString stringWithFormat:@"%ld天前",day];
    }
    //天数转月
    NSInteger month = day / 30;
    if (month < 12) {
        return [NSString stringWithFormat:@"%ld月前",month];
    }
    //月转年
    NSInteger year = month / 12;
    return [NSString stringWithFormat:@"%ld年前",year];
}

#pragma mark - textView代理方法
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"quanwen"]) {
        if ([self.delegate respondsToSelector:@selector(openUrl:)]) {
            [self.delegate openUrl:[NSURL URLWithString:self.messageFrame.message.url]];
            NSLog(@"url----%@",_messageFrame.message.url);
        }
    }
    return NO;
}

@end
