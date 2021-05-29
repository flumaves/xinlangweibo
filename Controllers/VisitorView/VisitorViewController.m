//
//  VisitorViewController.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/7.
//

#import "VisitorViewController.h"
#import "LoginViewController.h"

@interface VisitorViewController ()

@end

@implementation VisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStylePlain target:self action:@selector(visitorLogIn)];

        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        self.view = view;
        self.view.backgroundColor = [UIColor whiteColor];
    
    //图标
    CGFloat imgW = 245;
    CGFloat imgH = 115;
    CGFloat imgX = ([UIScreen mainScreen].bounds.size.width - imgW) / 2;
    CGFloat imgY = [UIScreen mainScreen].bounds.size.width - imgH - 50;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, imgW, imgH)];
    imgView.image = [UIImage imageNamed:@"首页"];
    
    [self.view addSubview:imgView];

    //登陆按钮
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnX = ([UIScreen mainScreen].bounds.size.width - btnW) / 2;
    CGFloat btnY = [UIScreen mainScreen].bounds.size.height / 2 + 100;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    [btn setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal];
    [btn setTitleColor: [UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setTitle:@"登陆" forState:UIControlStateNormal];
    [btn setTitle:@"登陆" forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(visitorLogIn) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 5;
    [self.view addSubview:btn];
}

- (void)visitorLogIn {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    loginViewController.view.backgroundColor = [UIColor whiteColor];

    [self.navigationController pushViewController:loginViewController animated:YES];
}

@end
