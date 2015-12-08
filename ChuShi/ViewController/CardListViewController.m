//
//  CardListViewController.m
//  WordRecognition
//
//  Created by 李超 on 15/12/6.
//  Copyright © 2015年 李超. All rights reserved.
//

#import "CardListViewController.h"
#import "MainLayout.h"
#import "Card.h"
#import "CardViewController.h"
#import "JSONHelper.h"
#import "CardListCollectionViewCell.h"
#import "CardViewController.h"


@interface CardListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, CardListCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cardListCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) NSMutableArray *cardArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) CardListCellStatus cellStatus;

@end

@implementation CardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.identifier = _identifier;
    [self.cardListCollectionView reloadData];
}

#pragma mark UICollectionView Delegate and Data Source
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return _cardArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CardListCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cardListCell" forIndexPath:indexPath];
    if ([self.identifier isEqualToString:@"mine"]) {
        cell.imageView.image = [UIImage imageNamed:@"mine_background"];
        cell.textLabel.text = [[(Card *)self.cardArray[indexPath.row] chinese] substringToIndex:1];
    } else {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%ld",self.identifier, indexPath.row+1]];
        cell.textLabel.text = nil;
    }
    cell.status = self.cellStatus;
    cell.delegate = self;
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    CardViewController *cardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CardViewController"];
    if ([self.identifier isEqualToString:@"mine"]) {
        cardVC.status = CardViewStatusEdit;
    } else {
        cardVC.status = CardViewStatusNormal;
    }
    [cardVC setCardArray:self.cardArray];
    [cardVC.view layoutIfNeeded];
    [cardVC.cardCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self.navigationController pushViewController:cardVC animated:YES];
}

#pragma mark CardListCellDelegate
- (void)didClickDeleteButton:(CardListCollectionViewCell *)cell {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定要删除吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUInteger index = [self.cardListCollectionView indexPathForCell:cell].row;
        Card *card = [self.cardArray objectAtIndex:index];
        [[DataBase sharedInstance] deleteDataFromTable:@"mine" card:card];
        [self.cardArray removeObjectAtIndex:index];
        [self.cardListCollectionView deleteItemsAtIndexPaths:@[[self.cardListCollectionView indexPathForCell:cell]]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark custom
- (void)setUpSubviews {
    MainLayout *layout = [[MainLayout alloc] init];
    self.cardListCollectionView.collectionViewLayout = layout;
    [self.cardListCollectionView registerNib:[UINib nibWithNibName:@"CardListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cardListCell"];
    
    [self.backButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.status = CardListCollectionViewStatusNormal;
    self.cellStatus = CardListCellStatusNormal;
    if ([self.identifier isEqualToString:@"mine"]) {
        self.deleteButton.hidden = NO;
    } else {
        self.deleteButton.hidden = YES;
    }
    [self.deleteButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        [self changeStatus];
        [self.cardListCollectionView reloadData];
    }];
    
    [self.cardListCollectionView reloadData];
}

- (void)changeStatus {
    if (self.status == 0) {
        self.status = 1;
        [self.deleteButton setImage:[UIImage imageNamed:@"icon_ture"] forState:UIControlStateNormal];
    } else if (self.status == 1) {
        self.status = 0;
        [self.deleteButton setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
    }
}

#pragma mark getters and setters 
- (void)setIdentifier:(NSString *)identifier {
    _identifier = identifier;
    if ([identifier isEqualToString:@"mine"]) {
        _cardArray = [[DataBase sharedInstance] selectAllDataFromTable:identifier];
    } else {
        _cardArray = [[JSONHelper sharedInstance] getCardArrayWithIdentifier:identifier];
    }
}

- (void)setStatus:(CardListCollectionViewStatus)status {
    _status = status;
    if (status == CardListCellStatusNormal) {
        _cellStatus = CardListCellStatusNormal;
        self.cardListCollectionView.allowsSelection = YES;
    } else if (status == CardListCollectionViewStatusEdit) {
        _cellStatus = CardListCellStatusEdit;
        self.cardListCollectionView.allowsSelection = NO;
    }
}

@end
