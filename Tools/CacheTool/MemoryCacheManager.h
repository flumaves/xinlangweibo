//
//  MemoryCacheManager.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/7/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemoryCacheManager : NSObject

//根据URL设置缓存
- (void)setImage:(UIImage *)image forKey:(NSString *)key;

//根据URL获取缓存的图片
- (UIImage *)imageForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
