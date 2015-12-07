//
//  CardViewController.h
//  WordRecognition
//
//  Created by 李超 on 15/12/5.
//  Copyright © 2015年 李超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickImageViewController.h"

typedef NS_ENUM(NSInteger, CardViewStatus){
    CardViewStatusCustom = 0,
    CardViewStatusNormal,
    CardViewStatusEdit,
};

@interface CardViewController : PickImageViewController

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (nonatomic, assign) CardViewStatus status;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) NSArray *cardArray;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
