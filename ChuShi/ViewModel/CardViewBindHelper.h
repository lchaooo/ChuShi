//
//  CardViewModel.h
//  WordRecognition
//
//  Created by 李超 on 15/12/5.
//  Copyright © 2015年 李超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "CardCollectionViewCell.h"

@interface CardViewBindHelper : NSObject

- (void)bindCardCell:(CardCollectionViewCell *)view withCard:(Card *)card index:(NSNumber *)index;

@end
