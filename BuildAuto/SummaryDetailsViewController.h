//
//  SummaryDetailsViewController.h
//  BuildAuto
//
//  Created by Chetan Anarthe on 26/03/17.
//  Copyright © 2017 BuildAuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryDetailsViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *summaryView;


@property(nonatomic,weak) IBOutlet UILabel *lblCustName;
@property(nonatomic,weak) IBOutlet UILabel *lblAgrmtCost;
@property(nonatomic,weak) IBOutlet UILabel *lblDueAgrmtCost;
@property(nonatomic,weak) IBOutlet UILabel *lblDuePerAgrmtCost;
@property(nonatomic,weak) IBOutlet UILabel *lblRecAgaistDue;
@property(nonatomic,weak) IBOutlet UILabel *lblBalAgaistDue;
@property(nonatomic,weak) IBOutlet UILabel *lblTotalOtherCharges;
@property(nonatomic,weak) IBOutlet UILabel *lblDueOtherCharges;
@property(nonatomic,weak) IBOutlet UILabel *lblRecOtherCharges;

@property(nonatomic,weak) IBOutlet UILabel *lblBuildingProjectName;
@property(nonatomic,weak) IBOutlet UILabel *lblTotalBalance;
@property(nonatomic,weak) IBOutlet UILabel *lblMobile;

@property(nonatomic,weak) IBOutlet UILabel *lblBalOtherCharges;

@property(nonatomic ,strong) NSString *strBuildingProjectName;

@property(nonatomic, strong) NSDictionary *dictDetails;

@end
