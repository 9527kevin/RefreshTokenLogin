//
//  OtherLoginApi.h
//  DuobaoApp
//
//  Created by ios_kai on 16/7/12.
//  Copyright © 2016年 米迪科技. All rights reserved.
//

#ifndef OtherLoginApi_h
#define OtherLoginApi_h

#define kRedirectURI    @"http://sns.whalecloud.com/sina2/callback"

#define kWeiXinUrl                          @"https://api.weixin.qq.com/sns/"   //微信Api
#define kOauth2AccessToken                  @"oauth2/access_token"              //通过code获取access_token
#define kOauth2RefreshToken                 @"oauth2/refresh_token"             //获取第一步的code后，请求以下链接进行refresh_token
#define kOauth2UserInfo                     @"userinfo"                         //获取用户个人信息

#define kQQUrl                              @"http://openapi.tencentyun.com/"   //QQApi
#define kV3UserGetInfo                      @"v3/user/get_info"                 //获取用户基本资料

#define kWBUrl                              @"https://api.weibo.com/"           //微博Api
#define k2UsersShow                         @"2/users/show.json"                //获取微博用户资料
#define kWBRefreshToken                     @"oauth2/access_token"              //

//大家需要把这些信息换成自己从开放平台中申请下来的信息
#define kWXAppid            @""
#define kWXAppSecret        @""
#define kQQAppid            @""
#define kQQAppSecret        @""
#define kWBAppid            @""
#define kWBAppSecret        @""


#endif /* OtherLoginApi_h */
