//
//  CircleLayoutCell.h
//  CustomCollectionVIewLayout
//
//  Created by 吴磊 on 14/12/25.
//  Copyright (c) 2014年 Renren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ECollectionCellType)
{
    ECollectionCellTypeCircle = 1,
    ECollectionCellTypeLine = 2,
};

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
- (void)configCell:(ECollectionCellType)type;
@end
