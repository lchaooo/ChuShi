//
//  CardCollectionViewCell.m
//  WordRecognition
//
//  Created by 李超 on 15/12/6.
//  Copyright © 2015年 李超. All rights reserved.
//

#import "CardCollectionViewCell.h"

#define SCROLLVIEW_WIDTH self.imageScrollView.frame.size.width
#define SCROLLVIEW_HEIGHT self.imageScrollView.frame.size.height

@interface CardCollectionViewCell() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *chinesePlay;
@property (weak, nonatomic) IBOutlet UIImageView *englishPlay;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;
@property (nonatomic, assign) NSUInteger contentOffSetY;
@property (nonatomic, assign) CGPoint lastContentOffset;

//@property (nonatomic, assign) NSUInteger currentNum;

@end

@implementation CardCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpSubviews];
    self.lastContentOffset = CGPointMake(0, 0);
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (fabs(scrollView.contentOffset.y - self.lastContentOffset.y) / fabs(scrollView.contentOffset.x - self.lastContentOffset.x) > 1) {
        [self.delegate imageBrowserDidScroll:self];
    }
    self.lastContentOffset = scrollView.contentOffset;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.contentOffSetY = scrollView.contentOffset.y;
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.1];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.delegate imageBrowserDidEndScroll:self.contentOffSetY/SCROLLVIEW_HEIGHT cell:self];
}

#pragma mark custom
- (void)setUpSubviews {
    self.contentOffSetY = 0;
    
    self.imageScrollView.delegate = self;
    
    UIVisualEffect *effect = [[UIBlurEffect alloc] init];
    self.visualEffectView.effect = effect;
    self.visualEffectView.layer.masksToBounds = YES;
    self.visualEffectView.layer.cornerRadius = 5.0;
    
    self.imageScrollView.backgroundColor = [UIColor clearColor];
    self.imageScrollView.scrollEnabled = YES;
    
    UITapGestureRecognizer *chineseRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chinesePlayDidSelected)];
    [self.chinesePlay setUserInteractionEnabled:YES];
    [self.chinesePlay addGestureRecognizer:chineseRecognizer];
    //  [self.chinesePlay setAnimationImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"icon-youshenglaba"],[UIImage imageNamed:@"icon-wushenglaba"], nil]];
    [self.chinesePlay setAnimationDuration:0.4f];
    
    UITapGestureRecognizer *englishRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(englishPlayDidSelected)];
    [self.englishPlay setUserInteractionEnabled:YES];
    [self.englishPlay addGestureRecognizer:englishRecognizer];
    //  [self.englishPlay setAnimationImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"icon-youshenglaba"],[UIImage imageNamed:@"icon-wushenglaba"], nil]];
    [self.englishPlay setAnimationDuration:0.4f];
}

#pragma mark touch event
- (void)chinesePlayDidSelected {
    [self.delegate chinesePlayButtonClicked:self.chineseLabel.text sender:self.chinesePlay];
}

- (void)englishPlayDidSelected {
    [self.delegate englishPlayButtonClicked:self.englishLabel.text  sender:self.englishPlay];
}

#pragma mark getters and setters
- (void)setCount:(NSUInteger)count {
    _count = count;
    self.imageScrollView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT * count);
   // self.currentNum = 1;
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    for (int i = 0; i < _count; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * i, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        [image setImage:imageArray[i]];
        [self.imageScrollView addSubview:image];
    }
}

@end
