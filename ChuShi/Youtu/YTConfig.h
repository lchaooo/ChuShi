//
//  YTConfig.h
//  Youtu
//
//  Created by 陈颖鹏 on 15/11/5.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTConfig : NSObject

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *secretId;
@property (nonatomic, copy) NSString *secretKey;

@property (nonatomic, copy) NSString *userId;

/**
 *  单例
 *
 *  @return 单例
 */
+ (YTConfig *)sharedInstance;

@end
