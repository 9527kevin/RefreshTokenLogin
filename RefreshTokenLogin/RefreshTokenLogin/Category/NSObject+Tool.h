//
//  NSObject+Tool.h
//  ZDQKFramework
//
//  Created by apple on 14-3-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Tool)

+ (void)saveNSUserDefaults:(id)key value:(id)value;

+ (id)getNSUserDefaults:(id)key;



@end
