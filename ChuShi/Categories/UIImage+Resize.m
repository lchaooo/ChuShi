//
//  UIImage+Resize.m
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/8.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "UIImage+Resize.h"

@import QuartzCore;

@implementation UIImage (Resize)

+ (UIImage *)cutImage:(UIImage *)originImage size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, SCREEN_SCALE);
    //    UIGraphicsBeginImageContext(size); //size 为CGSize类型，即你所需要的图片尺寸
    [originImage drawInRect:CGRectMake(0, 0, size.height, size.width)]; //newImageRect指定了图片绘制区域
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
