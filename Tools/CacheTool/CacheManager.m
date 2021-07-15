//
//  CacheManager.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/7/15.
//

#import "CacheManager.h"
#import "MemoryCacheManager.h"
#import "DiskCacheManager.h"

@interface CacheManager ()

///内存缓存
@property (nonatomic,strong)MemoryCacheManager *memoryCache;


///硬盘缓存
@property (nonatomic,strong)DiskCacheManager *diskCache;
@end

@implementation CacheManager

///根据URL查找图片
- (void)imageForKey:(NSString *)key findImageBlock:(void (^)(UIImage * ))findImageBlock {
    //在内存中查找
    UIImage *image = [self.memoryCache imageForKey:key];
    if (image) {
        findImageBlock(image);
        return;
    }
    
    //在硬盘中查找
    [self.diskCache imageForKey:key complectionBlock:^(UIImage *image) {
        findImageBlock(image);
        //将图片放入缓存
        if (image) {
            [self.memoryCache setImage:image forKey:key];
        }
    }];
}


///保存文件到内存和磁盘
- (void)saveImage:(UIImage *)image urlString:(NSString *)urlString {
    [self.memoryCache setImage:image forKey:urlString];
    [self.diskCache saveImage:image toURL:urlString];
}

-(instancetype)init {
    if (self = [super init]) {
        self.memoryCache = [[MemoryCacheManager alloc] init];
        self.diskCache = [[DiskCacheManager alloc] init];
    }
    return self;
}


@end
