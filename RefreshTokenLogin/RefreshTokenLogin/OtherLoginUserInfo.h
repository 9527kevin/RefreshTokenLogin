//
//  OtherLoginUserInfo.h
//  DuobaoApp
//
//  Created by ios_kai on 16/7/12.
//  Copyright © 2016年 米迪科技. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WeiXinSuccess)(id userInfo);
typedef void(^QQUserInfo)(id userInfo);
typedef void(^WBUserInfo)(id userInfo);

@class SendAuthResp;


@interface OtherLoginUserInfo : NSObject

+ (OtherLoginUserInfo *)shareInstance;
/**
 *  调起微信客户端
 *
 *  @param success 调起以后获取微信用户信息
 */
- (void)tuneUpWXLogin:(WeiXinSuccess)success;

/**
 *  获取微信用户信息
 *
 *  @param resp    resp类，获取code，用code获取access_token
 *  @param success 获取到的用户信息
 */
- (void)getWXloginUserInfo:(SendAuthResp *)resp;

/**
 *  获取QQ用户信息
 *
 *  @param qqUserInfo 获取到的用户信息
 */
- (void)tuneUpQQLogin:(QQUserInfo)qqUserInfo;

/**
 *  获取微博用户信息
 *
 *  @param wbUserInfo 获取到的用户信息
 */
- (void)tuneUpWBLogin:(WBUserInfo)wbUserInfo;

/**
 *  通过refresh_token获取到access_token，再通过access_token获取到idCode
 *
 *  @param lastLoginThird 最后一次登录的第三方平台
 */
- (void)getIdCodeWithRefreshToken:(NSString *)lastLoginThird;


@property (nonatomic, copy) WeiXinSuccess success;
@property (nonatomic, copy) QQUserInfo  qqUserInfo;
@property (nonatomic, copy) WBUserInfo  wbUserInfo;


@end
