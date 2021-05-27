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

@end
