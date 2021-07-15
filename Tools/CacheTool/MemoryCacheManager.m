//
//  MemoryCacheManager.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/7/15.
//

#import "MemoryCacheManager.h"

//最大缓存图片的数目
#define maxImgCacheCount 100

@interface MemoryCacheManager ()

/// 缓存
@property (nonatomic,strong)NSCache *memoryCache;

@end

@implementation MemoryCacheManager

//监听内存警告

//接收警告 删除图片

/// 根据URL设置缓存
- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    if ([self.memoryCache objectForKey:key] == nil) {   //缓存中不存在要进行缓存的图片，执行缓存操作
        [self.memoryCache setObject:image forKey:key];
    } else {
        return;
        //缓存中存在将要缓存的图片，取消重复缓存
    }
}


///根据URL获取图片
- (UIImage *)imageForKey:(NSString *)key {
    return [self.memoryCache objectForKey:key];
}

- (NSCache *)memoryCache {
    if (_memoryCache == nil) {
        _memoryCache = [[NSCache alloc] init];
        //设置最大缓存数目
        _memoryCache.countLimit = maxImgCacheCount;
    }
    return _memoryCache;
}

@end
