//
//  CacheManager.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/7/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CacheManager : NSObject

///根据url查找图片
- (void)imageForKey:(NSString *)key findImageBlock:(void (^)(UIImage *))findImageBlock;

///保存图片到内存和硬盘
- (void)saveImage:(UIImage *)image urlString:(NSString *)urlString;
@end

NS_ASSUME_NONNULL_END
