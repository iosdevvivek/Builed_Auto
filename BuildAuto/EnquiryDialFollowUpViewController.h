//
//  EnquiryDialFollowUpViewController.h
//  BuildAuto
//
//  Created by Chetan Anarthe on 21/05/17.
//  Copyright © 2017 BuildAuto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface EnquiryDialFollowUpViewController : UIViewController<MBProgressHUDDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{

    MBProgressHUD *HUD;

    BOOL isSearching;
}

@property(nonatomic,strong) IBOutlet UIButton *btnPending;
@property(nonatomic,strong) IBOutlet UIButton *btnOnlyToday;
@property(nonatomic,strong) IBOutlet UIButton *btnOfficeVisit;
@property(nonatomic,strong) IBOutlet UIButton *btnSiteVisit;

@property (strong, nonatomic) NSArray *dialFollowUpList;
@property (strong, nonatomic) NSMutableArray *filteredDialFollowUpList;

@property (strong, nonatomic) IBOutlet UITableView *tblDialFollowUp;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@end
