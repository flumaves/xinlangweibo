//
//  HomeTableViewController.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/2.
//


#import "HomeTableViewController.h"
#import "SearchViewViewController.h"
#import "WeiboMessageFrame.h"
#import "MessageCell.h"
#import "WebViewController.h"
#import "MessageTool.h"
#import "UserAccountTool.h"
#import "UserAccount.h"
#import "HeadTabView.h"

@interface HomeTableViewController () <UISearchBarDelegate>

//微博模型数组，frame模型中包含对应的微博数据
@property (nonatomic, strong)NSMutableArray *messageFrameArray;

//显示到tableView中的数组
@property (nonatomic, strong)NSMutableArray *showMessageFrameArray;

//当前点击的headerTab中的btn的text
@property (nonatomic, strong)NSString *btnText;

//收藏的微博数组
@property (nonatomic, strong)NSMutableArray *likeMessageArray;

//登陆的账户
@property (nonatomic, strong)UserAccount *account;

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _messageFrameArray = [self messageFrameArray];
    
    //加载子控件
    [self loadSubViews];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

//将要展示view的时候
- (void)viewWillAppear:(BOOL)animated {
    [self addObservers];
}

//view不显示的时候注销观察者
- (void)viewWillDisappear:(BOOL)animated {
    [self removeObservers];
}

#pragma mark - 添加观察者
- (void)addObservers {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //接收收藏微博
    [center addObserver:self selector:@selector(addLikeMessage:) name:@"addLikeMessage" object:nil];
    //接收取消收藏微博
    [center addObserver:self selector:@selector(deleteLikeMessage:) name:@"deleteLikeMessage" object:nil];
    //跳转网页
    [center addObserver:self selector:@selector(openUrl:) name:@"openUrl" object:nil];
    //headerTab按钮点击
    [center addObserver:self selector:@selector(showSpeciesMessage:) name:@"headerTabBtnClick" object:nil];
}

//显示特定种类的微博
- (void)showSpeciesMessage:(NSNotification *)notification {
    UIButton *btn = notification.object;
    //记录所点击的btn 的text
    _btnText = btn.titleLabel.text;
    //更新将要显示的微博数组
    [self updateShowMessageFrameArray];
    //更新tableView
    [self.tableView reloadData];
}

//收藏微博
- (void)addLikeMessage:(NSNotification *)notification {
    NSLog(@"2");
    
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
    [self.likeMessageArray removeObject:message];
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
    [center removeObserver:self name:@"headerTabBtnClick" object:nil];
}


#pragma mark - 检测tableview的偏移量
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //上拉加载
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height + [UIScreen mainScreen].bounds.size.height * 0.15) {
        NSLog(@"上拉加载");
        [self loadMoreMessageWithAccess_token:self.account.access_token];
    }
    
    //下拉刷新
    if (scrollView.contentOffset.y <= -[UIScreen mainScreen].bounds.size.height * 0.15) {
        NSLog(@"下拉刷新");
        [self loadWeiboMessageWithAccess_token:self.account.access_token];
    }
}


#pragma mark - 数据的懒加载
//登陆的用户
- (UserAccount *)account {
    if (_account == nil) {
        UserAccount *account = [UserAccountTool account];
        _account = account;
    }
    return _account;
}

//加载的数据
- (NSMutableArray *)messageFrameArray {
    if (_messageFrameArray == nil) {
        [self loadWeiboMessageWithAccess_token:self.account.access_token];
    }
    return _messageFrameArray;
}

//展示到tableView中的数据
- (NSMutableArray *)showMessageFrameArray {
    if (_showMessageFrameArray == nil) {
        _showMessageFrameArray = [NSMutableArray array];
    }
    return _showMessageFrameArray;
}

//用于判断加载的微博中是否拥有已经收藏的微博
- (NSMutableArray *)likeMessageArray {
    if (_likeMessageArray == nil) {
        _likeMessageArray = [MessageTool likeMessageArray];
    }
    return _likeMessageArray;
}
   
//当前点击的btn的text
- (NSString *)btnText {
    if (_btnText == nil) {
        _btnText = @"全文";
    }
    return _btnText;
}

