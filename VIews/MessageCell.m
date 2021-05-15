//
//  MessageCell.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/10.
//

#import "MessageCell.h"

@interface MessageCell () <UITextViewDelegate>

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

        //正文
        _text_View = [[UITextView alloc] init];
        _text_View.editable = NO;       //不可编辑
        _text_View.scrollEnabled = NO;
        _text_View.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _text_View.delegate = self;
        [self.contentView addSubview:_text_View];

        //缩略图
        _thumbnail_pic = [[UIImageView alloc] init];
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
    _created_at_Lbl.text = messageFrame.message.created_at;

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
