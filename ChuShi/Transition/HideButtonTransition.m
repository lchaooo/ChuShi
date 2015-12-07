//
//  HideButtonTransition.m
//  WordRecognition
//
//  Created by 李超 on 15/12/6.
//  Copyright © 2015年 李超. All rights reserved.
//

#import "HideButtonTransition.h"
#import "MainViewController.h"

@implementation HideButtonTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    //获取两个VC 和 动画发生的容器
    MainViewController *fromVC = (MainViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIButton *button = fromVC.choosePhotoButton;
    UIView *snapShotView = [button snapshotViewAfterScreenUpdates:NO];
    snapShotView.frame = [containerView convertRect:button.frame fromView:fromVC.view];
    fromVC.choosePhotoButton.hidden = YES;
    
    //设置第二个控制器的位置、透明度
    toVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    toVC.view.alpha = 0;
    
    //把动画前后的两个ViewController加到容器中,顺序很重要,snapShotView在上方
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapShotView];
    containerView.backgroundColor = [UIColor whiteColor];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [containerView layoutIfNeeded];
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.alpha = 1.0;
        fromVC.view.alpha = 0.0;
        CGRect frame = snapShotView.frame;
        frame.origin.y += frame.size.height;
        snapShotView.frame = frame;
        CGRect fromVCFrame = fromVC.view.frame;
        fromVCFrame.origin.x -= fromVCFrame.size.width/3;
        fromVC.view.frame = fromVCFrame;
    } completion:^(BOOL finished) {
        fromVC.choosePhotoButton.hidden = NO;
        fromVC.view.alpha = 1.0;
        [snapShotView removeFromSuperview];
        //告诉系统动画结束
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
