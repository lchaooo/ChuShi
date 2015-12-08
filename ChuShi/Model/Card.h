//
//  Card.h
//  WordRecognition
//
//  Created by 李超 on 15/12/3.
//  Copyright © 2015年 李超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject <NSCopying>

@property (nonatomic, assign) NSUInteger imageCounts;
@property (nonatomic, strong) NSString *chinese;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *english;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) NSInteger identifier;

- (instancetype)init;
- (id)copyWithZone:(NSZone *)zone;
- (NSString *)description;

@end
