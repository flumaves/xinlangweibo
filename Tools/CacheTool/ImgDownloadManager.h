//
//  ImgDownloadManager.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/7/15.
//

#import <Foundation/Foundation.h>
#import "CacheManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImgDownloadManager : NSObject

+ (instancetype)sharedManager;

- (void)downloadImageWithURLString:(NSString *)urlString completionBlock:(void (^)(UIImage *))completionBlock;

@end

NS_ASSUME_NONNULL_END
