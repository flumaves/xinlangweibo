//
//  RefreshView.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RefreshView : UIView

//Line为 释放刷新 和 下拉刷新 的分界线
@property (nonatomic, getter = isOverLine)BOOL overLine;

//当视图在分割线附近来回拖动时 改变视图
- (void)changeTheViewWithOverLine:(BOOL)overline;

//正在刷新的视图
- (void)changeRefreshingView;
@end

NS_ASSUME_NONNULL_END
