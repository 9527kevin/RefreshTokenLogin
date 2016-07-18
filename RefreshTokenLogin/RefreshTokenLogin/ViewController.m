//
//  ViewController.m
//  RefreshTokenLogin
//
//  Created by ios_kai on 16/7/18.
//  Copyright © 2016年 ios_kai. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *weixinBu = [[UIButton alloc] initWithFrame:CGRectMake(60, 100, 100, 40)];
    weixinBu.backgroundColor = [UIColor redColor];
    [weixinBu setTitle:@"微信" forState:UIControlStateNormal];
    [weixinBu addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinBu];
    
    UIButton *QQBu = [[UIButton alloc] initWithFrame:CGRectMake(60, 160, 100, 40)];
    QQBu.backgroundColor = [UIColor redColor];
    [QQBu setTitle:@"QQ" forState:UIControlStateNormal];
    [QQBu addTarget:self action:@selector(QQlogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:QQBu];
    
    UIButton *sinaBu = [[UIButton alloc] initWithFrame:CGRectMake(60, 220, 100, 40)];
    sinaBu.backgroundColor = [UIColor redColor];
    [sinaBu setTitle:@"新浪" forState:UIControlStateNormal];
    [sinaBu addTarget:self action:@selector(sinaLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sinaBu];
    
}


- (void)weixinLogin
{
    [[OtherLoginUserInfo shareInstance] tuneUpWXLogin:^(id useInfo) {
        NSLog(@"微信用户信息 -----------------> %@", useInfo);
        
        [NSObject saveNSUserDefaults:REFRESHTOKEN value:useInfo[@"tokenContent"][@"refresh_token"]];
        [NSObject saveNSUserDefaults:LASTLOGINTHIRD value:@"weixin"];
        
    }];
}

- (void)QQlogin
{
    [[OtherLoginUserInfo shareInstance] tuneUpQQLogin:^(id userInfo) {
        
        NSLog(@"QQ用户信息 -----------------> %@", userInfo);
    }];
}

- (void)sinaLogin
{
    [[OtherLoginUserInfo shareInstance] tuneUpWBLogin:^(id userInfo) {
        NSLog(@"新浪微博token -----------------> %@", userInfo);
        
        NSDictionary *params = @{@"access_token" : userInfo[@"access_token"], @"uid" : userInfo[@"uid"]};
        [DataServer otherLogin:[NSString stringWithFormat:@"%@%@", kWBUrl, k2UsersShow] httpMethod:@"GET" params:params success:^(id data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *userInfoContent = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"新浪用户信息 -----------------> %@", userInfoContent);
                [NSObject saveNSUserDefaults:REFRESHTOKEN value:userInfo[@"refresh_token"]];
                [NSObject saveNSUserDefaults:LASTLOGINTHIRD value:@"sina"];
                
            });
            
            
        } fail:^(NSError *error) {
            
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

