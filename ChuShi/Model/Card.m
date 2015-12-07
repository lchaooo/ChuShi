//
//  Card.m
//  WordRecognition
//
//  Created by 李超 on 15/12/3.
//  Copyright © 2015年 李超. All rights reserved.
//

#import "Card.h"
#import <FMDB.h>
#import "NSString+Process.h"

@implementation Card

- (NSString *)description {
    return [NSString stringWithFormat:@"chinese = %@, english = %@, pinyin = %@ count = %lu identifier = %lu", self.chinese, self.english, self.pinyin, (unsigned long)self.imageCounts, (unsigned long)self.identifier];
}

- (id)copyWithZone:(NSZone *)zone {
    id p = [[self class] allocWithZone:zone];
    [p setImageCounts:_imageCounts chinese:_chinese pinyin:_pinyin english:_english images:_images identifier:_identifier];
    return p;
}

#pragma mark custom
- (void)setChinese:(NSString *)chinese {
    _chinese = chinese;
    _pinyin = [chinese pinyin];
}

- (void)setImageCounts:(NSUInteger)imageCounts chinese:(NSString *)chinese pinyin:(NSString *)pinyin english:(NSString *)english images:(NSArray *)images identifier:(int)identifier {
    _imageCounts = imageCounts;
    _chinese = chinese;
    _pinyin = pinyin;
    _english = english;
    _images = [images mutableCopy];
    _identifier = identifier;
}

@end