//
//  NavigationDelegate.m
//  WordRecognition
//
//  Created by 李超 on 15/12/6.
//  Copyright © 2015年 李超. All rights reserved.
//

#import "NavigationDelegate.h"
#import "CardListViewController.h"
#import "CardViewController.h"
#import "HideButtonTransition.h"
#import "ShowButtonTransition.h"
#import "MainViewController.h"

@implementation NavigationDelegate

#pragma mark <UINavigationControllerDelegate>
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    
    if ([toVC isKindOfClass:[CardViewController class]] && [fromVC isKindOfClass:[CardListViewController class]]) {
        return nil;
    } else if ([toVC isKindOfClass:[CardListViewController class]] && [fromVC isKindOfClass:[CardViewController class]]) {
        return nil;
    } else if ([fromVC isKindOfClass:[MainViewController class]]) {
        HideButtonTransition *transition = [[HideButtonTransition alloc] init];
        return transition;
    } else if ([toVC isKindOfClass:[MainViewController class]]) {
        ShowButtonTransition *transition = [[ShowButtonTransition alloc] init];
        return transition;
    } else {
        return nil;
    }
}

@end
