//
//  ViewController.m
//  CustomCollectionVIewLayout
//
//  Created by 吴磊 on 14/12/25.
//  Copyright (c) 2014年 Renren. All rights reserved.
//

#import "ViewController.h"

#import "CollectionViewCell.h"
#import "CollectionViewLineLayout.h"
#import "CollectionViewCircleLayout.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) ECollectionCellType     cellType;
@property (nonatomic, assign) BOOL                    canMove;
@property (nonatomic, strong) UIView                  *fakeView;
@property (nonatomic, assign) NSIndexPath             *selectedIndexPath;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cellCount = 20;
    self.cellType = ECollectionCellTypeLine;
    [self.collectionView setCollectionViewLayout:[[CollectionViewLineLayout alloc] init]];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return self.cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class]) forIndexPath:indexPath];
    [cell configCell:self.cellType];
    cell.label.text = @(indexPath.row + 1).stringValue;

//    if (self.canMove) {
//        CATransform3D transform;
//
//        if (arc4random() % 2 == 1) {
//            transform = CATransform3DMakeRotation(-0.2, 0, 0, 1.0);
//        } else {
//            transform = CATransform3DMakeRotation(0.2, 0, 0, 1.0);
//        }
//
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//        animation.toValue = [NSValue valueWithCATransform3D:transform];
//        animation.autoreverses = YES;
//        animation.duration = 0.1;
//        animation.repeatCount = 10000;
//        animation.delegate = self;
//        [[cell layer] addAnimation:animation forKey:@"wiggleAnimation"];
//    }

    return cell;
}

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)sender
{
//        if (sender.state == UIGestureRecognizerStateEnded)
//        {
//            CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
//            NSIndexPath* tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
//            if (tappedCellPath)
//            {
//                self.cellCount--;
//                [self.collectionView performBatchUpdates:^{
//                    [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:tappedCellPath]];
//    
//                } completion:nil];
//            }
//            else
//            {
//                self.cellCount++;
//                [self.collectionView performBatchUpdates:^{
//                    [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:(self.cellCount-1) inSection:0]]];
//                } completion:nil];
//            }
//        }
}

- (IBAction)didLongPressCollectionView:(UILongPressGestureRecognizer *)sender
{
        if (sender.state == UIGestureRecognizerStateEnded)
        {
            CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
            NSIndexPath* tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
            if (tappedCellPath) {
                self.canMove = YES;
                [self.collectionView reloadData];
            }
        }
}

- (IBAction)didPanOnCollectionView:(UIPanGestureRecognizer *)sender
{
    __block CollectionViewCell *cell;
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint     initialPinchPoint = [sender locationInView:self.collectionView];
        NSIndexPath *tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
        if (tappedCellPath) {
            CollectionViewCell *cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:tappedCellPath];
            self.selectedIndexPath = tappedCellPath;
            self.fakeView = [[UIView alloc] initWithFrame:cell.frame];
            self.fakeView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            self.fakeView.layer.borderColor = [UIColor grayColor].CGColor;
            self.fakeView.layer.borderWidth = 1;
            self.fakeView.layer.cornerRadius = self.fakeView.bounds.size.width / 2;
            UILabel *label = [[UILabel alloc]initWithFrame:self.fakeView.bounds];
            label.text = cell.label.text;
            label.textColor = cell.label.textColor;
            label.font = cell.label.font;
            label.textAlignment = cell.label.textAlignment;
            [self.fakeView addSubview:label];
            cell.contentView.alpha = 0.3f;
            [self.collectionView addSubview:self.fakeView];
        }
//        return;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.collectionView];
        CGPoint tagViewPosition = CGPointMake([self.fakeView center].x + translation.x, [self.fakeView center].y + translation.y);
        self.fakeView.center = tagViewPosition;
        [sender setTranslation:CGPointZero inView:self.collectionView];

            NSIndexPath                *atIndexPath = self.selectedIndexPath;
            NSIndexPath                *toIndexPath = [self.collectionView indexPathForItemAtPoint:self.fakeView.center];

            if ((toIndexPath == nil) || [atIndexPath isEqual:toIndexPath]) {
                return;
            }

            [self.collectionView performBatchUpdates:^{
                self.selectedIndexPath = toIndexPath;
                [self.collectionView moveItemAtIndexPath:atIndexPath toIndexPath:toIndexPath];
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.5 animations:^{
                        CollectionViewCell *cell;
                        cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:toIndexPath];
                        self.fakeView.center = cell.center;
                        cell.contentView.alpha = 1;
                        cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:atIndexPath];
                        cell.contentView.alpha = 1;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            self.selectedIndexPath = nil;
                            [self.fakeView removeFromSuperview];
                        }
                    }];
                }
            }];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5 animations:^{
            cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
            self.fakeView.center = cell.center;
        } completion:^(BOOL finished) {
            if (finished) {
                cell.contentView.alpha = 1;
                [self.fakeView removeFromSuperview];
                self.selectedIndexPath = nil;
                return;
            }
        }];
    }
}

- (IBAction)didTapSwitchButton:(id)sender
{
    if (self.cellType == ECollectionCellTypeCircle) {
        self.cellType = ECollectionCellTypeLine;
        [self.collectionView setCollectionViewLayout:[[CollectionViewLineLayout alloc] init]];
        [self.collectionView reloadData];
    } else if (self.cellType == ECollectionCellTypeLine) {
        self.cellType = ECollectionCellTypeCircle;
        [self.collectionView setCollectionViewLayout:[[CollectionViewCircleLayout alloc] init]];
        [self.collectionView reloadData];
    }
}

@end