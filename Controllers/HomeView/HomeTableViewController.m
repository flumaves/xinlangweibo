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

@interface HomeTableViewController () <MessageCellDelegate,UISearchBarDelegate>

//微博模型数组，frame模型中包含对应的微博数据
@property (nonatomic, strong)NSMutableArray *messageFrameArray;

//收藏的微博数组
@property (nonatomic, strong)NSMutableArray *likeMessageArray;

//登陆的账户
@property (nonatomic, strong)UserAccount *account;

//搜索栏
@property (nonatomic, strong)UISearchBar *searchBar;

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

//加载到tableView上的数据
- (NSMutableArray *)messageFrameArray {
    if (_messageFrameArray == nil) {
        [self loadWeiboMessageWithAccess_token:self.account.access_token];
    }
    return _messageFrameArray;
}

//用于判断加载的微博中是否拥有已经收藏的微博
- (NSMutableArray *)likeMessageArray {
    if (_likeMessageArray == nil) {
        _likeMessageArray = [MessageTool likeMessageArray];
    }
    return _likeMessageArray;
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

            self.messageFrameArray = messageFrameArray;
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
            NSLog(@"网络请求完毕");
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        //创建的task是停止状态，需要启动
        [task resume];
    });
}


#pragma mark - 加载子控件
- (void)loadSubViews {
//    //searchBar
//    CGFloat searchBarW = [UIScreen mainScreen].bounds.size.width;
//    CGFloat searchBarH = 56;
//    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, searchBarW, searchBarH)];
//    [_searchBar setPlaceholder:@"搜索"];
//    _searchBar.delegate = self;
//    _searchBar.barStyle = UIBarStyleDefault;
//    self.tableView.tableHeaderView = _searchBar;
//
    //leftBarButton
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchMessage)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];

    //rightBarButton
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadNewMessages)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
}


#pragma mark - tableView数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.messageFrameArray.count;;
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

///cell被点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取当前点击的message数据
    WeiboMessageFrame *messageFrame = self.messageFrameArray[indexPath.section];
    WeiboMessage *message = messageFrame.message;
    
    if ([self.delegate respondsToSelector:@selector(addHistoryMessageArrayWithMessage:)]) {
        [self.delegate addHistoryMessageArrayWithMessage:message];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboMessageFrame *messageFrame = [[WeiboMessageFrame alloc] init];
    
    messageFrame = _messageFrameArray[indexPath.section];

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


#pragma mark - cell的delegate
//打开文字链接的网址
- (void)openUrl:(NSURL *)URL {
    WebViewController *webViewController = [[WebViewController alloc] init];
    
    webViewController.view.bounds = self.view.bounds;
    webViewController.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    
    [webViewController loadWebViewWithUrl:URL];
    
    [self.navigationController pushViewController:webViewController animated:YES];
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
