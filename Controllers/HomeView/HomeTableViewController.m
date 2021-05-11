//
//  HomeTableViewController.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/2.
//


#import "HomeTableViewController.h"
#import "WeiboMessage.h"
#import "WeiboMessageFrame.h"
#import "MessageCell.h"

@interface HomeTableViewController ()

@property (nonatomic, strong)NSMutableArray *messageFrameArray;

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadNewMessages)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
}

- (NSMutableArray *)messageFrameArray {
    if (_messageFrameArray == nil) {
        _messageFrameArray = [self loadWeiboMessageWithAccess_token:@"2.00fo_5EI0q9TVv48692e6e8aG3rlbC"];
    }
    return _messageFrameArray;
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
            NSLog(@"%@",message);
            //frame模型
            WeiboMessageFrame *messageFrame = [[WeiboMessageFrame alloc] init];
            messageFrame.message = message;
            //frame模型数组
            [messageFrameArray addObject:messageFrame];
            
            NSLog(@"message____%@",message);
//
//            dispatch_semaphore_signal(semaphore);
        }
//
        self.messageFrameArray = messageFrameArray;
//
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
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

- (void)loadNewMessages {
    
//    [self loadWeiboMessageWithAccess_token:@"2.00fo_5EIAZkRXD3e93d042f0vWOqFE"];
    [self.tableView reloadData];
}

@end
