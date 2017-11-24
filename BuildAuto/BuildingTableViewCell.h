//
//  BuildingTableViewCell.h
//  BuildAuto
//
//  Created by Panacea on 8/9/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuildingTableViewCell : UITableViewCell
@property(nonatomic,strong) IBOutlet UILabel *lblFloor;
@property(nonatomic,strong) IBOutlet UIView *viewFloor;

@property(nonatomic,strong) IBOutlet UIButton *btnVideo;
@property(nonatomic,strong) IBOutlet UIButton *btnGallery;
@property(nonatomic,strong) IBOutlet UIButton *btnPlayarrow;

@property(nonatomic,strong) IBOutlet UILabel *lblFloorValue;

@property(nonatomic,weak) IBOutlet UILabel *lblUnitNo;
@property(nonatomic,weak) IBOutlet UILabel *lblArea;
@property(nonatomic,weak) IBOutlet UILabel *lblBHK;

@end
