//
//  CardListViewController.h
//  WordRecognition
//
//  Created by 李超 on 15/12/6.
//  Copyright © 2015年 李超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CardListCollectionViewStatus) {
    CardListCollectionViewStatusNormal = 0,
    CardListCollectionViewStatusEdit,
};

@interface CardListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) CardListCollectionViewStatus status;

@end
