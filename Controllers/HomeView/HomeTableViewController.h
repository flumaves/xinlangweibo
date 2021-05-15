//
//  HomeTableViewController.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/2.
//
#import "VisitorViewController.h"
#import "WeiboMessage.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeTableViewControllerDelegate <NSObject>

@optional
- (void)addHistoryMessageArrayWithMessage:(WeiboMessage *)message;

@end

@interface HomeTableViewController : UITableViewController

@property (nonatomic, weak)id<HomeTableViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
