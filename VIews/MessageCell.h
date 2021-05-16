//
//  MessageCell.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/10.
//

#import <UIKit/UIKit.h>
#import "WeiboMessageFrame.h"
#import "WeiboMessage.h"


NS_ASSUME_NONNULL_BEGIN

@protocol MessageCellDelegate <NSObject>

@optional
//打开文字链接的网址
- (void)openUrl:(NSURL *)URL;

//添加收藏的微博
- (void)addLikeMessageWithMessage:(WeiboMessage *)message;

//取消微博的收藏
- (void)deleteLikeMessageWithMessage:(WeiboMessage *)message;

@end

@interface MessageCell : UITableViewCell
//frame模型
@property (nonatomic, strong)WeiboMessageFrame *messageFrame;

//收藏按钮
@property (nonatomic, strong)UIButton *like_Btn;

//delegate
@property (nonatomic, weak)id<MessageCellDelegate> delegate;

//加载微博数据
- (void)loadCellWithMessageFrame:(WeiboMessageFrame *)messageFrame;

@end

NS_ASSUME_NONNULL_END
