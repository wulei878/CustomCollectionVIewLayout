//
//  CollectionViewCircleLayout.m
//  CustomCollectionVIewLayout
//
//  Created by 吴磊 on 14/12/25.
//  Copyright (c) 2014年 Renren. All rights reserved.
//

#import "CollectionViewCircleLayout.h"

static int kDefaultItemSize = 70;

@implementation CollectionViewCircleLayout
//- (id)init
//{
//    self = [super init];
//
//    if (self) {
//        self.itemSize = CGSizeMake(kDefaultItemSize, kDefaultItemSize);
//        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        self.sectionInset = UIEdgeInsetsMake(200, 0.0, 200, 0.0);
//        self.minimumLineSpacing = 50.0;
//    }
//
//    return self;
//}
-(void)prepareLayout
{
    [super prepareLayout];

    CGSize size = self.collectionView.frame.size;
    self.cellCount = [[self collectionView] numberOfItemsInSection:0];
    self.center = CGPointMake(size.width / 2.0, size.height / 2.0);
    self.radius = MIN(size.width, size.height) / 2.5;
}

-(CGSize)collectionViewContentSize
{
    return [self collectionView].frame.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    attributes.size = CGSizeMake(kDefaultItemSize, kDefaultItemSize);
    attributes.center = CGPointMake(self.center.x + self.radius * cosf(2 * path.item * M_PI / self.cellCount),
                                    self.center.y + self.radius * sinf(2 * path.item * M_PI / self.cellCount));
    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < self.cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

@end
