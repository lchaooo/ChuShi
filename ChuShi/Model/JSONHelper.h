//
//  JSONHelper.h
//  WordRecognition
//
//  Created by 李超 on 15/12/6.
//  Copyright © 2015年 李超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONHelper : NSObject

@property (nonatomic, strong) NSDictionary *dataDic;

+ (instancetype)sharedInstance;

- (NSMutableArray *)getCardArrayWithIdentifier:(NSString *)identifier;

@end
