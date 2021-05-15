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
#import "MessageTool.h"

@interface LaunchViewController () <UITextViewDelegate>

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
    }
    if (_addImg) {  //发送带有图片的微博
        
    } else {        //发送只有文字的微博
        //文本
//        NSString *text = _textView.text;
    }
    
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
    _addImgBtn.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:_addImgBtn];
    
    //发布按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(launchWeibo)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

@end
