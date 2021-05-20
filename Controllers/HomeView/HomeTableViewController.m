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

@interface HomeTableViewController () <MessageCellDelegate,UISearchBarDelegate>

//微博模型数组，frame模型中包含对应的微博数据
@property (nonatomic, strong)NSMutableArray *messageFrameArray;

//收藏的微博数组
@property (nonatomic, strong)NSMutableArray *likeMessageArray;

//登陆的账户
@property (nonatomic, strong)UserAccount *account;

//搜索栏
@property (nonatomic, strong)UISearchBar *searchBar;

//判断是否在搜索
@property (nonatomic, getter = isSearching)BOOL search;

//搜索结果
@property (nonatomic, strong)NSMutableArray *resultFrameArray;

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _messageFrameArray = [self messageFrameArray];
    
    //加载子控件
    [self loadSubViews];
    //添加手势
    [self addGesture];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - 检测tableview的偏移量
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height + [UIScreen mainScreen].bounds.size.height * 0.15) {
        NSLog(@"上拉加载");
    }
    if (scrollView.contentOffset.y <= -[UIScreen mainScreen].bounds.size.height * 0.15) {
        NSLog(@"下拉刷新");
    }
}


#pragma mark - 数据的懒加载
//储存搜索结果的数组
- (NSMutableArray *)resultFrameArray {
    if (_resultFrameArray == nil) {
        _resultFrameArray = [[NSMutableArray alloc] init];
    }
    return _resultFrameArray;
}
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

#pragma mark - 加载子控件
- (void)loadSubViews {
    //searchBar
    CGFloat searchBarW = [UIScreen mainScreen].bounds.size.width;
    CGFloat searchBarH = 56;
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, searchBarW, searchBarH)];
    [_searchBar setPlaceholder:@"搜索"];
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarStyleDefault;
    self.tableView.tableHeaderView = _searchBar;
    
    //rightBarButton
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadNewMessages)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
}

#pragma mark - searchBar的代理方法
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.tableView.scrollEnabled = NO;
    //清除存放搜索结果的数组
    [self.resultFrameArray removeAllObjects];
    self.search = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.tableView.scrollEnabled = YES;
    if (searchBar.text.length == 0) {
        self.search = NO;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {   //当搜索完东西 重新清除搜索框时 清空搜索的结果
        [self.resultFrameArray removeAllObjects];
    }
    
    NSString *searchString = _searchBar.text;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (searchString.length > 0 && searchString != nil) {
            //遍历存放微博的数组
            for (WeiboMessageFrame *messageFrame in self.messageFrameArray) {
                WeiboMessage *message= messageFrame.message;
                if ([message.subText containsString:searchString]) {
                    //正文中包含搜索内容
                    //添加frame模型到搜索结果中
                    [self.resultFrameArray addObject:messageFrame];
                } else if ([message.user.screen_name containsString:searchString]) {
                    //昵称中包含搜索内容
                    [self.resultFrameArray addObject:messageFrame];
                }
            }
            //遍历结束 回到主线程 刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    });
}

#pragma mark - tableView数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self isSearching]) {   //返回搜索结果
        return self.resultFrameArray.count;
    } else {                    //返回数据
        return self.messageFrameArray.count;;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isSearching]) {
        if (indexPath.section < _resultFrameArray.count) {
            WeiboMessageFrame *messageFrame = self.resultFrameArray[indexPath.section];
            return messageFrame.rowHeight;
        } else return 200;
    } else {
        if (indexPath.section < _messageFrameArray.count) {
            WeiboMessageFrame *messageFrame = self.messageFrameArray[indexPath.section];
            return messageFrame.rowHeight;
        } else return 200;
    }
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
    
    if ([self isSearching]) {
        messageFrame = _resultFrameArray[indexPath.section];
    } else {
        messageFrame = _messageFrameArray[indexPath.section];
    }

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
//右上角点击刷新按钮
- (void)loadNewMessages {
    //点击刷新后滚回顶部
    [self.tableView scrollsToTop];
    
    [self loadWeiboMessageWithAccess_token:self.account.access_token];
    self.search = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
    self.search = NO;
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


#pragma mark - 添加手势
- (void)addGesture {
    //向上轻扫
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.tableView addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.tableView addGestureRecognizer:swipeDown];
}

//当处在搜索状态时 才会触发响应
- (void)swipe:(UITapGestureRecognizer *)sender {
    [self.searchBar resignFirstResponder];
}

@end
