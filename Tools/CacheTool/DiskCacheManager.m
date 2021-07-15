//
//  DiskCacheManager.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/7/15.
//

#import "DiskCacheManager.h"
#import "UserAccount.h"
#import "UserAccountTool.h"

//硬盘缓存阈值
#define maxDiskCacheSize 1024 * 1024 * 100 //50MB

@interface DiskCacheManager ()

//沙盒目录路径
@property (nonatomic, strong)NSString *cacheDirection;

@end

@implementation DiskCacheManager

///储存文件到目录
- (void)saveImage:(UIImage *)image toURL:(NSString *)urlString {
    if (!image) {
        return;
    }
    
    __block NSString *sandBoxPath = self.cacheDirection;
    //异步储存
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //拼接路径名字
        NSString *savePath = [sandBoxPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archive",urlString]];
        //判断文件是否存在
        BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:savePath];
        
        if (!isExists) {
            //image转为data数据
            NSData *imageData = UIImageJPEGRepresentation(image,1.0f);
            
            [imageData writeToFile:savePath atomically:YES];
        }
    });
}


///根据图片URL，在沙盒中找到文件
- (void)imageForKey:(NSString *)key complectionBlock:(void (^)(UIImage * _Nonnull))completionBlock {
    
    NSString *sandBoxPath = self.cacheDirection;
    //异步获取
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //拼接路径名字
        NSString *getPath = [sandBoxPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archive",key]];
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:getPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image);
        });
    });
}

///获取沙盒目录路径
- (NSString *)cacheDirection {
    if (_cacheDirection == nil) {
        NSString *sandBoxDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        // 拼接 url_imageCache
        NSString *appendString = [NSString stringWithFormat:@"%@_imgageCache",[UserAccountTool account].uid];
        
        _cacheDirection = [sandBoxDir stringByAppendingPathComponent:appendString];
        
        //判断文件夹是否存在
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL fileExists = [fileManager fileExistsAtPath:_cacheDirection];
        if (!fileExists) {  //不存在文件夹
            //创建文件夹
            [fileManager createDirectoryAtPath:_cacheDirection withIntermediateDirectories:YES attributes:nil error:nil];
        } else {
            //文件存在 ，判断是否超出内存限制
            NSUInteger totalSize = [self calculateTotalSize];
            //超出最大内存限制
            if (totalSize > maxDiskCacheSize) {
                //清空硬盘缓存
                [fileManager removeItemAtPath:_cacheDirection error:nil];
                //重新创建目录
                [fileManager createDirectoryAtPath:_cacheDirection withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
    }
    return _cacheDirection;
}

///计算文件内存大小
- (NSUInteger)calculateTotalSize {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subFilePaths = [fileManager subpathsAtPath:_cacheDirection];
    //文件夹中子文件数目为零 直接返回
    if (subFilePaths.count == 0) {
        return 0;
    }
    //计算size大小
    __block NSUInteger totalSize  = 0;
    [subFilePaths enumerateObjectsUsingBlock:^(id  _Nonnull fileName, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *filePath = [_cacheDirection stringByAppendingPathComponent:fileName];
            
            totalSize += [fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
    }];
    
    return totalSize;
}
@end
