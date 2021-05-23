//
//  SearchViewViewController.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/22.
//

#import <UIKit/UIKit.h>
#import "WeiboMessage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SearchViewControllerDelegate <NSObject>

@optional
- (void)addHistoryMessageArrayWithMessage:(WeiboMessage *)message;

@end

@interface SearchViewViewController : UIViewController
//接收传入的frame数组
@property (nonatomic, strong)NSMutableArray *messageFrameArray;

@property (nonatomic, weak)id<SearchViewControllerDelegate> delegate;

- (SearchViewViewController *)initWithBounds:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