#pragma mark - 获取最新的微博数据
- (void)loadWeiboMessageWithAccess_token:(NSString *)access_token {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *baseURL = @"https://api.weibo.com/2/statuses/home_timeline.json";

        NSString *urlString = [NSString stringWithFormat:@"%@?access_token=%@",baseURL ,access_token];
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
            if (error) {
                NSLog(@"%@",error);
                return;
            }
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
            }
            //添加自己发布的最新的一条微博
            NSMutableArray *launchMessageArray = [MessageTool launchMessageArray];
            if (launchMessageArray.count > 0) { //如果有发布微博
                WeiboMessage *launchMessage = [launchMessageArray objectAtIndex:0];
                //封装frame模型
            WeiboMessageFrame *messageFrame = [[WeiboMessageFrame alloc] init];
            messageFrame.message = launchMessage;
            
            [messageFrameArray insertObject:messageFrame atIndex:0];
            }
            //对微博数据存储 和 将要显示的数据存储
            self.messageFrameArray = messageFrameArray;
            
            [self updateShowMessageFrameArray];
            NSLog(@"网络请求完毕");
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        //创建的task是停止状态，需要启动
        [task resume];
    });
}


#pragma mark - 加载更早的微博数据
- (void)loadMoreMessageWithAccess_token:(NSString *)access_token {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //获取max_id
        WeiboMessageFrame *messageFrame = self.messageFrameArray.lastObject;
        WeiboMessage *message = messageFrame.message;
        NSNumber *max_id = message.ID;
        //请求微博的数量
        NSNumber *count = [NSNumber numberWithInt:10];
        
        NSString *baseURL = @"https://api.weibo.com/2/statuses/home_timeline.json";

        NSString *urlString = [NSString stringWithFormat:@"%@?access_token=%@&max_id=%@&count=%@",baseURL ,access_token, max_id, count];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
            if (error) {
                NSLog(@"%@",error);
                return;
            }
            //反序列化返回的数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];

            //获取数据中的statuses数组
            NSMutableArray *dictArray = dict[@"statuses"];

            //字典数组 转 模型数组
            NSMutableArray *messageFrameArray = [NSMutableArray array];

            for (NSDictionary *dictionary in dictArray) {
                //微博数据
                WeiboMessage *message = [WeiboMessage messageWithDictionary:dictionary];
                
                if (message.ID == max_id) {     //如果是已经存在的微博，就跳过
                    continue;
                }
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
            }

            [self.messageFrameArray addObjectsFromArray:messageFrameArray];
            
            //更新展示的数组
            [self updateShowMessageFrameArray];
            NSLog(@"网络请求完毕");
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        //创建的task是停止状态，需要启动
        [task resume];
    });
}


#pragma mark - 更新显示要展示的微博数组
- (void)updateShowMessageFrameArray {
    //每次更新之前 清空数组
    [self.showMessageFrameArray removeAllObjects];
    
    if ([self.btnText isEqualToString:@"全部"]) { //  展示全部微博数据
//        self.showMessageFrameArray = self.messageFrameArray;
        [self.showMessageFrameArray addObjectsFromArray:self.messageFrameArray];
    } else {
        //遍历找出含有关键词的微博数据
        for (WeiboMessageFrame *messageFrame in _messageFrameArray) {   //展示特定的微博数据
            WeiboMessage *message = messageFrame.message;
            if ([message.text containsString:_btnText] || [message.user.screen_name containsString:_btnText]) {
                [_showMessageFrameArray addObject:messageFrame];
            }
        }
    }
}


#pragma mark - 加载子控件
- (void)loadSubViews {
    //leftBarButton
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchMessage)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];

    //rightBarButton
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadNewMessages)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
    
    //初始化 默认为 全部
    _btnText = @"全部";
}


#pragma mark - tableView数据源方法 和 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showMessageFrameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _showMessageFrameArray.count) {
        WeiboMessageFrame *messageFrame = self.showMessageFrameArray[indexPath.row];
        return messageFrame.rowHeight;
    } else return 200;
}

//cell被点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    WeiboMessageFrame *frame = self.showMessageFrameArray[indexPath.row];
    WeiboMessage *message = frame.message;
    
    //发送通知，添加到浏览历史中
    [center postNotificationName:@"saveHistoryMessage" object:message];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboMessageFrame *messageFrame = [[WeiboMessageFrame alloc] init];
    
    messageFrame = self.showMessageFrameArray[indexPath.row];

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

//设置hearTab
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //headerTabBar
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat viewH = 60;
    CGFloat viewX = 0;
    CGFloat viewY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    HeadTabView *headTabView = [[HeadTabView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
    return headTabView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}


#pragma mark - navigationItem的点击方法
//跳转到搜索页面
- (void)searchMessage {
    SearchViewViewController *searchViewController = [[SearchViewViewController alloc] initWithBounds:self.navigationController.navigationBar.frame];
    //传入数组
    searchViewController.messageFrameArray = self.messageFrameArray;
    
    [self.navigationController pushViewController:searchViewController animated:YES];
}

//右上角点击刷新按钮
- (void)loadNewMessages {
    //点击刷新后滚回顶部
    [self.tableView scrollsToTop];
    
    [self loadWeiboMessageWithAccess_token:self.account.access_token];
}

@end
