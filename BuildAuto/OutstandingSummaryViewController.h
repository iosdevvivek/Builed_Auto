//
//  OutstandingSummaryViewController.h
//  BuildAuto
//
//  Created by Chetan Anarthe on 13/03/17.
//  Copyright © 2017 BuildAuto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface OutstandingSummaryViewController : UIViewController<MBProgressHUDDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
 {
    MBProgressHUD *HUD;
    UIView *actionSheet;
    
    
    BOOL isSearching;
}

@property(nonatomic,strong) IBOutlet UIButton *btnProjectList;
@property(nonatomic,strong) IBOutlet UIButton *btnBuildingList;

@property (strong, nonatomic) NSArray *SummaryList;
@property (strong, nonatomic) NSMutableArray *filteredSummaryList;

@property (strong, nonatomic) IBOutlet UITableView *tblSummaryList;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
