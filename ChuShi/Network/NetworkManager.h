//
//  NetworkManager.h
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/7.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

/**
 *  单例
 *
 *  @return <#return value description#>
 */
+ (NSURLSession *)sharedSession;

/**
 *  将中文翻译到英文
 *
 *  @param word  <#word description#>
 *  @param block <#block description#>
 *
 *  @return <#return value description#>
 */
+ (NSURLSessionDataTask *)translate2English:(NSString *)word ok:(void (^)(NSString *english, NSError *error))block;

@end
