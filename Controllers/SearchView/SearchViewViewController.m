//
//  SearchViewViewController.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/22.
//

#import "SearchViewViewController.h"
#import "WebViewController.h"
#import "SearchHistoryTool.h"
#import "MessageTool.h"
#import "MessageCell.h"
#import "WeiboMessageFrame.h"


@interface SearchViewViewController () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

//搜索栏
@property (nonatomic, strong)UISearchBar *searchBar;

//搜索结果
@property (nonatomic, strong)NSMutableArray *resultFrameArray;

//历史搜索数组
@property (nonatomic, strong)NSMutableArray *historyFrameArray;

//搜索记录数组
@property (nonatomic, strong)NSMutableArray *searchHistoryArray;

//显示搜索结果的tableView
@property (nonatomic, strong)UITableView *resultTableView;

//储存btn的数组
@property (nonatomic, strong)NSMutableArray *btnArray;

//收藏的微博数组
@property (nonatomic, strong)NSMutableArray *likeMessageArray;

//判断是否在搜索
@property (nonatomic, getter = isSearching)BOOL search;

@end

@implementation SearchViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self addObservers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObservers];
}

#pragma mark - 数据的懒加载
//用于判断加载的微博中是否拥有已经收藏的微博
- (NSMutableArray *)likeMessageArray {
    if (_likeMessageArray == nil) {
        _likeMessageArray = [MessageTool likeMessageArray];
    }
    return _likeMessageArray;
}

//btnArray
- (NSMutableArray *)btnArray {
    if (_btnArray == nil) {
        _btnArray = [[NSMutableArray alloc] init];
    }
    return _btnArray;
}

//储存搜索记录的数组
- (NSMutableArray *)searchHistoryArray {
    if (_searchHistoryArray == nil) {
        //读取搜索记录
        _searchHistoryArray = [SearchHistoryTool searchHistoryArray];
    }
    return _searchHistoryArray;
}

//储存搜索结果的数组
- (NSMutableArray *)resultFrameArray {
    if (_resultFrameArray == nil) {
        //创建一个空的数组
        _resultFrameArray = [[NSMutableArray alloc] init];
    }
    return _resultFrameArray;
}


#pragma mark - 初始化添加子控件
- (SearchViewViewController *)initWithBounds:(CGRect)frame
{
    self = [super init];
    if (self) {
        CGFloat maxY = 0.0;       //用于记录btn最大的Y ，方便设置tableView的Y
        
        self.view.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
        
        //searchBar
        CGFloat searchBarY = CGRectGetMaxY(frame);
        CGFloat searchBarX = 0;
        CGFloat searchBarW = [UIScreen mainScreen].bounds.size.width;
        CGFloat searchBarH = 56;
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(searchBarX, searchBarY, searchBarW, searchBarH)];
        [_searchBar setPlaceholder:@"发现新鲜事..."];
        _searchBar.delegate = self;
        _searchBar.barStyle = UIBarStyleDefault;
        [self.view addSubview:_searchBar];
        
        maxY = searchBarH + searchBarY;
        
        //搜索历史lbl
        CGFloat magin = 10;     //控件间的距离
        CGFloat lblY = maxY + magin;
        CGFloat lblX = magin;
        CGFloat lblW = 100;
        CGFloat lblH = 20;
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblW, lblH)];
        lbl.text = @"搜索记录:";
        lbl.textColor = [UIColor grayColor];
        lbl.font = [UIFont systemFontOfSize:14];
        
        [self.view addSubview:lbl];
        maxY = lblY + lblH; //重新记录maxY方便设置后续的btn
        
        //历史记录
        CGFloat subMagin = 5;   //历史记录间的距离
        
        //btn的W     H
        CGFloat btnW = ([UIScreen mainScreen].bounds.size.width - 2 * magin - subMagin) / 2;
        CGFloat btnH = 25;
        
        int columns = 2;    //每行有两个搜索记录
        int showNumber_max = 6; //最多展示的历史记录的条数为6条
        int showNumber = showNumber_max < self.searchHistoryArray.count ? showNumber_max : (int)self.searchHistoryArray.count;
        for (int i = 0; i < showNumber; i++) {
            CGFloat btnX = magin + (subMagin + btnW) * (i % columns);
            CGFloat btnY = maxY + magin + (subMagin + btnH) * (i / columns);
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
            [btn setTitle: _searchHistoryArray[i] forState:UIControlStateNormal];
            [btn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor: [UIColor grayColor] forState:UIControlStateHighlighted];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1]];
            btn.layer.borderWidth = 1;
            btn.layer.cornerRadius = 10;
            btn.tag = i;
            [btn addTarget:self action:@selector(searchHistoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:btn];
            //添加进数组中，后续更新界面可以引用
            [self.btnArray addObject:btn];
            
            if (i == showNumber - 1) {  //创建到最后一个控件时 重新记录maxY 方便设置tableView的frame
                maxY = btnY + btnH;
            }
        }
        
        //显示搜索结果的tableView
        //tableView的X       Y       W       H
        CGFloat tableViewX = 0;
        CGFloat tableViewY = maxY + magin;
        CGFloat tableViewW = [UIScreen mainScreen].bounds.size.width;
        CGFloat tableViewH = self.view.bounds.size.height - tableViewY;
        _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH)];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        [self.view addSubview:_resultTableView];
    }
    return self;
}


