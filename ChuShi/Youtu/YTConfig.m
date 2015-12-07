//
//  YTConfig.m
//  Youtu
//
//  Created by 陈颖鹏 on 15/11/5.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "YTConfig.h"

@implementation YTConfig

+ (YTConfig *)sharedInstance
{
    static YTConfig *__shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [[YTConfig alloc] init];
        [__shared setup];
    });
    
    return __shared;
}

/**
 *  配置基本key
 */
- (void)setup
{
    self.appId = @"1003873";
    self.secretId = @"AKIDq3lEBmCzlMdnW9iBFmzuuVoPSNPFIE1l";
    self.secretKey = @"rR5TtoK8bAvhyqUc021H28uBSqotaxlN";
}

@end
