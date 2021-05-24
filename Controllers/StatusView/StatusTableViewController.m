//
//  StatusTableViewController.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/13.
//

#import "StatusTableViewController.h"
#import "WebViewController.h"
#import "WeiboMessageFrame.h"
#import "MessageCell.h"
#import "MessageTool.h"

@interface StatusTableViewController ()

@property (nonatomic, strong)NSMutableArray *messageFrameArray;

//需要加载的微博数组
@property (nonatomic, strong)NSMutableArray *statusArray;

//收藏的微博数组
@property (nonatomic, strong)NSMutableArray *likeMessageArray;


@end

@implementation StatusTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [self addObservers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObservers];
}

//收藏的微博
//用于判断加载的微博中是否拥有已经收藏的微博
- (NSMutableArray *)likeMessageArray {
    if (_likeMessageArray == nil) {
        _likeMessageArray = [MessageTool likeMessageArray];
    }
    return _likeMessageArray;
}

#pragma mark - Table view data source
- (NSMutableArray *)statusArray {
    if (!_statusArray) {
        switch (_tag) {
            case 0:
                //加载浏览历史
                _statusArray = [MessageTool historyMessageArray];
                break;
            case 1:
                //加载我的收藏
                _statusArray = [MessageTool likeMessageArray];
                break;
            case 2:
                //加载我的发表
                _statusArray = [MessageTool launchMessageArray];
            default:
                break;
        }
    }
    return _statusArray;
}

//获取frame模型
- (NSMutableArray *)messageFrameArray {
    if (!_messageFrameArray) {
        NSMutableArray *array = [NSMutableArray array];
        for (WeiboMessage *message in self.statusArray) {
            //frame模型
            WeiboMessageFrame *messageFrame = [[WeiboMessageFrame alloc] init];
            messageFrame.message = message;
            //frame模型数组
            [array addObject:messageFrame];
        }
        _messageFrameArray = array;
    }
    return _messageFrameArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.messageFrameArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < _messageFrameArray.count) {
        WeiboMessageFrame *messageFrame = self.messageFrameArray[indexPath.section];
        return messageFrame.rowHeight;
    } else return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboMessageFrame *messageFrame = _messageFrameArray[indexPath.section];
    
    NSString *ID = @"message";
    
    MessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //选中时不改变状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell loadCellWithMessageFrame:messageFrame];
    
    return cell;
}
//cell被点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    WeiboMessageFrame *frame = self.messageFrameArray[indexPath.section];
    WeiboMessage *message = frame.message;
    
    //发送通知，添加到浏览历史中
    [center postNotificationName:@"saveHistoryMessage" object:message];
}

#pragma mark - 添加观察者
- (void)addObservers {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //接收收藏微博
    [center addObserver:self selector:@selector(addLikeMessage:) name:@"addLikeMessage" object:nil];
    //接收取消收藏微博
    [center addObserver:self selector:@selector(deleteLikeMessage:) name:@"deleteLikeMessage" object:nil];
    [center addObserver:self selector:@selector(openUrl:) name:@"openUrl" object:nil];
}

//收藏微博
- (void)addLikeMessage:(NSNotification *)notification {
    NSLog(@"1");
    
    WeiboMessage *message = notification.object;
    
    [self.likeMessageArray insertObject:message atIndex:0]; //使最新收藏的微博显示在最上面
    
    [MessageTool saveLikeMessage:_likeMessageArray];
    
    //发送通知，添加到浏览历史中
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"saveHistoryMessage" object:message];
}

//取消收藏微博
- (void)deleteLikeMessage:(NSNotification *)notification {
    WeiboMessage *message = notification.object;
    
    NSArray *array = [NSArray arrayWithArray:self.likeMessageArray];
    for (WeiboMessage *status in array) {
        if ([status.ID isEqual:message.ID]) {
            [_likeMessageArray removeObject:status];
        }
    }

    [MessageTool saveLikeMessage:_likeMessageArray];

    //发送通知，添加到浏览历史中
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"saveHistoryMessage" object:message];
}

//打开文字链接的网址
- (void)openUrl:(NSNotification *)notification {
    NSURL *url = notification.object;
    
    WebViewController *webViewController = [[WebViewController alloc] init];
    
    webViewController.view.bounds = self.view.bounds;
    webViewController.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    
    [webViewController loadWebViewWithUrl:url];
    
    [self.navigationController pushViewController:webViewController animated:YES];
}


#pragma mark - 注销观察者
- (void)removeObservers {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center removeObserver:self name:@"addLikeMessage" object:nil];
    [center removeObserver:self name:@"deleteLikeMessage" object:nil];
    [center removeObserver:self name:@"openUrl" object:nil];
}


@end