#pragma mark - 历史记录按钮的点击事件
- (void)searchHistoryBtnClick:(UIButton *)button {
    //取消searchBar的响应
    [self.searchBar resignFirstResponder];
    //先清空resultArray
    [self.resultFrameArray removeAllObjects];
    self.search = YES;
    [self showResultsWithText:button.titleLabel.text];
}


#pragma mark - 显示搜索结果到tableView上
- (void)showResultsWithText:(NSString *)string {
    NSString *searchString = string;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (searchString.length > 0 && searchString != nil) {
            //遍历存放微博的数组
            for (WeiboMessageFrame *messageFrame in self.messageFrameArray) {
                WeiboMessage *message= messageFrame.message;
                
                NSString *pinyin_text = [self transformToPinyin:message.text];
                NSString *pinyin_screenName = [self transformToPinyin:message.user.screen_name];
                
                if ([pinyin_text containsString:searchString]) {
                    //正文中包含搜索内容
                    //添加frame模型到搜索结果中
                    [self.resultFrameArray addObject:messageFrame];
                } else if ([pinyin_screenName containsString:searchString]) {
                    //昵称中包含搜索内容
                    [self.resultFrameArray addObject:messageFrame];
                }
            }
            //遍历结束 回到主线程 刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.resultTableView reloadData];
            });
        }
    });
}


