//
//  NSObject+Tool.m
//  ZDQKFramework
//
//  Created by apple on 14-3-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "NSObject+Tool.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSObject (Tool)

+ (void)saveNSUserDefaults:(id)key value:(id)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (id)getNSUserDefaults:(id)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:key] ? [defaults valueForKey:key] : @"";
}

@end
