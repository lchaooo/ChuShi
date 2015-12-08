//
//  MainViewController.m
//  WordRecognition
//
//  Created by 李超 on 15/12/6.
//  Copyright © 2015年 李超. All rights reserved.
//

#import "MainViewController.h"
#import "MainLayout.h"
#import "CardListViewController.h"
#import "YTOperations.h"
#import "UIImage+Resize.h"
#import "CardViewController.h"
#import "Card.h"
#import "NetworkManager.h"
#import "MainCollectionViewCell.h"

@interface MainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSArray *identifierArray;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    [self.choosePhotoButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        [self chooseImage];
    }];
    MainLayout *layout = [[MainLayout alloc] init];
    self.mainCollectionView.collectionViewLayout = layout;
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"MainCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"mainCell"];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"main2list"]) {
        CardListViewController *cv = [segue destinationViewController];
        NSString *id = self.identifierArray[self.indexPath.row];
        cv.identifier = id;
    }
}

#pragma mark override
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [super imagePickerController:picker didFinishPickingMediaWithInfo:info];
    if (self.originalImage) {
        [SVProgressHUD show];
        CardViewController *cv = [self.storyboard instantiateViewControllerWithIdentifier:@"CardViewController"];
        self.view.userInteractionEnabled = NO;
        __block Card *card = [[Card alloc] init];
        card.images = [NSArray arrayWithObjects:self.originalImage, nil];
        card.imageCounts = 1;
        [YTOperations identifyImage:[UIImage cutImage:self.originalImage size:CGSizeMake(200, 200)] ok:^(NSArray *array, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"网络连接有问题"];
                [self performSelector:@selector(dismissProcessHud) withObject:nil afterDelay:1.5];
            } else {
                if (array.count > 0) {
                    card.chinese = [(YTTagModel *)[array firstObject] tag_name];
                    [NetworkManager translate2English:card.chinese ok:^(NSString *english, NSError *error) {
                        if (error) {
                            [SVProgressHUD showErrorWithStatus:@"网络连接有问题"];
                            [self performSelector:@selector(dismissProcessHud) withObject:nil afterDelay:1.5];
                        } else {
                            card.english = english;
                            self.view.userInteractionEnabled = YES;
                            [self dismissProcessHud];
                            [self.navigationController pushViewController:cv animated:YES];
                            [cv setCardArray:[NSArray arrayWithObjects:card, nil]];
                            cv.status = CardViewStatusCustom;
                        }
                    }];
                }
            }
        }];
    }
}

#pragma mark UICollectionView Delegate and Data Source
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.identifierArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"mainCell" forIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"first_%@",self.identifierArray[indexPath.row]]]];
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![[self.identifierArray objectAtIndex:indexPath.row] isEqualToString:@""]) {
        self.indexPath = indexPath;
        [self.mainCollectionView deselectItemAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"main2list" sender:nil];
    }
}

#pragma mark custom method 
- (void)dismissProcessHud {
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
}

#pragma mark getters and setters 
- (NSArray *)identifierArray {
    return @[@"mine", @"", @"", @"animal", @"traffic", @"music", @"jiaju", @"vegetable", @"fruit"];
    
}

@end
