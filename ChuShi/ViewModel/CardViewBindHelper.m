//
//  CardViewModel.m
//  WordRecognition
//
//  Created by 李超 on 15/12/5.
//  Copyright © 2015年 李超. All rights reserved.
//

#import "CardViewBindHelper.h"

@implementation CardViewBindHelper

- (void)bindCardCell:(CardCollectionViewCell *)view withCard:(Card *)card index:(NSNumber *)index num:(NSNumber *)num{
    view.chineseLabel.text = card.chinese;
    view.englishLabel.text = card.english;
    view.pinyinLabel.text = card.pinyin;
    NSArray *subviews = view.imageScrollView.subviews;
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    view.count = card.imageCounts;
    view.imageArray = card.images;
    view.indexPath = [num integerValue];
    [view layoutIfNeeded];
    [view.imageScrollView scrollRectToVisible:CGRectMake(0, [index intValue] * SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT) animated:NO];
}

@end
