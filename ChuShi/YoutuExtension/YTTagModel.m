//
//  YTTagModel.m
//  Youtu
//
//  Created by 陈颖鹏 on 15/11/5.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "YTTagModel.h"

static NSString * TAG_Name       = @"tag_name";
static NSString * TAG_Confidence  = @"tag_confidence";

@implementation YTTagModel

- (id)initWithInfoDic:(NSDictionary *)infoDic
{
    self = [super init];
    if (self && infoDic) {
        self.tag_name = infoDic[TAG_Name];
        self.tag_confidence = [infoDic[TAG_Confidence] integerValue];
    }
    
    return self;
}

+ (NSArray *)orderedTAGsWithRawArray:(NSArray *)rawArray
{
    if (!rawArray || rawArray.count == 0) {
        return nil;
    }
    
//    NSMutableArray *orderedTAGs  = [NSMutableArray arrayWithCapacity:rawArray.count];
//    [orderedTAGs addObject:[[YTTagModel alloc] initWithInfoDic:rawArray.firstObject]];
//    for (NSInteger i = 1; i < rawArray.count; i++) {
//        BOOL inserted = NO;
//        YTTagModel *newModel = [[YTTagModel alloc] initWithInfoDic:rawArray[i]];
//        
//        for (NSInteger j = 0; j < orderedTAGs.count; i++) {
//            YTTagModel *oldModel = orderedTAGs[j];
//            if (newModel.tag_confidence > oldModel.tag_confidence) {
//                [orderedTAGs insertObject:newModel atIndex:j];
//                inserted = YES;
//                break;
//            }
//        }
//        
//        if (!inserted) {
//            [orderedTAGs addObject:newModel];
//        }
//    }
    YTTagModel *maxModel = nil;
    for (NSDictionary *info in rawArray) {
        YTTagModel *model = [[YTTagModel alloc] initWithInfoDic:info];
        if (maxModel) {
            if (model.tag_confidence > maxModel.tag_confidence) {
                maxModel = model;
            }
        } else {
            maxModel = model;
        }
    }
    
    return @[maxModel];
//    return orderedTAGs;
}

+ (YTTagModel *)mostPossibleTAG:(NSArray *)orderedArray
{
    return orderedArray.count==0?nil:[orderedArray firstObject];
}

@end
