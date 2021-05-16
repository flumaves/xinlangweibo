//
//  HomeTableViewController.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/2.
//


#import "HomeTableViewController.h"
#import "WeiboMessageFrame.h"
#import "MessageCell.h"
#import "WebViewController.h"
#import "MessageTool.h"
#import "UserAccountTool.h"
#import "UserAccount.h"

@interface HomeTableViewController () <MessageCellDelegate>

//微博模型数组，frame模型中包含对应的微博数据
@property (nonatomic, strong)NSMutableArray *messageFrameArray;

//收藏的微博数组
@property (nonatomic, strong)NSMutableArray *likeMessageArray;

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _messageFrameArray = [self messageFrameArray];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadNewMessages)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
}

#pragma mark - 数据的懒加载
//加载到tableView上的数据
- (NSMutableArray *)messageFrameArray {
    if (_messageFrameArray == nil) {
        UserAccount *account = [UserAccountTool account];
        _messageFrameArray = [self loadWeiboMessageWithAccess_token:account.access_token];
    }
    return _messageFrameArray;
}

//收藏的微博
//用于判断加载的微博中是否拥有已经收藏的微博
- (NSMutableArray *)likeMessageArray {
    if (_likeMessageArray == nil) {
        _likeMessageArray = [MessageTool likeMessageArray];
    }
    return _likeMessageArray;
}
   

#pragma mark - 获取最新的微博数据
- (NSMutableArray *)loadWeiboMessageWithAccess_token:(NSString *)access_token {
    //创建信号量
//    dispatch_semaphore_t semaphore = dispathch_semaphore_creat(0);
    
    NSString *baseURL = @"https://api.weibo.com/2/statuses/home_timeline.json";

    NSString *urlString = [NSString stringWithFormat:@"%@?access_token=%@",baseURL ,access_token];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];

    __block NSMutableArray *array = [NSMutableArray array];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        //反序列化返回的数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];

        //获取数据中的statuses数组
        NSMutableArray *dictArray = dict[@"statuses"];

        //字典数组 转 模型数组
        NSMutableArray *messageFrameArray = [NSMutableArray array];

        for (NSDictionary *dictionary in dictArray) {
            //微博数据
            WeiboMessage *message = [WeiboMessage messageWithDictionary:dictionary];
            //遍历看有无已经收藏了的微博
            for (WeiboMessage *likeMessage in self.likeMessageArray) {
                if (likeMessage.ID == message.ID) { //同一条微博
                    message.likeMessage = likeMessage.likeMessage;
                }
            }
            
            //封装成frame模型
            WeiboMessageFrame *messageFrame = [[WeiboMessageFrame alloc] init];
            messageFrame.message = message;
            //frame模型数组
            [messageFrameArray addObject:messageFrame];
//            dispatch_semaphore_signal(semaphore);
        }
        //添加自己发布的最新的一条微博
        NSMutableArray *launchMessageArray = [MessageTool launchMessageArray];
        WeiboMessage *launchMessage = [launchMessageArray objectAtIndex:0];
        [messageFrameArray insertObject:launchMessage atIndex:0];
        
        self.messageFrameArray = messageFrameArray;
//          dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }];
    //创建的task是停止状态，需要启动
    [task resume];
    return array;
}

#pragma mark - tableView数据源方法
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

//cell被点击 ()
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取当前点击的message数据
    WeiboMessageFrame *messageFrame = self.messageFrameArray[indexPath.section];
    WeiboMessage *message = messageFrame.message;
    
    if ([self.delegate respondsToSelector:@selector(addHistoryMessageArrayWithMessage:)]) {
        [self.delegate addHistoryMessageArrayWithMessage:message];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboMessageFrame *messageFrame = _messageFrameArray[indexPath.section];
    
    NSString *ID = @"message";
    
    MessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //选中时不改变状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    [cell loadCellWithMessageFrame:messageFrame];
    
    return cell;
}


//右上角点击刷新按钮
- (void)loadNewMessages {
    [self loadWeiboMessageWithAccess_token:@"2.00fo_5EIAZkRXD3e93d042f0vWOqFE"];
    [self.tableView reloadData];
}


#pragma mark - cell的delegate
//打开文字链接的网址
- (void)openUrl:(NSURL *)URL {
    WebViewController *webViewController = [[WebViewController alloc] init];
    
    [self.navigationController pushViewController:webViewController animated:YES];
    
    [webViewController loadWebViewWithUrl:URL];
}

//添加微博到收藏
- (void)addLikeMessageWithMessage:(WeiboMessage *)message {
    [self.likeMessageArray insertObject:message atIndex:0]; //使最新收藏的微博显示在最上面
    
    [MessageTool saveLikeMessage:_likeMessageArray];
    //同时计入浏览记录
    if ([self.delegate respondsToSelector:@selector(addHistoryMessageArrayWithMessage:)]) {
        [self.delegate addHistoryMessageArrayWithMessage:message];
    }
}

//删除收藏的微博
- (void)deleteLikeMessageWithMessage:(WeiboMessage *)message {
    [self.likeMessageArray removeObject:message];
    
    [MessageTool saveLikeMessage:_likeMessageArray];
    //同时计入浏览记录
    if ([self.delegate respondsToSelector:@selector(addHistoryMessageArrayWithMessage:)]) {
        [self.delegate addHistoryMessageArrayWithMessage:message];
    }
}

@end
