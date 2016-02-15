//
//  CollectionViewCircleLayout.h
//  CustomCollectionVIewLayout
//
//  Created by 吴磊 on 14/12/25.
//  Copyright (c) 2014年 Renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCircleLayout : UICollectionViewLayout

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;

@end
