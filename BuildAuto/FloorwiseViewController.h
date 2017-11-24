//
//  FloorwiseViewController.h
//  BuildAuto
//
//  Created by Panacea on 8/10/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloorwiseViewController : UIViewController{
    NSMutableArray *arrFloorID;
     NSMutableArray *arrMutFloorwiseResults;
    //UILabel *lblFloorNo;
}

@property(nonatomic,strong) NSArray *arrayResults;

@property(nonatomic,strong) IBOutlet UIView *viewDetails;
@property(nonatomic,strong) IBOutlet UIView *viewBackground;

@property(nonatomic,strong) IBOutlet UILabel *lblUnitNo;
@property(nonatomic,strong) IBOutlet UILabel *lblArea;
@property(nonatomic,strong) IBOutlet UILabel *lblBhk;

@property(nonatomic,strong) IBOutlet UILabel *lblBuilding;
@property(nonatomic,strong) IBOutlet UILabel *lblProjectName;


@property(nonatomic,strong) IBOutlet UILabel *lblBuildingTotalUnit;
@property(nonatomic,strong) IBOutlet UILabel *lblBuildingName;
@property(nonatomic,strong) IBOutlet UILabel *lblBuildingVacant;
@property(nonatomic,strong) IBOutlet UILabel *lblBuildingHeld;
@property(nonatomic,strong) IBOutlet UILabel *lblBuildingBooked;
@property(nonatomic,strong) IBOutlet UILabel *lblBuildingRefuge;
@property(nonatomic,strong) IBOutlet UILabel *lblBuildingNotforsale;



@property(nonatomic,strong) IBOutlet UIButton *btnBooked;
@property(nonatomic,strong) IBOutlet UIButton *btnHeld;
@property(nonatomic,strong) IBOutlet UIButton *btnNotForSale;
@property(nonatomic,strong) IBOutlet UIButton *btnRefuge;
@property(nonatomic,strong) IBOutlet UIButton *btnVacant;

@property(nonatomic,strong) IBOutlet UIView *viewFilters;

@property(nonatomic,strong) IBOutlet UIButton *btnFilterClose;
@property(nonatomic,strong) IBOutlet UIButton *btnFilterSearch;

@end
