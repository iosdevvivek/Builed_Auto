//
//  EnquiryDialFollowUpViewController.m
//  BuildAuto
//
//  Created by Chetan Anarthe on 21/05/17.
//  Copyright © 2017 BuildAuto. All rights reserved.
//

#import "EnquiryDialFollowUpViewController.h"
#import "Reachability.h"
#import "DialFollowUPTableViewCell.h"
#import "UIImageView+Letters.h"
#import "BaseViewController.h"


@interface EnquiryDialFollowUpViewController ()

@property(nonatomic, assign) BOOL isPending;
@property(nonatomic, assign) BOOL isOnlyToday;
@property(nonatomic, assign) BOOL isOfficeVisit;
@property(nonatomic, assign) BOOL isSiteVisit;
@property(nonatomic, strong) UIButton *lastBtnSelected;
@end

@implementation EnquiryDialFollowUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isPending = true;
    self.isOnlyToday = false;
    self.isOfficeVisit = false;
    self.isSiteVisit = false;
    

    if (self.isPending) {
        [self.btnPending setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
    }else {
        [self.btnPending setImage:[UIImage imageNamed:@"Uncheck"] forState:UIControlStateNormal];
    }
    
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"Enquiry Follow Up";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UINib *nib = [UINib nibWithNibName:@"DialFollowUPTableViewCell" bundle:nil];
    [self.tblDialFollowUp registerNib:nib forCellReuseIdentifier:@"DialFollowUPTableViewCell"];
    
    [self.searchBar setHidden:YES];
    self.searchBar.delegate = self;
    [self.tblDialFollowUp setHidden:YES];
    
    self.filteredDialFollowUpList = [[NSMutableArray alloc] init];
    
    
    // HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    HUD.delegate = self;
    HUD.labelText = NSLocalizedString(@"Loading..",nil);
    HUD.dimBackground = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please turn on internet connection or use Wi-Fi to access data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        [HUD showWhileExecuting:@selector(webServiceForFetchDialFollowUpList) onTarget:self withObject:nil animated:YES];
    }

}

