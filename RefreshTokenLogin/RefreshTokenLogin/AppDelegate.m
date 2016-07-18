//
//  AppDelegate.m
//  RefreshTokenLogin
//
//  Created by ios_kai on 16/7/18.
//  Copyright © 2016年 ios_kai. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<WeiboSDKDelegate, WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [WXApi registerApp:kWXAppid];
    [WeiboSDK registerApp:kWBAppid];
    
    
    //对于access_token过期的用户，客户端进行处理，不用自己再去授权登录
    NSString *lastLogin = [NSObject getNSUserDefaults:LASTLOGINTHIRD];
    if (![lastLogin isEqual:@""]) {
        [[OtherLoginUserInfo shareInstance] getIdCodeWithRefreshToken:lastLogin];
    }
    
    return YES;
}

//iOS9 之后使用这个回调方法。
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSLog(@"url--------> %@", url);
    if ([[NSString stringWithFormat:@"%@", url] hasPrefix:[NSString stringWithFormat:@"%@://oauth", kWXAppid]]) {
        BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
        return  isSuc;
    }
    
    if ([[NSString stringWithFormat:@"%@", url] hasPrefix:[NSString stringWithFormat:@"tencent%@://qzapp/mqzone", kQQAppid]]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    if ([[NSString stringWithFormat:@"%@", url] hasPrefix:[NSString stringWithFormat:@"wb%@://response", kWBAppid]]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    return YES;
}

//看到每个开放平台都写了这个方法，但是通过回调发现，不会走这个方法，不知道什么原因，所以没办法分辨是哪个平台的回调
#pragma mark -
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    return  [WXApi handleOpenURL:url delegate:self];
}


/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"url--------> %@", url);
    if ([[NSString stringWithFormat:@"%@", url] hasPrefix:[NSString stringWithFormat:@"%@://oauth", kWXAppid]]) {
        BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
        return  isSuc;
    }
    
    if ([[NSString stringWithFormat:@"%@", url] hasPrefix:[NSString stringWithFormat:@"tencent%@://qzapp/mqzone", kQQAppid]]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    if ([[NSString stringWithFormat:@"%@", url] hasPrefix:[NSString stringWithFormat:@"wb%@://response", kWBAppid]]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    return YES;
}

#pragma mark - 微信
-(void)onResp:(BaseResp*)resp
{
    if ([resp isMemberOfClass:[SendAuthResp class]]) {
        SendAuthResp *sendAuth = (SendAuthResp *)resp;
        //        NSLog(@"resp.code  %@", sendAuth.code);
        [[OtherLoginUserInfo shareInstance] getWXloginUserInfo:sendAuth];
        
    }
    
}


//新浪微博
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
}

//新浪微博获取用户信息回调
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            if ([OtherLoginUserInfo shareInstance].wbUserInfo != nil) {
                [OtherLoginUserInfo shareInstance].wbUserInfo(response.userInfo);
            }
        }
    }
}


@end

