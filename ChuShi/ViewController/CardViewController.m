//
//  CardViewController.m
//  WordRecognition
//
//  Created by 李超 on 15/12/5.
//  Copyright © 2015年 李超. All rights reserved.
//

#import "CardViewController.h"
#import "DataBase.h"
#import "CardViewBindHelper.h"
#import "Card.h"
#import "CardCollectionViewCell.h"
#import "CardLayout.h"
#import "CardListViewController.h"
#import <iflyMSC/IFlySpeechSynthesizerDelegate.h>
#import "NetworkManager.h"
#import "YTOperations.h"
#import "UIImage+Resize.h"
#import "YTTagModel.h"

#define IS_CH_SYMBOL(chr) ((int)(chr)>127)

@interface CardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CardCollectionViewCellDelegate, IFlySpeechSynthesizerDelegate, UIScrollViewDelegate>


@property (nonatomic, strong) CardViewBindHelper *bindHelper;

@property (nonatomic, strong) UIImageView *playButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSMutableArray *lastArray;
@property (nonatomic, assign) NSUInteger indexToDelete;

@end

@implementation CardViewController

#pragma mark life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
    
    self.indexArray = [NSMutableArray array];
    for (int i = 0; i < self.cardArray.count; i++) {
        [self.indexArray addObject:@0];
    }
    
    if (self.status == CardViewStatusNormal) {
        self.saveButton.hidden = YES;
        self.editButton.hidden = YES;
        self.refreshButton.hidden = YES;
    } else if (self.status == CardViewStatusCustom) {
        self.saveButton.hidden = NO;
        self.editButton.hidden = NO;
        self.refreshButton.hidden = NO;
    }
    [[VoiceHelper sharedInstance] setSpeechSynthesizerDelegate:self];
}


#pragma mark UICollectionView Delegate and Data Source
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return self.cardArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CardCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cardCell" forIndexPath:indexPath];
    [self.bindHelper bindCardCell:cell withCard:self.cardArray[indexPath.row] index:[self.indexArray objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"嘿嘿嘿");
    for (CardCollectionViewCell *cell in self.cardCollectionView.visibleCells) {
        cell.imageScrollView.scrollEnabled = NO;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.1];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    for (CardCollectionViewCell *cell in self.cardCollectionView.visibleCells) {
        cell.imageScrollView.scrollEnabled = YES;
    }
    if (self.status == CardViewStatusEdit) {
        [self.saveButton setImage:[UIImage imageNamed:@"icon_addcard"] forState:UIControlStateNormal];
        self.saveButton.userInteractionEnabled = NO;
        self.cardArray = [[DataBase sharedInstance] selectAllDataFromTable:@"mine"];
        self.lastArray = [self.cardArray copy];
        [self.cardCollectionView reloadData];
    }
}

#pragma mark IFlySpeechSynthesizerDelegate
//结束代理
- (void) onCompleted:(IFlySpeechError *) error {
    [self.playButton stopAnimating];
    self.cardCollectionView.userInteractionEnabled = YES;
}

#pragma mark CardCollectionViewCellDelegate
- (void)chinesePlayButtonClicked:(NSString *)chinese sender:(id)sender {
    [[VoiceHelper sharedInstance] startSpeaking:chinese withParamaters:nil];
    self.playButton = sender;
    [self.playButton startAnimating];
    self.cardCollectionView.userInteractionEnabled = NO;
}

- (void)englishPlayButtonClicked:(NSString *)english sender:(id)sender {
    [[VoiceHelper sharedInstance] startSpeaking:english withParamaters:nil];
    self.playButton = sender;
    [self.playButton startAnimating];
    self.cardCollectionView.userInteractionEnabled = NO;
}

- (void)imageBrowserDidEndScroll:(NSUInteger)index cell:(CardCollectionViewCell *)cell {
    NSUInteger rowNum = [self.cardCollectionView indexPathForCell:cell].row;
    [self.indexArray setObject:@(index) atIndexedSubscript:rowNum];
    self.cardCollectionView.scrollEnabled = YES;
}

- (void)imageBrowserDidScroll:(CardCollectionViewCell *)cell {
    self.cardCollectionView.scrollEnabled = NO;
}

