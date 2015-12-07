//
//  PickImageViewController.h
//  Youtu
//
//  Created by 陈颖鹏 on 15/11/7.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "BaseViewController.h"

@interface PickImageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIImage *originalImage;

- (void)chooseImage;

- (void)photoLib;
- (void)takePhoto;

@end
