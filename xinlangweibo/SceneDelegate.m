//
//  SceneDelegate.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/2.
//

#import "SceneDelegate.h"

#import "HomeTableViewController.h"
#import "MessageTableViewController.h"
#import "LaunchViewController.h"
#import "FindTableViewController.h"
#import "PersonTableViewController.h"
#import "VisitorViewController.h"

#import "UserAccount.h"
#import "UserAccountTool.h"

#define WINDOWSIZE self.window.screen.bounds.size
@interface SceneDelegate ()
//主页
@property (nonatomic, strong)HomeTableViewController *homeTableViewController;
//消息
@property (nonatomic, strong)MessageTableViewController *messageTableViewController;
//发布
@property (nonatomic, strong)LaunchViewController *launchTableViewController;
//发现
@property (nonatomic, strong)FindTableViewController *findTableViewController;
//个人
@property (nonatomic, strong)PersonTableViewController *personTableViewController;

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    
    [self loadViews];

    [self.window makeKeyAndVisible];
}

//每个控制器添加导航栏 设置根视图
- (void)tabBar:(UITabBarController *)tabBarController addChildViewController:(UIViewController *)viewController withTitle:(NSString *)title withImage:(NSString *)imageName {
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    viewController.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:imageName];

    [tabBarController addChildViewController:nav];
}


- (void)loadViews {
    //判断是否本地已经存在账户
    UserAccount *account = [UserAccountTool account];
    
    if (account) {      //如果已有账户存在 直接加载界面
        UITabBarController *tabBar = [[UITabBarController alloc] init];
        //图片的渲染颜色
        tabBar.tabBar.tintColor = [UIColor orangeColor];
        
        //tabbar添加控制器
        _homeTableViewController = [[HomeTableViewController alloc] init];
        [self tabBar:tabBar addChildViewController: _homeTableViewController  withTitle:@"主页" withImage:@"主页"];
        _messageTableViewController = [[MessageTableViewController alloc] init];
        [self tabBar:tabBar addChildViewController: _messageTableViewController withTitle:@"消息" withImage:@"消息"];
        _launchTableViewController = [[LaunchViewController alloc] init];
        [self tabBar:tabBar addChildViewController: _launchTableViewController withTitle:@"发布" withImage:@"发布"];
        _findTableViewController = [[FindTableViewController alloc] init];
        [self tabBar:tabBar addChildViewController: _findTableViewController withTitle:@"发现" withImage:@"发现"];
        _personTableViewController = [[PersonTableViewController alloc] init];
        [self tabBar:tabBar addChildViewController: _personTableViewController withTitle:@"个人" withImage:@"个人"];
        
        //设置控制器间的代理对象
        _homeTableViewController.delegate = _personTableViewController;
        
        self.window.rootViewController = tabBar;
    } else {           //如果不存在账户 加载访客视图 进行登陆
        VisitorViewController *visitorViewController = [[VisitorViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:visitorViewController];
        
        self.window.rootViewController = nav;
    }
}

@end
