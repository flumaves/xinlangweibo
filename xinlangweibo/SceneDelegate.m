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

#define WINDOWSIZE self.window.screen.bounds.size
@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    
    UITabBarController *tabBar = [[UITabBarController alloc] init];
    
    //图片的渲染颜色
    tabBar.tabBar.tintColor = [UIColor orangeColor];
    
    [self tabBar:tabBar addChildViewController: [[HomeTableViewController alloc] init] withTitle:@"主页" withImage:@"主页"];
    [self tabBar:tabBar addChildViewController: [[MessageTableViewController alloc] init] withTitle:@"消息" withImage:@"消息"];
    [self tabBar:tabBar addChildViewController: [[LaunchViewController alloc] init] withTitle:@"发布" withImage:@"发布"];
    [self tabBar:tabBar addChildViewController: [[FindTableViewController alloc] init] withTitle:@"发现" withImage:@"发现"];
    [self tabBar:tabBar addChildViewController: [[PersonTableViewController alloc] init] withTitle:@"个人" withImage:@"个人"];

    self.window.rootViewController = tabBar;
    
    [self.window makeKeyAndVisible];
}

//每个控制器添加导航栏 设置根视图
- (void)tabBar:(UITabBarController *)tabBarController addChildViewController:(UIViewController *)viewController withTitle:(NSString *)title withImage:(NSString *)imageName {
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    viewController.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:imageName];

    [tabBarController addChildViewController:nav];
}

@end
