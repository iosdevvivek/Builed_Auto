//
//  BuildingListViewController.h
//  BuildAuto
//
//  Created by Panacea on 8/9/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWSlideMenuViewController.h"
#import "MBProgressHUD.h"

@interface BuildingListViewController : JWSlideMenuViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

@property(nonatomic,strong) NSArray *arrayResults;

@property(nonatomic,strong) IBOutlet UITableView *tblView;

@property(nonatomic,strong) IBOutlet UIView *ViewAllocation;

@property(nonatomic,strong) IBOutlet UIScrollView *scrollViewProject;
@end
