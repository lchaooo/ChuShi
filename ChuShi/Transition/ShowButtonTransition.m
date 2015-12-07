//
//  ShowButtonTransition.m
//  WordRecognition
//
//  Created by 李超 on 15/12/6.
//  Copyright © 2015年 李超. All rights reserved.
//

#import "ShowButtonTransition.h"
#import "MainViewController.h"

@implementation ShowButtonTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    //获取两个VC 和 动画发生的容器
    UIViewController *fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MainViewController *toVC   = (MainViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIButton *button = toVC.choosePhotoButton;
    button.hidden = YES;
    
    fromVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    toVC.view.frame = CGRectMake(-SCREEN_WIDTH/3, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_camera"]];
    CGRect frame = toVC.choosePhotoButton.frame;
    frame.origin.y += frame.size.height;
    imageView.frame = frame;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:imageView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        fromVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        toVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        imageView.frame = toVC.choosePhotoButton.frame;
        fromVC.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        fromVC.view.alpha = 1.0;
        button.hidden = NO;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
