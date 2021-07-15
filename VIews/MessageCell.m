//
//  MessageCell.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/10.
//

#import "MessageCell.h"
#import "MessageTool.h"

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

//多组图片的view
@property (nonatomic, strong)UIView *imgView;

//储存多图的数组
@property (nonatomic, strong)NSMutableArray *imgArray;

#pragma mark - 转发微博部分 （加上RE前缀）
//转发微博的view
@property (nonatomic, strong)UIView *retweeted_status_View;

//用户的昵称
@property (nonatomic, strong)UILabel *REscreen_name_Lbl;

//正文
@property (nonatomic, strong)UITextView *REtext_View;

//缩略图
@property (nonatomic, strong)UIImageView *REthumbnail_pic;

//多组图片的view
@property (nonatomic, strong)UIView *REimgView;

//储存多图的数组
@property (nonatomic, strong)NSMutableArray *REimgArray;

@end

@implementation MessageCell

- (NSMutableArray *)imgArray {
    if (_imgArray == nil) {
        _imgArray = [[NSMutableArray alloc] init];
    }
    return _imgArray;
}

- (NSMutableArray *)REimgArray {
    if (_REimgArray == nil) {
        _REimgArray = [[NSMutableArray alloc] init];
    }
    return _REimgArray;
}

#pragma mark  初始化控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        //顶部分割
        _topDividView = [[UIView alloc] init];
        _topDividView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
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
        [_like_Btn addTarget:self action:@selector(likeMessageBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
        _thumbnail_pic.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnail_pic.clipsToBounds = YES;
        [self.contentView addSubview:_thumbnail_pic];
        
        //多组图片的view
        _imgView = [[UIView alloc] init];
        [self.contentView addSubview:_imgView];
        
        //添加图片到view中
        CGFloat magin = 10;     //控件间的间隙
        CGFloat imgMagin = 5;   //图片之间的间隙
        CGFloat imgL = ([UIScreen mainScreen].bounds.size.width - 2 * (imgMagin + magin)) / 3;
        int columns = 3; //确定每一行有三张图片
        int max_img = 9;        //最多加载九张图片
        for (int i = 0; i < max_img; i++) {
            CGFloat imgX = (imgMagin + imgL) * (i % columns);
            CGFloat imgY = (imgMagin + imgL) * (i / columns);
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, imgL, imgL)];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            imgView.tag = i;
            
            [self.imgArray addObject:imgView];  //把添加的imgView储存到数组中
            [self.imgView addSubview:imgView];
        }
        
        ///转发微博部分
        _retweeted_status_View = [[UIView alloc] init];
        _retweeted_status_View.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
        [self.contentView addSubview:_retweeted_status_View];
        
        //昵称
        _REscreen_name_Lbl = [[UILabel alloc] init];
        [self.retweeted_status_View addSubview:_REscreen_name_Lbl];
        _REscreen_name_Lbl.textColor = [UIColor colorWithRed:65 / 255.0 green:105 / 255.0 blue:225 / 255.0 alpha:1];
        
        //正文
        _REtext_View = [[UITextView alloc] init];
        _REtext_View.editable = NO;
        _REtext_View.scrollEnabled = NO;
        _REtext_View.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _REtext_View.delegate = self;
        _REtext_View.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
        [self.retweeted_status_View addSubview:_REtext_View];
        
        //缩略图
        _REthumbnail_pic = [[UIImageView alloc] init];
        _REthumbnail_pic.contentMode = UIViewContentModeScaleAspectFill;
        _REthumbnail_pic.clipsToBounds = YES;
        [self.retweeted_status_View addSubview:_REthumbnail_pic];
        
        //多组图片的view
        _REimgView = [[UIView alloc] init];
        [self.retweeted_status_View addSubview:_REimgView];
        
        //添加图片到view中
        CGFloat REmagin = 10;     //控件间的间隙
        CGFloat REimgMagin = 5;   //图片之间的间隙
        CGFloat REimgL = ([UIScreen mainScreen].bounds.size.width - 2 * (REimgMagin + REmagin)) / 3;
        int REcolumns = 3; //确定每一行有三张图片
        int REmax_img = 9;        //最多加载九张图片
        for (int i = 0; i < REmax_img; i++) {
            CGFloat REimgX = (imgMagin + REimgL) * (i % REcolumns);
            CGFloat REimgY = (imgMagin + REimgL) * (i / REcolumns);
            
            UIImageView *REimgView = [[UIImageView alloc] initWithFrame:CGRectMake(REimgX, REimgY, REimgL, REimgL)];
            REimgView.contentMode = UIViewContentModeScaleAspectFill;
            REimgView.clipsToBounds = YES;
            REimgView.tag = i;
            
            [self.REimgArray addObject:REimgView];  //把添加的imgView储存到数组中
            [self.REimgView addSubview:REimgView];
        }
    }
    return self;
}


