//
//  UIImage+Resize.h
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/8.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

/**
 *  设置大小
 *
 *  @param originImage <#originImage description#>
 *  @param size        <#size description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)cutImage:(UIImage *)originImage size:(CGSize)size;

@end
