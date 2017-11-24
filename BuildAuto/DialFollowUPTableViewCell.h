//
//  DialFollowUPTableViewCell.h
//  BuildAuto
//
//  Created by Chetan Anarthe on 21/05/17.
//  Copyright © 2017 BuildAuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialFollowUPTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblCustNameWithFlatNo;

@property (nonatomic, weak) IBOutlet UILabel *lblMobileNo;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet UIButton *btnCall;

@end
