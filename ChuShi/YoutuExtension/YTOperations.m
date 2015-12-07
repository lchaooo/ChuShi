//
//  YTOperations.m
//  Youtu
//
//  Created by 陈颖鹏 on 15/11/7.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "YTOperations.h"

#import "YTResponseKeys.h"

static NSString * const YTAPIBaseURLString = @"http://api.youtu.qq.com/youtu";

@implementation YTOperations

+ (void)identifyImage:(UIImage *)image ok:(void (^)(NSArray *array, NSError *error))block
{
    if (!image) {
        return ;
    }
    
    NSString *auth = [Auth appSign:1000000 userId:nil];
    TXQcloudFrSDK *sdk = [[TXQcloudFrSDK alloc] initWithName:[[YTConfig sharedInstance] appId] authorization:auth];
    sdk.API_END_POINT = YTAPIBaseURLString;
    
    [sdk imageTag:image cookie:nil seq:nil successBlock:^(id responseObject) {
        if (responseObject) {
            if ([responseObject[YTErrorCode] integerValue] == 0) {
                NSArray *tags = responseObject[YTTAGs];
                if (tags) {
                    // 如果有tags的话，
                    // 以排好序的数组返回
                    block([YTTagModel orderedTAGsWithRawArray:tags], nil);
                } else {
                    block([NSArray array], nil);
                }
            } else {
                NSError *error = [NSError errorWithDomain:YTAPIBaseURLString
                                                     code:[responseObject[YTErrorCode] integerValue]
                                                 userInfo:@{YTErrorMsg: responseObject[YTErrorMsg]?:[NSString string]}];
                block(nil, error);
            }
        } else {
            NSLog(@"无返回数据。");
            block([NSArray array], nil);
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"error : %@", error.localizedDescription);
        block(nil, error);
    }];
}

@end
