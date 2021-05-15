//
//  WebViewController.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/12.
//

#import "WebViewController.h"

@interface WebViewController () <WKNavigationDelegate>

@property (nonatomic, strong)WKWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    
    _webView.navigationDelegate = self;
    
    [self.view addSubview:_webView];
}

- (void)loadWebViewWithUrl:(NSURL *)URL {
    [self viewDidLoad];

    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    [_webView loadRequest:request];
}

//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
//    NSLog(@"%s",__func__);
//}
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSLog(@"%s",__func__);
//}
//
//- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"%s",__func__);
//}
//
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
//    NSLog(@"%s",__func__);
//    [webView reload];
//}

@end
