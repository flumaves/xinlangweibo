//
//  LaunchViewController.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/2.
//

#import "LaunchViewController.h"
#import <WebKit/WebKit.h>
#import "WeiboMessage.h"
#import "UserAccount.h"
#import "UserAccountTool.h"
#import "WeiboMessage.h"
#import "UserAccountTool.h"
#import "MessageTool.h"

@interface LaunchViewController () <UITextViewDelegate>

//本地登陆的用户
@property (nonatomic, strong)UserModel *model;

//文字输入框
@property (nonatomic, strong)UITextView *textView;

//添加图片按钮
@property (nonatomic, strong)UIButton *addImgBtn;

//判断是否添加了图片
@property (nonatomic)BOOL addImg;

@end

@implementation LaunchViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _addImg = NO;
    
    //获取授权的模型
    [self getUserModel];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //加载控件
    [self loadSubViews];
    
    //添加手势
    [self addGesture];
    
}


#pragma mark - 发布微博
- (void)launchWeibo {
    if (_textView.text.length > 140) {
        NSLog(@"字数超过140");
        return;
    }
    if (_addImg) {  //发送带有图片的微博
        
    } else {        //发送只有文字的微博
        //我的发表数组
        NSMutableArray *launchMessageArray = [MessageTool launchMessageArray];
        
        //储存在本地
        NSDictionary *dict = @{
            @"text" : _textView.text,
            @"id" : [[NSNumber alloc] initWithDouble:launchMessageArray.count + 1],
            @"created_at" : [self getCreated_at],
            @"reposts_count" : [[NSNumber alloc] initWithInt:0],
            @"attitudes_count" : [[NSNumber alloc] initWithInt:0],
            @"comments_count" : [[NSNumber alloc] initWithInt:0],
            @"user" : [_model dictionaryWithValuesForKeys:@[@"screen_name", @"profile_image_url"]],
//            @"thumbnail_pic" : @"",
//            @"bmiddle_pic" : @"",
//            @"original_pic" : @"",
            @"pic_ids" : @"",
            @"likeMessage" : @"NO"
        };
        
        //创建message模型
        WeiboMessage *message = [WeiboMessage messageWithDictionary:dict];
        
        [launchMessageArray insertObject:message atIndex:0];
        
        [MessageTool saveLaunchMessage:launchMessageArray];
    }
    
}

//网络请求用户模型
- (void)getUserModel {
    UserAccount *account = [UserAccountTool account];
    
    NSString *baseURL = @"https://api.weibo.com/2/users/show.json";
    
    NSString *urlString = [NSString stringWithFormat:@"%@?access_token=%@&uid=%@",baseURL, account.access_token, account.uid];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest  requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //user字典
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        self.model = [UserModel userWithDictionary:dict];
        
        NSLog(@"用户模型请求完毕");
    }];
    [task resume];
}

- (NSString *)getCreated_at {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss +0800 yyyy";
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:currentTime];
    NSString *created_at = [dateFormatter stringFromDate:time];
    return created_at;
}

#pragma mark - 限制只能输入150字
-  (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = _textView.text.length;
    if (number > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}


#pragma mark - 添加手势
- (void)addGesture {
    //向上轻扫
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
}

- (void)swipe:(UITapGestureRecognizer *)sender {
    [self.textView resignFirstResponder];
}

#pragma mark - 加载子控件
- (void)loadSubViews {
    CGFloat magin = 10;
    
    //文字输入框
    //获取状态栏
    UIStatusBarManager *manager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
    CGFloat statusBarHeight = manager.statusBarFrame.size.height;
    
    CGFloat textViewX = magin;
    CGFloat textViewY = magin + CGRectGetMaxY(self.navigationController.navigationBar.frame) + statusBarHeight;
    CGFloat textViewL = [UIScreen mainScreen].bounds.size.width - 2 * magin;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(textViewX, textViewY, textViewL, textViewL)];
    _textView.layer.borderWidth = 2;
    _textView.layer.borderColor = [[UIColor grayColor] CGColor];
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.delegate = self;
    
    [self.view addSubview:_textView];
    
    //添加图片按钮
    CGFloat addImgBtnX = magin;
    CGFloat addImgBtnY = CGRectGetMaxY(_textView.frame) + magin;
    CGFloat addImgBtnL = 150;
    
    _addImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(addImgBtnX, addImgBtnY, addImgBtnL, addImgBtnL)];
    [_addImgBtn setImage: [UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    _addImgBtn.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    [_addImgBtn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_addImgBtn];
    
    //发布按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(launchWeibo)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

//点击添加图片
- (void)addImage {
    NSLog(@"添加系统相册的照片");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

@end