#pragma mark 加载控件内容
- (void)loadCellWithMessageFrame:(WeiboMessageFrame *)messageFrame {
    _messageFrame = messageFrame;
    
    //顶部分割视图
    _topDividView.frame = messageFrame.topDividView_frame;
    
    //用户图片
    _user_Img.frame = messageFrame.user_Img_frame;
    //获取用户头像
    [self getHeadImgWithUrlString:messageFrame.message.user.profile_image_url];

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
    if (_messageFrame.message.pic_urls.count > 1) {
        _imgView.frame = _messageFrame.imgView_frame;
        _thumbnail_pic.hidden = YES;
        _imgView.hidden = NO;
        
        //请求图片
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i = 0; i < self.imgArray.count; i++) {
                UIImageView *imgView = self.imgArray[i];
                if (i < self.messageFrame.message.pic_urls.count) { //判断是否需要显示照片
                    //判断imgView的编号 获取对应位置的图片
                    NSDictionary *dict = self.messageFrame.message.pic_urls[i];
                    NSString *urlString = dict[@"thumbnail_pic"];
                    
                    NSURL *url = [NSURL URLWithString:urlString];
                    NSData *imgData = [NSData dataWithContentsOfURL:url];
                
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        imgView.image = [UIImage imageWithData:imgData];
                        imgView.hidden = NO;
                    });
                    
                } else {
                    //不需要显示图片 隐藏imgView
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imgView.hidden = YES;
                    });
                }
            }
        });
    } else {
        _thumbnail_pic.frame = messageFrame.thumbnail_pic_frame;
        if (messageFrame.message.thumbnail_pic == NULL) {
            _thumbnail_pic.hidden = YES;
            _imgView.hidden = YES;
        } else {
            _thumbnail_pic.hidden = NO;
            _imgView.hidden = YES;
            [self getThumbnailImgWithUrlString:messageFrame.message.original_pic];
        }
    }
    
    ///转发微博部分
    //获取转发微博的模型
    if (_messageFrame.message.retweeted_status == nil) {
        //转发模块隐藏
        _retweeted_status_View.hidden = YES;
    } else {
        _retweeted_status_View.hidden = NO;
        
        WeiboMessage *REmessage = [[WeiboMessage alloc] initWithDictionary:_messageFrame.message.retweeted_status];
        
        //整个转发模块
        _retweeted_status_View.frame = messageFrame.retweeted_status_frame;
        
        //昵称
        _REscreen_name_Lbl.frame = messageFrame.REscreen_name_Lbl_frame;
        
        NSString *screen_name = [NSString stringWithFormat:@"@%@:",REmessage.user.screen_name];
        _REscreen_name_Lbl.text = screen_name;
        
        //正文
        _REtext_View.frame = messageFrame.REtext_View_frame;
        _REtext_View.text = REmessage.text;
        _REtext_View.attributedText = REmessage.attr;
        
        //缩略图
        if (REmessage.pic_urls.count > 1) {
            _REimgView.frame = _messageFrame.REimgView_frame;
            _REthumbnail_pic.hidden = YES;
            _REimgView.hidden = NO;
            
            //请求图片
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (int i = 0; i < self.REimgArray.count; i++) {
                    UIImageView *imgView = self.REimgArray[i];
                    if (i < REmessage.pic_urls.count) { //判断是否需要显示照片
                        
                        //根据imgView的编号 获取对应位置的照片
                        NSDictionary *dict = REmessage.pic_urls[i];
                        NSString *urlString = dict[@"thumbnail_pic"];
                        
                        NSURL *url = [NSURL URLWithString:urlString];
                        NSData *imgData = [NSData dataWithContentsOfURL:url];
                    
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            imgView.image = [UIImage imageWithData:imgData];
                            imgView.hidden = NO;
                        });
                        
                    } else {
                        //不需要显示图片 隐藏imgView
                        dispatch_async(dispatch_get_main_queue(), ^{
                            imgView.hidden = YES;
                        });
                    }
                }
            });
        } else {
            _REthumbnail_pic.frame = messageFrame.REthumbnail_pic_frame;
            if (REmessage.thumbnail_pic == NULL) {
                _REthumbnail_pic.hidden = YES;
                _REimgView.hidden = YES;
            } else {
                _REthumbnail_pic.hidden = NO;
                _REimgView.hidden = YES;
                [self getThumbnailImgWithUrlString:REmessage.original_pic];
            }
        }
    }
}

///通过url获取头像
- (void)getHeadImgWithUrlString:(NSString *)urlString {
    //请求网络的图片
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *imgData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.user_Img.image = [UIImage imageWithData:imgData];
        });
    });
}

///获取缩略图
- (void)getThumbnailImgWithUrlString:(NSString *)urlString {
    if ([urlString containsString:@"http"]) {   //判断路径是网络的还是本地的
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *imgData = [NSData dataWithContentsOfURL:url];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.thumbnail_pic.image = [UIImage imageWithData:imgData];
            });
        });
    } else {
        NSData *data = [MessageTool getImageDataWithURLString:urlString];
        
        self.thumbnail_pic.image = [UIImage imageWithData:data];
    }
}

///点击收藏按钮
- (void)likeMessageBtnClick {
    if ([self.likeMessage isEqual:@"YES"]) {     //取消收藏
        _likeMessage = @"NO";
        _messageFrame.message.likeMessage = @"NO";
        [_like_Btn setImage: [UIImage imageNamed:@"unlike"] forState:UIControlStateNormal];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        //发送 收藏微博 的通知
        [center postNotificationName:@"deleteLikeMessage" object:_messageFrame.message];
    } else {                                     //收藏
        _likeMessage = @"YES";
        _messageFrame.message.likeMessage = @"YES";
        [_like_Btn setImage: [UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        //发送 取消收藏微博 的通知
        [center postNotificationName:@"addLikeMessage" object:_messageFrame.message];
    }
}


#pragma mark - 时间格式的转化
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
    
    NSInteger sec = time;
    if (sec < 60) {
        return [NSString stringWithFormat:@"%ld秒前",(long)sec];
    }
    //秒转分钟
    NSInteger min = sec / 60;
    if (min < 60) {
        return [NSString stringWithFormat:@"%ld分钟前",min];
    }
    //分钟转小时
    NSInteger hour = min / 60;
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
    if ([[URL scheme] isEqual:@"quanwen"]) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"openUrl" object:[NSURL URLWithString:self.messageFrame.message.url]];
    }
    return NO;
}

@end
