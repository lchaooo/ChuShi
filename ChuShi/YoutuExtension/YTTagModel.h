//
//  YTTagModel.h
//  Youtu
//
//  Created by 陈颖鹏 on 15/11/5.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTTagModel : NSObject

@property (nonatomic, copy  ) NSString  *tag_name;
@property (nonatomic, assign) NSInteger  tag_confidence;


- (id)initWithInfoDic:(NSDictionary *)infoDic;

/**
 *  排好序的数组，以tag_confidence降序排列
 *
 *  @param rawArray <#rawArray description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray *)orderedTAGsWithRawArray:(NSArray *)rawArray;

/**
 *  置信度最高的TAG
 *
 *  @param rawArray <#rawArray description#>
 *
 *  @return <#return value description#>
 */
+ (YTTagModel *)mostPossibleTAG:(NSArray *)orderedArray;

@end
