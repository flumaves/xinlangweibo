//
//  StatusTableViewController.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/13.
//

#import "StatusTableViewController.h"
#import "WebViewController.h"
#import "WeiboMessage.h"
#import "WeiboMessageFrame.h"
#import "MessageCell.h"
#import "MessageTool.h"

@interface StatusTableViewController () <MessageCellDelegate>

@property (nonatomic, strong)NSMutableArray *messageFrameArray;

//需要加载的微博数组
@property (nonatomic, strong)NSMutableArray *statusArray;


@end

@implementation StatusTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
        //代理执行点击文字链接 跳转页面
        cell.delegate = self;
    }
    
    [cell loadCellWithMessageFrame:messageFrame];
    
    return cell;
}

//cell的代理方法
- (void)openUrl:(NSURL *)URL {
    WebViewController *webViewController = [[WebViewController alloc] init];
    
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController loadWebViewWithUrl:URL];
}

@end
