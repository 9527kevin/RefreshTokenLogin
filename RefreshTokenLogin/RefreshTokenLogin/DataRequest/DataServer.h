//
//  DataServer.h
//  AFNetWorking
//
//  Created by ios_kai on 15/4/1.
//  Copyright (c) 2015年 米迪科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataServer : NSObject

+(void)otherLogin:(NSString *)urlstring
             httpMethod:(NSString *)method
                 params:(NSDictionary *)parmas
                success:(void (^)(id data))success
                   fail:(void(^)(NSError *error))fail;


@end