#pragma mark custom method
- (void)setUpSubviews {
    self.navigationController.navigationBar.hidden = YES;
    
    [self.backButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.editButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"卡片有误？编辑您的卡片" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入中文";
            textField.text = [(Card *)[self.cardArray objectAtIndex:0] chinese];
        }];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableArray *textArray = [NSMutableArray array];
            for (UITextField *textField in alertController.textFields) {
                [textArray addObject:textField.text];
            }
            BOOL isNotChinese = NO;
            for (int i = 0; i < [(NSString *)textArray[0] length]; i++) {
                if (!IS_CH_SYMBOL([(NSString *)textArray[0] characterAtIndex:i])) {
                    isNotChinese = YES;
                }
            }
            if (!isNotChinese && [(NSString *)textArray[0] length] != 0) {
                __block Card *card = [[Card alloc] init];
                Card *oldCard = [self.cardArray objectAtIndex:self.indexToDelete];
                card = [oldCard copy];
                card.chinese = textArray[0];
                NSMutableArray *imageArray = [NSMutableArray array];
                for (UIImage *image in oldCard.images) {
                    [imageArray addObject:image];
                }
                card.images = imageArray;
                [SVProgressHUD show];
                [NetworkManager translate2English:textArray[0] ok:^(NSString *english, NSError *error) {
                    card.english = english;
                    card.identifier = [[DataBase sharedInstance] identifier];
                    self.lastArray = [self.cardArray mutableCopy];
                    NSMutableArray *array = [self.cardArray mutableCopy];
                    [array replaceObjectAtIndex:self.indexToDelete withObject:card];
                    self.cardArray = array;
                    [self.cardCollectionView reloadData];
                    [SVProgressHUD dismiss];
                    [self.saveButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
                    self.saveButton.userInteractionEnabled = YES;
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:@"输入有误"];
                [self performSelector:@selector(dismissProcessHud) withObject:nil afterDelay:1.2];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    if (self.status == CardViewStatusCustom) {
        self.saveButton.userInteractionEnabled = YES;
        [self.saveButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    } else if (self.status == CardViewStatusEdit) {
        self.saveButton.userInteractionEnabled = NO;
        [self.saveButton setImage:[UIImage imageNamed:@"icon_addcard"] forState:UIControlStateNormal];
    }
    [self.saveButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        [self refreshWithIndex:self.indexToDelete];
    }];
    
    [self.refreshButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        [self chooseImage];
    }];
    
    [self.cardCollectionView registerNib:[UINib nibWithNibName:@"CardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cardCell"];
    CardLayout *layout = [[CardLayout alloc] init];
    self.cardCollectionView.collectionViewLayout = layout;
}

- (void)dismissProcessHud {
    [SVProgressHUD dismiss];
}

#pragma override
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [super imagePickerController:picker didFinishPickingMediaWithInfo:info];
    if (self.originalImage) {
        [SVProgressHUD show];
        self.view.userInteractionEnabled = NO;
        __block Card *card = [[Card alloc] init];
        card.images = [NSArray arrayWithObjects:self.originalImage, nil];
        card.imageCounts = 1;
        [YTOperations identifyImage:[UIImage cutImage:self.originalImage size:CGSizeMake(200, 200)] ok:^(NSArray *array, NSError *error) {
            if (array.count > 0) {
                card.chinese = [(YTTagModel *)[array firstObject] tag_name];
                [NetworkManager translate2English:card.chinese ok:^(NSString *english, NSError *error) {
                    card.english = english;
                    self.lastArray = [self.cardArray mutableCopy];
                    NSMutableArray *array = [self.cardArray mutableCopy];
                    [array replaceObjectAtIndex:self.indexToDelete withObject:card];
                    self.cardArray = array;
                    [self.cardCollectionView reloadData];
                    [SVProgressHUD dismiss];
                    self.view.userInteractionEnabled = YES;
                    self.saveButton.userInteractionEnabled = YES;
                    [self.saveButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
                }];
            }
        }];
    }
}

- (void)refreshWithIndex:(NSUInteger)index {
    Card *cardToDelete = [self.lastArray objectAtIndex:index];
    [[DataBase sharedInstance] deleteDataFromTable:@"mine" card:cardToDelete];
    Card *cardToInsert = [self.cardArray objectAtIndex:index];
    [[DataBase sharedInstance] insertDataIntoTable:@"mine" card:cardToInsert];
    [self.saveButton setImage:[UIImage imageNamed:@"icon_addcard"] forState:UIControlStateNormal];
    self.saveButton.userInteractionEnabled = NO;
}

#pragma mark getters and setters
- (CardViewBindHelper *)bindHelper {
    if (_bindHelper == nil) {
        _bindHelper = [[CardViewBindHelper alloc] init];
    }
    return _bindHelper;
}

- (NSUInteger)indexToDelete {
    CardCollectionViewCell *cell = [[self.cardCollectionView visibleCells] objectAtIndex:0];
    _indexToDelete = [self.cardCollectionView indexPathForCell:cell].row;
    return _indexToDelete;
}

@end
