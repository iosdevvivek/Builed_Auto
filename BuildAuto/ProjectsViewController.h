//
//  ProjectsViewController.h
//  BuildAuto
//
//  Created by Panacea on 8/2/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ProjectsViewController : UIViewController<MBProgressHUDDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    MBProgressHUD *HUD;
    UIView *actionSheet;
}

@property(nonatomic,strong) IBOutlet UIButton *btnProjectList;
@property(nonatomic,strong) IBOutlet UIButton *btnUnitType;
@property(nonatomic,strong) IBOutlet UIButton *btnBuildingList;
@end
