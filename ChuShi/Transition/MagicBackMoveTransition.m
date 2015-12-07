//
//  MaginBackMoveTransition.m
//  WordRecognition
//
//  Created by 李超 on 15/12/6.
//  Copyright © 2015年 李超. All rights reserved.
//

#import "MagicBackMoveTransition.h"
#import "CardListViewController.h"
#import "CardViewController.h"

@implementation MagicBackMoveTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    //获取动画前后两个VC 和 发生的容器containerView
    CardViewController *toVC = (CardViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CardListViewController *fromVC = (CardListViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor whiteColor];
    
    //在前一个VC上创建一个截图
    UIView *snapShotView = [fromVC.backButton snapshotViewAfterScreenUpdates:NO];
    snapShotView.backgroundColor = [UIColor clearColor];
    snapShotView.frame = [containerView convertRect:fromVC.backButton.frame fromView:fromVC.view];
    fromVC.backButton.hidden = YES;
    
    //初始化后一个VC的位置
    CGRect frame = [transitionContext finalFrameForViewController:toVC];
    frame.origin.x -= frame.size.width/3;
    toVC.view.frame = frame;
    
    UIButton *button = toVC.backButton;
    button.hidden = YES;
    
    //顺序很重要，
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView addSubview:snapShotView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        fromVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        fromVC.view.alpha = 0.0f;
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    } completion:^(BOOL finished) {
        [snapShotView removeFromSuperview];
        fromVC.backButton.hidden = NO;
        button.hidden = NO;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


@end
