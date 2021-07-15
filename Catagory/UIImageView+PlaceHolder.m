//
//  UIImageView+PlaceHolder.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/7/15.
//

#import "UIImageView+PlaceHolder.h"
#import "ImgDownloadManager.h"

@implementation UIImageView (HJImageView)

- (void)setImageWithURLString:(NSString *)urlString {
    //设置灰色背景为占位
    self.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    
    // 下载/获取 图片
    [[ImgDownloadManager sharedManager] downloadImageWithURLString:urlString completionBlock:^(UIImage *image) {
        self.image = image;
    }];
}

@end
