//
//  DataServer.m
//  AFNetWorking
//
//  Created by ios_kai on 15/4/1.
//  Copyright (c) 2015年 米迪科技. All rights reserved.
//

#import "DataServer.h"
#import "AFNetworking.h"

@implementation DataServer


+(void)otherLogin:(NSString *)urlstring
            httpMethod:(NSString *)method
                params:(NSDictionary *)parmas
               success:(void (^)(id data))success
                  fail:(void(^)(NSError *error))fail
{
    //编码
    NSString *encodeURL = [urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer              = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer             = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/xml", @"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    
    //设置解析格式JSON,默认为JSON
    //    设置解析XML [AFXMLParserResponseSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    //这个地方调起微信接口的时候不能用上面那个方法，因为控制台总是会报告错误，不被识别的 text/plain
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if ([[method uppercaseString] isEqualToString:@"GET"]) {
        //GET请求
        [manager GET:encodeURL
          parameters:parmas
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 if (success) {
                     success(responseObject);
                 }
             }
         
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 if (fail) {
                     fail(error);
                 }
             }];
    }else if ([[method uppercaseString] isEqualToString:@"POST"]){
        //POST请求
        
        [manager POST:encodeURL parameters:parmas success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (success) {
                success(responseObject);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (fail) {
                fail(error);
            }
            
        }];
    }
}



@end
