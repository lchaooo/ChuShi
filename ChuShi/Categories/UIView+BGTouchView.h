//
//  UIView+BGTouchView.h
//  TBBig
//
//  Created by yuanxiao on 14-4-13.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BGTouchView)


- (void)touchEndedBlock:(void(^)(UIView *selfView))block;

- (void)touchEndedGesture;

- (void)longPressEndedBlock:(void(^)(UIView *selfView))block;

- (void)longPressEndedGesture:(UIGestureRecognizer*)gesture;

@end
