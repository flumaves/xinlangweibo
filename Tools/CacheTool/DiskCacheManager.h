//
//  DiskCacheManager.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/7/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiskCacheManager : NSObject

///根据图片下载链接，在沙河中查找文件
- (void)imageForKey:(NSString *)key complectionBlock:(void(^)(UIImage *))completionBlock;

///保存图片到沙盒
- (void)saveImage:(UIImage *)image toURL:(NSString *)urlString;
@end

NS_ASSUME_NONNULL_END
