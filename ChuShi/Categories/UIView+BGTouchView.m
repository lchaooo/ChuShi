//
//  UIView+BGTouchView.m
//  TBBig
//
//  Created by yuanxiao on 14-4-13.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import "UIView+BGTouchView.h"
#import <objc/runtime.h>
static const void *BGTouchEndedViewBlockKey = &BGTouchEndedViewBlockKey;
static const void *BGTouchLongPressEndedViewBlockKey = &BGTouchLongPressEndedViewBlockKey;

@implementation UIView (BGTouchView)

- (void)touchEndedBlock:(void (^)(UIView *selfView))block
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(touchEndedGesture)];
    tapped.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapped];
    objc_setAssociatedObject(self, BGTouchEndedViewBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)touchEndedGesture
{
    void(^_touchBlock)(UIView *selfView) = objc_getAssociatedObject(self, BGTouchEndedViewBlockKey);
    if (_touchBlock) {
        _touchBlock(self);
    }
}

-(void)longPressEndedBlock:(void (^)(UIView *selfView))block
{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressEndedGesture:)];
    longPress.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPress];
    objc_setAssociatedObject(self, BGTouchLongPressEndedViewBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)longPressEndedGesture:(UIGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        void(^_touchBlock)(UIView *selfView) = objc_getAssociatedObject(self, BGTouchLongPressEndedViewBlockKey);
        if (_touchBlock) {
            _touchBlock(self);
        }
    }
}
@end
