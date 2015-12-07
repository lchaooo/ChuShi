//
//  CardListCollectionViewCell.h
//  WordRecognition
//
//  Created by 李超 on 15/12/6.
//  Copyright © 2015年 李超. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardListCollectionViewCell;

@protocol CardListCollectionViewCellDelegate <NSObject>

- (void)didClickDeleteButton:(CardListCollectionViewCell *)cell;

@end

typedef NS_ENUM(NSUInteger, CardListCellStatus) {
    CardListCellStatusNormal = 0,
    CardListCellStatusEdit,
};

@interface CardListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, assign) CardListCellStatus status;
@property (nonatomic, weak) id<CardListCollectionViewCellDelegate> delegate;

@end
