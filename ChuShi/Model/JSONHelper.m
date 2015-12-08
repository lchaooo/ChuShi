//
//  JSONHelper.m
//  WordRecognition
//
//  Created by 李超 on 15/12/6.
//  Copyright © 2015年 李超. All rights reserved.
//

#import "JSONHelper.h"
#import "Card.h"

@implementation JSONHelper

+ (instancetype)sharedInstance{
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"neizhi" ofType:@"plist"];
        self.dataDic = [NSDictionary dictionaryWithContentsOfFile:plist];
    }
    return self;
}

- (NSMutableArray *)getCardArrayWithIdentifier:(NSString *)identifier {
    NSArray *array = self.dataDic[identifier];
    NSMutableArray *cardArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        Card *card = [[Card alloc] init];
        card.chinese = dic[@"chinese"];
        card.english = dic[@"english"];
        card.imageCounts = [dic[@"imageCount"] integerValue];
        card.identifier = 0;
        NSMutableArray *imageArray = [NSMutableArray array];
        for (int i = 1; i <= card.imageCounts; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%d",card.english, i]];
            [imageArray addObject:image];
        }
        card.images = imageArray;
        [cardArray addObject:card];
    }
    return cardArray;
}

@end
