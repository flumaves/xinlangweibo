//
//  PersonTableViewController.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/2.
//

#import "PersonTableViewController.h"
#import "StatusTableViewController.h"
#import "HomeTableViewController.h"
#import "MessageTool.h"

@interface PersonTableViewController ()

//浏览过的微博的数组
@property (nonatomic, strong)NSMutableArray *historyStatusArray;

//收藏的微博的数组
@property (nonatomic, strong)NSMutableArray *likeStatusArray;

//发布的微博的数组
@property (nonatomic, strong)NSMutableArray *launchStatusArray;

@end

@implementation PersonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    self.tableView = tableView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveHistoryMessage:) name:@"saveHistoryMessage" object:nil];
    }
    return self;
}

#pragma mark - Table view data source
//静态单元格
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"浏览历史";
            cell.imageView.image = [UIImage imageNamed:@"history"];
            cell.tag = 0;
            break;
        case 1:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"我的收藏";
                cell.imageView.image = [UIImage imageNamed:@"like"];
                cell.tag = 1;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"我的发表";
                cell.imageView.image = [UIImage imageNamed:@"launch"];
                cell.tag = 2;
            }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    StatusTableViewController *statusViewController = [[StatusTableViewController alloc] init];
    statusViewController.tag = cell.tag;
    
    [self.navigationController pushViewController:statusViewController animated:YES];
}


//懒加载
//浏览历史
- (NSMutableArray *)historyStatusArray {
    if (_historyStatusArray == nil) {
        _historyStatusArray = [MessageTool historyMessageArray];
    }
    if (_historyStatusArray == nil) {
        //解档后为nil 说明没有浏览历史
        _historyStatusArray = [NSMutableArray array];
    }
    return _historyStatusArray;
}
//我的发表
- (NSMutableArray *)launchStatusArray {
    if (_launchStatusArray == nil) {
        _launchStatusArray = [MessageTool launchMessageArray];
    }
    if (_launchStatusArray == nil) {
        //解档后为nil 说明没有发表微博
        _launchStatusArray = [NSMutableArray array];
    }
    return _launchStatusArray;
}
//我的收藏
- (NSMutableArray *)likeStatusArray {
    if (_likeStatusArray == nil) {
        _likeStatusArray = [MessageTool likeMessageArray];
    }
    if (_likeStatusArray == nil) {
        //解档后为nil 说明没有收藏
        _likeStatusArray = [NSMutableArray array];
    }
    return _likeStatusArray;
}

#pragma mark - 通知的具体实现
- (void)saveHistoryMessage:(NSNotification *)notification {
    WeiboMessage *message = notification.object;
    
    NSArray *array = [NSArray arrayWithArray:self.historyStatusArray];
    for (WeiboMessage *status in array) {
        if ([status.ID isEqual:message.ID]) {         //已经浏览过的weibo
            [_historyStatusArray removeObject:status];  //把微博删除
        }
    }
    
    [self.historyStatusArray insertObject:message atIndex:0];   //插入到数组头部 使最新的浏览记录在最前面
    [MessageTool saveHistoryMessage:self.historyStatusArray];
}


#pragma mark - HomeTableViewController delegate
- (void)addHistoryMessageArrayWithMessage:(WeiboMessage *)message {
    BOOL haveASameMessage = NO;
    NSArray *array = [NSArray arrayWithArray:self.historyStatusArray];
    for (WeiboMessage *status in array) {
        if ([status.ID isEqual:message.ID]) {         //已经浏览过的weibo
            haveASameMessage = YES;
            NSInteger index = [array indexOfObject:status];   //把微博删除
            [_historyStatusArray removeObjectAtIndex:index];
        }
    }
    
    [self.historyStatusArray insertObject:message atIndex:0];   //插入到数组头部 使最新的浏览记录在最前面
    [MessageTool saveHistoryMessage:self.historyStatusArray];
}

@end
