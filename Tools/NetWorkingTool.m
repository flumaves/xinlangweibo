//
//  NetWorkingTool.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/28.
//

#import "NetWorkingTool.h"
#import "WeiboMessage.h"
#import "WeiboMessageFrame.h"
#import "MessageTool.h"

@implementation NetWorkingTool


#pragma mark - 获取最新的微博数据
//- (NSMutableArray *)loadWeiboMessageWithAccess_token:(NSString *)access_token {
//    //模型frame数组
//    NSMutableArray *messageFrameArray_0 = [NSMutableArray array];
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *baseURL = @"https://api.weibo.com/2/statuses/home_timeline.json";
//
//        NSString *urlString = [NSString stringWithFormat:@"%@?access_token=%@",baseURL ,access_token];
//
//        NSURL *url = [NSURL URLWithString:urlString];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//
//        NSURLSession *session = [NSURLSession sharedSession];
//
//        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
//        {
//            if (error) {
//                NSLog(@"%@",error);
//                return;
//            }
//            //反序列化返回的数据
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
//
//            //获取数据中的statuses数组
//            NSMutableArray *dictArray = dict[@"statuses"];
//
//            //字典数组 转 模型数组
//            NSMutableArray *messageFrameArray_1 = [NSMutableArray array];
//
//            for (NSDictionary *dictionary in dictArray) {
//                //微博数据
//                WeiboMessage *message = [WeiboMessage messageWithDictionary:dictionary];
//                //遍历看有无已经收藏了的微博
//                for (WeiboMessage *likeMessage in self.likeMessageArray) {
//                    if (likeMessage.ID == message.ID) { //同一条微博
//                        message.likeMessage = likeMessage.likeMessage;
//                    }
//                }
//
//                //封装成frame模型
//                WeiboMessageFrame *messageFrame = [[WeiboMessageFrame alloc] init];
//                messageFrame.message = message;
//                //frame模型数组
//                [messageFrameArray addObject:messageFrame];
//            }
//            //添加自己发布的最新的一条微博
//            NSMutableArray *launchMessageArray = [MessageTool launchMessageArray];
//            if (launchMessageArray.count > 0) { //如果有发布微博
//                WeiboMessage *launchMessage = [launchMessageArray objectAtIndex:0];
//                //封装frame模型
//            WeiboMessageFrame *messageFrame = [[WeiboMessageFrame alloc] init];
//            messageFrame.message = launchMessage;
//
//            [messageFrameArray insertObject:messageFrame atIndex:0];
//            }
//
//            //对微博数据存储 和 将要显示的数据存储
//            self.messageFrameArray = messageFrameArray;
//            return messageFrameArray;
//
//            [self updateShowMessageFrameArray];
//            NSLog(@"网络请求完毕");
//
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                return messageFrameArray;
//            });
//        }];
//        //创建的task是停止状态，需要启动
//        [task resume];
//    });
//}

@end
