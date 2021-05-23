//
//  SearchHistoryTool.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/21.
//

#import "SearchHistoryTool.h"
#import "UserAccount.h"
#import "UserAccountTool.h"

@interface SearchHistoryTool ()
//储存登陆的账户
@property (nonatomic, strong)UserAccount *account;

@end


@implementation SearchHistoryTool

- (UserAccount *)account {
    if (_account == nil) {
        _account = [UserAccountTool account];
    }
    return _account;
}

#pragma mark - 获取存储的路径
//浏览历史
- (NSString *)getSearchHistoryPath {
    NSString *string = [NSString stringWithFormat:@"%@_search.archive",self.account.uid];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:string];
    
    return path;
}

+ (NSString *)getSearchHistoryPath {
    SearchHistoryTool *tool = [[SearchHistoryTool alloc] init];
    NSString *path = [tool getSearchHistoryPath];
    return path;
}


+ (void)saveSearchHistory:(NSMutableArray *)searchHistoryArray {
    NSData *data = [NSJSONSerialization dataWithJSONObject:searchHistoryArray options:NSJSONWritingPrettyPrinted error:nil];
    
    [data writeToFile:[self getSearchHistoryPath] atomically:YES];
    
    NSLog(@"归档_搜索记录");
    NSLog(@"%@",[self getSearchHistoryPath]);
}

+ (NSMutableArray *)searchHistoryArray {
    //解档获取数据
    NSData *data = [NSData dataWithContentsOfFile:[self getSearchHistoryPath]];
    
    NSMutableArray *multableArray = [NSMutableArray array];
    if (data != nil) {
        //转为数组
        multableArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    
    NSLog(@"解档_搜索记录");
    return multableArray;
}

@end
