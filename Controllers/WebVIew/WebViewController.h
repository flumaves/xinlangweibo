//
//  WebViewController.h
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/12.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController

- (void)loadWebViewWithUrl:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
