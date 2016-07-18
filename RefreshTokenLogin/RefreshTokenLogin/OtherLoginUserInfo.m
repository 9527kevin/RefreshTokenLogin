//
//  OtherLoginUserInfo.m
//  DuobaoApp
//
//  Created by ios_kai on 16/7/12.
//  Copyright © 2016年 米迪科技. All rights reserved.
//

#import "OtherLoginUserInfo.h"

@interface OtherLoginUserInfo ()<TencentSessionDelegate>
{
    TencentOAuth *tencentOAuth;
    NSArray *permissions;
    NSMutableDictionary *qqUserInfos;
}

@end

static OtherLoginUserInfo *shareInstance = nil;
@implementation OtherLoginUserInfo

+ (OtherLoginUserInfo *)shareInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareInstance = [[self alloc] init];
        
    });
    
    return shareInstance;
}

#pragma mark - 微信
//调起微信
- (void)tuneUpWXLogin:(WeiXinSuccess)wxUserInfo
{
    NSInteger random = (arc4random() % (int)pow(10, 10)) + (int)pow(10, 10);
    SendAuthReq* req = [[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = [NSString stringWithFormat:@"%ld", (long)random];
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    
    [OtherLoginUserInfo shareInstance].wxUserInfo = wxUserInfo;
}

- (void)getWXloginUserInfo:(SendAuthResp *)sendAuth
{

    NSDictionary *params = @{@"appid" : kWXAppid, @"secret" : kWXAppSecret, @"code" : sendAuth.code, @"grant_type" : @"authorization_code"};
    //通过code获取到access_token和refresh_token
    [DataServer otherLogin:[NSString stringWithFormat:@"%@%@", kWeiXinUrl, kOauth2AccessToken] httpMethod:@"POST" params:params success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *tokenContent = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //                NSLog(@"data   %@", content);
            //通过access_token获取到用户基本信息
            NSDictionary *params = @{@"access_token" : tokenContent[@"access_token"], @"openid" : tokenContent[@"openid"]};
            [DataServer otherLogin:[NSString stringWithFormat:@"%@%@", kWeiXinUrl, kOauth2UserInfo] httpMethod:@"POST" params:params success:^(id data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSMutableDictionary *userInfoContent = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [userInfoContent setValue:tokenContent forKey:@"tokenContent"];

                    if ([OtherLoginUserInfo shareInstance].wxUserInfo != nil) {
                        [OtherLoginUserInfo shareInstance].wxUserInfo(userInfoContent);
                    }
                });
                
            } fail:^(NSError *error) {
                NSLog(@"error  %@", error);
            }];
        });
        
    } fail:^(NSError *error) {
        NSLog(@"error  %@", error);
    }];
    
}

#pragma mark - qq
//调起qq
- (void)tuneUpQQLogin:(QQUserInfo)qqUserInfo
{
    qqUserInfos = [NSMutableDictionary dictionary];
    //3,初始化TencentOAuth 对象 appid来自应用宝创建的应用， deletegate设置为self  一定记得实现代理方法
    
    //这里的appid填写应用宝得到的id  记得修改 “TARGETS”一栏，在“info”标签栏的“URL type”添加 的“URL scheme”，新的scheme。有问题家QQ群414319235提问
    tencentOAuth =[[TencentOAuth alloc] initWithAppId:kQQAppid andDelegate:self];
    
    //4，设置需要的权限列表，此处尽量使用什么取什么。
    permissions = [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
    
    [tencentOAuth authorize:permissions inSafari:NO];
    
    [OtherLoginUserInfo shareInstance].qqUserInfo = qqUserInfo;
}

// TencentSessionDelegate
- (void)tencentDidLogin
{
    if (tencentOAuth.accessToken && 0 != [tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        NSDictionary *tokenInfo = tencentOAuth.mj_keyValues;
//        NSLog(@"tencentOAuth---------> %@", tokenInfo);
        [qqUserInfos setValue:tokenInfo forKey:@"tokenInfo"];
        [tencentOAuth getUserInfo];
    }
    else
    {
        NSLog(@"登录失败");
    }
}

//非网络错误导致登录失败：
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        NSLog(@"取消登录");
    }else{
        NSLog(@"登录失败");
    }
}

// 网络错误导致登录失败：
-(void)tencentDidNotNetWork
{
    NSLog(@"tencentDidNotNetWork");
}

-(void)getUserInfoResponse:(APIResponse *)response
{
    [qqUserInfos setValue:response.jsonResponse forKey:@"qqUserInfo"];
    if ([OtherLoginUserInfo shareInstance].qqUserInfo != nil) {
        [OtherLoginUserInfo shareInstance].qqUserInfo(qqUserInfos);
    }
//    NSLog(@"respons:%@",response.jsonResponse);
}

#pragma mark - 微博
//调起微博
- (void)tuneUpWBLogin:(WBUserInfo)wbUserInfo
{
    //scope 文档地址 http://open.weibo.com/wiki/Scope
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = nil;
    [WeiboSDK sendRequest:request];
    
    [OtherLoginUserInfo shareInstance].wbUserInfo = wbUserInfo;
}

#pragma mark - 通过各平台refresh_token获取access_token
- (void)getIdCodeWithRefreshToken:(NSString *)lastLoginThird
{
    if ([lastLoginThird isEqual:@"weixin"]) {
        NSDictionary *params = @{@"appid" : kWXAppid, @"grant_type" : @"refresh_token", @"refresh_token" : [NSObject getNSUserDefaults:REFRESHTOKEN]};
        
        [DataServer otherLogin:[NSString stringWithFormat:@"%@%@", kWeiXinUrl, kOauth2RefreshToken] httpMethod:@"GET" params:params success:^(id data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([[dic allKeys] containsObject:@"access_token"]) {
                    [NSObject saveNSUserDefaults:REFRESHTOKEN value:dic[@"refresh_token"]];

                }
            });
            
        } fail:^(NSError *error) {
            
        }];
            
    }else if ([lastLoginThird isEqual:@"sina"]) {
            
        NSDictionary *params = @{@"client_id" : kWBAppid, @"client_secret" : kWBAppSecret, @"grant_type" : @"refresh_token", @"redirect_uri" : kRedirectURI, @"refresh_token" : [NSObject getNSUserDefaults:REFRESHTOKEN]};
        //这个地方还是比较坑的，看新浪给的时候以为是GET请求方式，结果AFN返回-1011
        [DataServer otherLogin:[NSString stringWithFormat:@"%@%@", kWBUrl, kWBRefreshToken] httpMethod:@"POST" params:params success:^(id data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //                NSLog(@"dic   %@", dic);
                if ([[dic allKeys] containsObject:@"access_token"]) {

                }
            });
            
        } fail:^(NSError *error) {
            NSLog(@"error %@", error);
            
        }];
    }
}

- (void)saveIdCodeWithRefreshToken:(NSString *)refreshToken withThirdPartyType:(NSString *)thirdPartyType
{
    
}

@end