-(IBAction)toggleButtonEvent:(id)sender {

    UIButton *btn = (UIButton*)sender;

    switch (btn.tag) {
        case 11:
            
        case 12:
            
            if (self.lastBtnSelected != btn) {
                self.isPending = !self.isPending;
                self.isOnlyToday = !self.isOnlyToday;
                
                if (self.isPending) {
                    [self.btnPending setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
                }else {
                    [self.btnPending setImage:[UIImage imageNamed:@"Uncheck"] forState:UIControlStateNormal];
                }
                
                if (self.isOnlyToday) {
                    [self.btnOnlyToday setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
                }else {
                    [self.btnOnlyToday setImage:[UIImage imageNamed:@"Uncheck"] forState:UIControlStateNormal];
                }

                 self.lastBtnSelected = btn;
            }
            
                break;
            
        case 13:
            self.isOfficeVisit = !self.isOfficeVisit;
            if (self.isOfficeVisit) {
                [self.btnOfficeVisit setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
            }else {
                [self.btnOfficeVisit setImage:[UIImage imageNamed:@"Uncheck"] forState:UIControlStateNormal];
            }
            break;
            
        case 14:
            self.isSiteVisit = !self.isSiteVisit;
            if (self.isSiteVisit) {
                [self.btnSiteVisit setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
            }else {
                [self.btnSiteVisit setImage:[UIImage imageNamed:@"Uncheck"] forState:UIControlStateNormal];
            }
            break;
            
        default:
            break;
    }
    
   
}


- (IBAction)btnSubmitTapped:(id)sender {

    [self webServiceForFetchDialFollowUpList];
}


/*
 
 http://localhost:1837/EnquiryManagementService/EnquiryManagement.svc/Web/EnquiryFollowUpListingForMobileApp  HTTP/1.1
 User-Agent: Fiddler
 Content-Type: application/json
 Host: localhost:1837
 Content-Length: 248
 
 {"strDB" :"BuildAuto_New","obj":{"Active":"A","AsOnDate":"\/Date(1446035448500)\/","PendingFollowUp":"true","OnlyTodays":"false","SiteVisit":"false","OfficeVisit":"false"},"blnIs4Search":"false","strSearch":"","intStartFrm":"0", "intNoofRec":"10" }
 */

-(void) webServiceForFetchDialFollowUpList {
    
    NSString *str_ComplrteUrl = [NSString stringWithFormat:@"http://166.62.81.20:8091/EnquiryManagement.svc/Web/EnquiryFollowUpListingForMobileApp"] ;
    
    NSMutableArray *globalArrayOrderDetails = [[NSMutableArray alloc]init];

    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *dateStarted = [NSString stringWithFormat:@"/Date(%.0f)/", interval * 1000];

    NSDictionary *dictFollowUpDetails = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"A", @"Active",
                                         dateStarted, @"AsOnDate",
                                         self.isPending ? @"true":@"false", @"PendingFollowUp",
                                         self.isOnlyToday ? @"true":@"false", @"OnlyTodays",
                                         self.isOfficeVisit ? @"true":@"false", @"OfficeVisit",
                                         self.isSiteVisit ? @"true":@"false", @"SiteVisit",
                                         nil];
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"DE0031516", @"strDB",
                          dictFollowUpDetails, @"obj",
                          @"false", @"blnIs4Search",
                          @"", @"strSearch",
                          nil];

    
    
    [globalArrayOrderDetails addObject:dict];
    
    
    NSData *jsonData4 = [NSJSONSerialization dataWithJSONObject:globalArrayOrderDetails options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strOrderDetails = [[NSString alloc] initWithData:jsonData4 encoding:NSUTF8StringEncoding];
    
    
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"[" withString:@""];
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    BaseViewController *baseviewcontroller = [[BaseViewController alloc]init];
    NSDictionary *dictionary =  [baseviewcontroller WebParsingMethod:str_ComplrteUrl:strOrderDetails];
    
    [HUD hide:YES];
    
    if (dictionary != nil && [[dictionary allKeys] count] >0 && [[dictionary valueForKey:@"EnquiryFollowUpListingForMobileAppResult"] count] > 0) {
        
        NSArray *arrFollowUpList = [[dictionary valueForKey:@"EnquiryFollowUpListingForMobileAppResult"] valueForKey:@"FollowUpList"];
        if (arrFollowUpList != nil && [arrFollowUpList count] > 0) {
            self.dialFollowUpList = arrFollowUpList;
             dispatch_async(dispatch_get_main_queue(), ^{
                [self.tblDialFollowUp setHidden:NO];
                 [self.searchBar setHidden:NO];
                [self.tblDialFollowUp reloadData];
            });
        }else {
            [self.searchBar setHidden:YES];
            [self.tblDialFollowUp setHidden:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Data not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }


    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (isSearching) {
        return [self.filteredDialFollowUpList count];
    }
    else {
        return [self.dialFollowUpList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"DialFollowUPTableViewCell";
    
    DialFollowUPTableViewCell *dialFollowUPCell = (DialFollowUPTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (dialFollowUPCell == nil) {
        dialFollowUPCell = [[DialFollowUPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    NSDictionary *dict = nil;
    
    if (isSearching && [self.filteredDialFollowUpList count]>0) {
        dict = [self.filteredDialFollowUpList objectAtIndex:indexPath.row];
    }else {
        dict = [self.dialFollowUpList objectAtIndex:indexPath.row];
    }
    
    dialFollowUPCell.thumbnailImageView.layer.cornerRadius = 20.0f;
    dialFollowUPCell.thumbnailImageView.layer.borderWidth = 0.2f;
    dialFollowUPCell.thumbnailImageView.layer.borderColor = [UIColor blackColor].CGColor;
    dialFollowUPCell.thumbnailImageView.clipsToBounds = YES;
    [dialFollowUPCell.thumbnailImageView setImageWithString:[dict objectForKey:@"CustomerName"]];
    
    dialFollowUPCell.lblCustNameWithFlatNo.text = [NSString stringWithFormat:@"%@ (%@)" , [dict objectForKey:@"CustomerName"],[dict objectForKey:@"EnqCount"]];
    dialFollowUPCell.lblMobileNo.text = [dict objectForKey:@"MobileNo1"];
    [dialFollowUPCell.btnCall addTarget:self action:@selector(callPhoneNumber:) forControlEvents:UIControlEventTouchDown];
    
    
    
    return dialFollowUPCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    SummaryDetailsViewController *vc = [[SummaryDetailsViewController alloc]initWithNibName:@"SummaryDetailsViewController" bundle:nil];
//    
//    if (isSearching && [self.filteredDialFollowUpList count]>0) {
//        vc.dictDetails = [self.filteredDialFollowUpList objectAtIndex:indexPath.row];
//    }else {
//        vc.dictDetails = [self.dialFollowUpList objectAtIndex:indexPath.row];
//    }
//    
//    
//    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationController pushViewController:vc animated:YES];
//    
    
    
}

-(void) callPhoneNumber:(id)sender {
    
    DialFollowUPTableViewCell* cell = (DialFollowUPTableViewCell*)[[sender superview] superview];
    NSIndexPath* indexPath = [self.tblDialFollowUp indexPathForCell:cell];
    
    NSDictionary *dict;
    
    if (isSearching && [self.filteredDialFollowUpList count] >0) {
        dict = [self.filteredDialFollowUpList objectAtIndex:indexPath.row];
    }else {
        dict = [self.dialFollowUpList objectAtIndex:indexPath.row];
    }
    
    NSString *phNo = [[dict objectForKey:@"MobileNo1"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *Aalert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Call facility is not available to %@ on Simulator!!!", phNo] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [Aalert show];
    }
}

- (void)searchTableList {
    NSString *searchString = _searchBar.text;
    
    for (NSDictionary *dict in self.dialFollowUpList) {
        NSString *tempStr = [dict objectForKey:@"CustomerName"];
        
        NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            [self.filteredDialFollowUpList addObject:dict];
        }
        
    }
    
}

#pragma mark - Search Implementation

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %d",isSearching);
    
    //Remove all objects first.
    [self.filteredDialFollowUpList removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching = YES;
        NSString *searchString = _searchBar.text;
        
        for (NSDictionary *dict in self.dialFollowUpList) {
            NSString *tempStr = [dict objectForKey:@"CustomerName"];
            
            //            NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
            //            if (result == NSOrderedSame) {
            //                [self.filteredDialFollowUpList addObject:dict];
            //            }
            
            if (tempStr.length >= searchText.length)
            {
                NSRange titleResultsRange = [tempStr rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
                if (titleResultsRange.length > 0)
                {
                    [self.filteredDialFollowUpList addObject:dict];
                }
            }
            
        }
    }
    else {
        isSearching = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblDialFollowUp reloadData];
    });
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
    isSearching = NO;
    _searchBar.showsCancelButton=NO;
    [_searchBar resignFirstResponder];
    [self.tblDialFollowUp reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    //[self searchTableList];
    [searchBar resignFirstResponder];
    
}


@end
