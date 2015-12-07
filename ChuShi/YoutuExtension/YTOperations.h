//
//  YTOperations.h
//  Youtu
//
//  Created by 陈颖鹏 on 15/11/7.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TXQcloudFrSDK.h"
#import "YTConfig.h"
#import "Auth.h"

#import "YTTagModel.h"

@interface YTOperations : NSObject

/**
 *  识别图像的tags
 *
 *  @param image <#image description#>
 *  @param block <#block description#>
 */
+ (void)identifyImage:(UIImage *)image ok:(void (^)(NSArray *array, NSError *error))block;

@end
