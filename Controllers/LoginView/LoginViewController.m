//
//  LoginViewController.m
//  xinlangweibo
//
//  Created by little_Fking_cute on 2021/5/7.
//

#import "LoginViewController.h"
#import <WebKit/WebKit.h>
#import "UserAccount.h"
#import "UserAccountTool.h"
#import "WeiboMessage.h"

@interface LoginViewController () <WKNavigationDelegate>

@property (nonatomic, strong)WKWebView *loginView;

@property (nonatomic, strong)NSString *access_token;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.loginView = [[WKWebView alloc] initWithFrame:self.view.frame];
    self.loginView.backgroundColor = [UIColor whiteColor];
    self.loginView.navigationDelegate = self;
    
    NSURL *url = [self loadOAuthURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.loginView loadRequest:request];

    [self.view addSubview:_loginView];
}

#pragma mark - WKWebView的代理方法
//监听服务器的响应
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSString *host = navigationResponse.response.URL.host;
    NSString *query = navigationResponse.response.URL.query;
    
    NSLog(@"host----%@",host);
    NSLog(@"query----%@",query);

    if ([host containsString:@"api.weibo.com"]) {
        if ([query containsString:@"code="]) {
            //用户同意授权
            NSLog(@"用户同意授权");
            decisionHandler(WKNavigationResponsePolicyAllow);
            
            //提取授权码
            NSString *code = [query substringFromIndex:5];
            NSLog(@"code----%@",code);
            //获取access_token
            _access_token = [self getAccessTokenWithCode:code];
            
            //返回主页面
            [self.navigationController popViewControllerAnimated:YES];
            
            return;
        } else if ([query containsString:@"error"]) {
            //用户取消授权
            NSLog(@"用户取消授权");
            decisionHandler(WKNavigationResponsePolicyCancel);
            
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - 获取登陆的路径
- (NSURL *)loadOAuthURL {
    ///应用程序信息
    //    App Key：
    //    3240248154
    //    App Secret：
    //    8a51150c3d1050bdfd1d0183c6e6e02f
    //  https://api.weibo.com/oauth2/authorize
    //  授权回调页：https://api.weibo.com/oauth2/default.html
    //  取消授权回调页：https://api.weibo.com/oauth2/default.html
    NSString *client_id = @"849752584";
    NSString *baseURL = @"https://api.weibo.com/oauth2/authorize";
    NSString *redirect_uri = @"https://api.weibo.com/oauth2/default.html";
    
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",baseURL, client_id ,redirect_uri];

    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

#pragma mark - 获取access_token
- (NSString *)getAccessTokenWithCode:(NSString *)code {
    //post请求
    NSString *client_id = @"3240248154";
    NSString *client_secret = @"91ce9498571f054d4b55b6bfd406f0f7";
    NSString *redirect_uri = @"https://api.weibo.com/oauth2/default.html";
    NSString *baseURLString = @"https://api.weibo.com/oauth2/access_token";

    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&grant_type=authorization_code&code=%@&redirect_uri=%@",baseURLString ,client_id, client_secret, code, redirect_uri];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *str = @"type=focus-c";    //设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];

    NSURLSession *session = [NSURLSession sharedSession];
    
    __block NSString *access_token = [[NSString alloc] init];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        access_token = [dict objectForKey:@"access_token"];
        //账户信息转成模型
        UserAccount *account = [UserAccount accountWithDictionary:dict];
        //储存账户信息
        [UserAccountTool saveAccount:account];
        
        [self deleteWebCache];
        NSLog(@"%@",account.access_token);

        NSLog(@"dict----%@",dict);
        NSLog(@"access_token----%@",access_token);
    }];
    //创建的task是停止状态，需要启动
    [task resume];
    
    return access_token;
}

- (void)deleteWebCache {
    NSSet *webDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:webDataTypes modifiedSince:dateFrom completionHandler:^{
            NSLog(@"清空webView缓存");
    }];
}

@end
