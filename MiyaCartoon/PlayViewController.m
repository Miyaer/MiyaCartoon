//
//  PlayViewController.m
//  MiyaCartoon
//
//  Created by miya on 16/6/20.
//  Copyright © 2016年 miya. All rights reserved.
//

#import "PlayViewController.h"
#import "AFNetworking.h"
#import <WebKit/WebKit.h>
@interface PlayViewController ()
@property (nonatomic,strong) WKWebView * webView;
@property (nonatomic,strong) NSString * webUrl;
@property (nonatomic,strong) AFHTTPSessionManager * manager;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    _webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    
    
    [self createleft];
    }
- (void)createleft{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,BTNSIZE,BTNHEIGHT)];
    [btn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
-(void)btnClick1:(UIButton *)btn{
    [_webView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadData{
    NSString * url = [NSString stringWithFormat:YP_URL,self.vid,self.cid,self.eid,self.dateID];
    [self.manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * array = dic[@"list"];
        
        NSDictionary * dict = [array firstObject];
        self.webUrl = dict[@"pageUrl"];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
        [_webView loadRequest:request];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求数据失败");
    }];
}
- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager;
}
@end
