//
//  CardListCollectionViewCell.m
//  WordRecognition
//
//  Created by 李超 on 15/12/6.
//  Copyright © 2015年 李超. All rights reserved.
//

#import "CardListCollectionViewCell.h"

@implementation CardListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.status = CardListCellStatusNormal;
    [self.deleteButton removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        [self.delegate didClickDeleteButton:self];
    }];
}

- (void)setStatus:(CardListCellStatus)status {
    _status = status;
    if (status == CardListCellStatusNormal) {
        self.deleteButton.hidden = YES;
    } else if (status == CardListCellStatusEdit) {
        self.deleteButton.hidden = NO;
    }
}

@end