#pragma mark - searchBar的代理方法
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //清除存放搜索结果的数组
    [self.resultFrameArray removeAllObjects];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (searchBar.text.length == 0) {
        self.search = NO;
        [self.resultTableView reloadData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {   //当搜索完东西 重新清除搜索框时 清空搜索的结果
        [self.resultFrameArray removeAllObjects];
        self.search = NO;   //显示原本的微博
        [self.resultTableView reloadData];
        return;
    } else {
        self.search = YES;
    }
    [self showResultsWithText:_searchBar.text];
}

//按下回车
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *text = searchBar.text;
    if (text.length == 0) { //判断text长度不为零
        self.search = NO;
        [self.resultFrameArray removeAllObjects];
        return;
    }
    //将搜索记录插入到最前端
    NSMutableArray *array = [NSMutableArray arrayWithArray:_searchHistoryArray];    //防止只有一条搜索记录时，判定为 singleArray 直接插入报错
    [array insertObject:text atIndex:0];
    _searchHistoryArray = array;
    //存储搜索记录
    [SearchHistoryTool saveSearchHistory:self.searchHistoryArray];
    //刷新界面
    if (self.btnArray.count == 6) {    //已经创建了六个btn
        for (UIButton *btn in self.btnArray) {
            //根据tag判断btn的位置 重新设置text
            [btn setTitle:self.searchHistoryArray[btn.tag] forState:UIControlStateNormal];
        }
    } else {    //还没有满六个btn 则添加一个
        //创建btn
        CGFloat maxY = CGRectGetMaxY(_searchBar.frame); //获取searchBar的y 再根据btn的个数 计算出btn的位置
        CGFloat magin = 10;
        CGFloat subMagin = 5;
        int columns = 2;
        
        CGFloat btnW = ([UIScreen mainScreen].bounds.size.width - 2 * magin - subMagin) / 2;
        CGFloat btnH = 25;
        
        CGFloat btnX = magin +(subMagin + btnW) * ((_searchHistoryArray.count - 1) % columns);
        CGFloat btnY = maxY + magin + (subMagin + btnH) * ((_searchHistoryArray.count - 1) / columns);
        
        //重新记录maxY 方便设置tableView的frame
        maxY = btnY + btnH;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1]];
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 10;
        btn.tag = _searchHistoryArray.count - 1;
        [btn addTarget:self action:@selector(searchHistoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        [self.btnArray addObject:btn];
        
        //重新对每一个btn设置text
        for (UIButton *btn in self.btnArray) {
            //根据tag判断btn的位置 重新设置text
            [btn setTitle:self.searchHistoryArray[btn.tag] forState:UIControlStateNormal];
        }
        
        //重新设置tableView的frame
        CGFloat tableViewX = 0;
        CGFloat tableViewY = maxY + magin;
        CGFloat tableViewW = [UIScreen mainScreen].bounds.size.width;
        CGFloat tableViewH = self.view.bounds.size.height - tableViewY;
        
        _resultTableView.frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
    }
    //刷新tableView
    [self showResultsWithText:_searchBar.text];
}


#pragma mark - tableView的delegat和datasource
//cell被点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    WeiboMessage *message = [[WeiboMessage alloc] init];
    if ([self isSearching]) {
        WeiboMessageFrame *frame = self.resultFrameArray[indexPath.section];
        message = frame.message;
    } else {
        WeiboMessageFrame *frame = self.messageFrameArray[indexPath.section];
        message = frame.message;
    }
    //发送通知，添加到浏览历史中
    [center postNotificationName:@"saveHistoryMessage" object:message];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self isSearching]) {   //如果在搜索中 返回结果的数组
        return self.resultFrameArray.count;
    } else {                    //不在搜索中 或搜索内容为空 返回传入的微博数据
        return self.messageFrameArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取对应的messageFrame
    WeiboMessageFrame *messageFrame = [[WeiboMessageFrame alloc] init];
    if ([self isSearching]) {
        messageFrame = _resultFrameArray[indexPath.section];
    } else {
        messageFrame = _messageFrameArray[indexPath.section];
    }

    NSString *ID = @"message";
    
    MessageCell *cell = [self.resultTableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //选中时不改变状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell loadCellWithMessageFrame:messageFrame];
    
    return cell;
}
//滚动tableView则取消searchBar的第一响应
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.searchBar.text.length > 0) {
        self.search = YES;
    } else {
        self.search = NO;
    }
    [self.searchBar resignFirstResponder];
}
//点击屏幕取消第一响应
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.searchBar.text.length > 0) {
        self.search = YES;
    } else {
        self.search = NO;
    }
    [self.searchBar resignFirstResponder];
}


#pragma mark - searchBar 的模糊搜索
//拼音 首字母
- (NSString *)transformToPinyin:(NSString *)searchString {
    NSMutableString *string = [NSMutableString stringWithString:searchString];
    CFStringTransform((CFMutableStringRef)string, NULL, kCFStringTransformMandarinLatin, NO);
    //转为不带声调的拼音
    CFStringTransform((CFMutableStringRef)string, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSArray *pinyinArray = [string componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString string];
    
    for (NSString *string in pinyinArray) {
        [allString appendFormat:@"%@",string];
    }
    
    NSMutableString *initialString = [NSMutableString string];  //拼音首字母
    for (NSString *str in pinyinArray) {
        if (str.length > 0) {
            [initialString appendString: [str substringToIndex:1]];
        }
    }
    [allString appendFormat:@"#%@",initialString];
    [allString appendFormat:@",#%@",searchString];
    
    return allString;
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
}

@end
