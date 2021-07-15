//
//  MessageCollectionCell.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/7/13.
//

#import <UIKit/UIKit.h>
#import "WeiboMessageFrame.h"
#import "WeiboMessage.h"


NS_ASSUME_NONNULL_BEGIN

@interface MessageCollectionCell : UICollectionViewCell

//判断cell中是否进行了初始化
@property (nonatomic, getter = isFull)BOOL full;

//初始化cell
- (instancetype)loadViews;

//frame模型
@property (nonatomic, strong)WeiboMessageFrame *messageFrame;

//收藏按钮
@property (nonatomic, strong)UIButton *like_Btn;

//加载微博数据
- (void)loadCellWithMessageFrame:(WeiboMessageFrame *)messageFrame;

@end

NS_ASSUME_NONNULL_END
