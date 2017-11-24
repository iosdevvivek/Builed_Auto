//
//  CollectionViewCell.h
//  Meter
//
//  Created by Krishna on 10/10/15.
//  Copyright (c) 2015 Yarrana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCellMeter : UICollectionViewCell

@property(nonatomic,retain) IBOutlet UILabel *TotalAmt;
@property(nonatomic,retain) IBOutlet UILabel *lblText;

@property(nonatomic,retain) UIImageView *imgNeedle;
@property(nonatomic,retain)UIImageView *meterImageViewDot;
@property(nonatomic,retain)UILabel *tempReading;
@end
