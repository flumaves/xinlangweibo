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
    //全局外观
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStylePlain target:self action:@selector(visitorLogIn)];
    
    self.loginIn = false;
    
    if ([self isLoginIn]) {

    } else {
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        self.view = view;
        self.view.backgroundColor = [UIColor whiteColor];

        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(150, 200, 100, 30)];
        [btn setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal];
        [btn setTitleColor: [UIColor grayColor] forState:UIControlStateHighlighted];
        [btn setTitle:@"登陆" forState:UIControlStateNormal];
        [btn setTitle:@"登陆" forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(visitorLogIn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)visitorLogIn {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    loginViewController.view.backgroundColor = [UIColor whiteColor];

    [self.navigationController pushViewController:loginViewController animated:YES];
}

@end
