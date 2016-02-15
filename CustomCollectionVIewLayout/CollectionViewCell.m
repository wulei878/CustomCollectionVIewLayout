//
//  CircleLayoutCell.m
//  CustomCollectionVIewLayout
//
//  Created by 吴磊 on 14/12/25.
//  Copyright (c) 2014年 Renren. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)configCell:(ECollectionCellType)type
{
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    self.contentView.layer.borderWidth = 1;
    if (type == ECollectionCellTypeCircle) {
        self.contentView.layer.cornerRadius = self.bounds.size.width / 2;

    } else if (type == ECollectionCellTypeLine) {
    }

}
@end
