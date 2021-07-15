//
//  ImgDownloadManager.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/7/15.
//

#import "ImgDownloadManager.h"
#import "CacheManager.h"

@interface ImgDownloadManager ()

//缓存管理器
@property (nonatomic,strong)CacheManager *cacheManager;

@end

@implementation ImgDownloadManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static ImgDownloadManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ImgDownloadManager alloc] init];
        instance.cacheManager = [[CacheManager alloc] init];
    });
    
    return instance;
}


///下载/获取 图片
- (void)downloadImageWithURLString:(NSString *)urlString completionBlock:(void (^)(UIImage *))completionBlock {
    //去缓存中查找
    [self.cacheManager imageForKey:urlString findImageBlock:^(UIImage *image) {
        //找到image return
        if (image) {
            completionBlock(image);
        }
        return;
    }];
    
    __block UIImage *image = [[UIImage alloc] init];
    //缓存中不存在 下载
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *imgData = [NSData dataWithContentsOfURL:url];
        image =  [UIImage imageWithData:imgData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image);
        });
    });
    
    //缓存图片
    [self.cacheManager saveImage:image urlString:urlString];
}
@end
