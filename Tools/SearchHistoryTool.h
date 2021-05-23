//
//  SearchHistoryTool.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchHistoryTool : NSObject

//储存搜索记录
+ (void)saveSearchHistory:(NSMutableArray *)searchHistoryArray;

//读取搜索记录
+ (NSMutableArray *)searchHistoryArray;

@end

NS_ASSUME_NONNULL_END
