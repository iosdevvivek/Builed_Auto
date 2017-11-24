//
//  OutstandingSummaryViewController.m
//  BuildAuto
//
//  Created by Chetan Anarthe on 13/03/17.
//  Copyright © 2017 BuildAuto. All rights reserved.
//

#import "OutstandingSummaryViewController.h"
#import "BaseViewController.h"
#import "AppDelegate.h"
#import "FloorwiseViewController.h"
#import "Reachability.h"
#import "MHMainTabBarController.h"
#import "AvailabilityChartViewController.h"
#import "SummaryTableCellTableViewCell.h"
#import "UIImageView+Letters.h"
#import "SummaryDetailsViewController.h"

@interface OutstandingSummaryViewController () {

}

@property(nonatomic, strong) NSMutableArray *globalArrayOrderDetails;

@property(nonatomic, strong) NSArray *arrayProjectList;
@property(nonatomic, strong) NSArray *arrayUnitTpeList;
@property(nonatomic, strong) NSMutableArray *arrayBuildingList;

@property(nonatomic, strong) NSString *strPickerViewSelected;

@property(nonatomic, strong) NSString *selectedProjectName,*selectedProjectID;
@property(nonatomic, strong) NSString *selectedBuildingName,*selectedBuildingID;
@property(nonatomic, strong) NSString *selectedUnitTypeName;


@end

@implementation OutstandingSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"Outstanding Summary";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    UINib *nib = [UINib nibWithNibName:@"SummaryTableCell" bundle:nil];
    [self.tblSummaryList registerNib:nib forCellReuseIdentifier:@"SummaryTableCell"];

    [self.searchBar setHidden:YES];
    self.searchBar.delegate = self;
    [self.tblSummaryList setHidden:YES];
    
    self.filteredSummaryList = [[NSMutableArray alloc] init];
    
    
   // HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    HUD.delegate = self;
    HUD.labelText = NSLocalizedString(@"Loading..",nil);
    HUD.dimBackground = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    self.arrayUnitTpeList = @[@"All",@"Flat",@"Shop",@"Office",@"Bunglow",@"Row House",@"Godown",@"Show Room",@"Duplex",@"Multiplex",@"Land",@"Plot"];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please turn on internet connection or use Wi-Fi to access data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        [HUD showWhileExecuting:@selector(WebServiceForFetchProjectList) onTarget:self withObject:nil animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)WebServiceForFetchProjectList{
    NSString *str_ComplrteUrl = [NSString stringWithFormat:@"http://166.62.81.20:8091/EnquiryManagement.svc/Web/GetProjectMasterList"] ;
    
    self.globalArrayOrderDetails = [[NSMutableArray alloc]init];
    
    //SaasId, LogInId, Password
    NSString *strDname = [[NSUserDefaults standardUserDefaults]valueForKey:@"CompanyDataBasePath"];
    
    
    NSDictionary *dict;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            strDname, @"DName",
            nil];
    [self.globalArrayOrderDetails addObject:dict];
    
    //NSLog(@"globalArrayOrderDetails=%@",globalArrayOrderDetails);
    
    NSData *jsonData4 = [NSJSONSerialization dataWithJSONObject:self.globalArrayOrderDetails options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strOrderDetails = [[NSString alloc] initWithData:jsonData4 encoding:NSUTF8StringEncoding];
    
    
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"[" withString:@""];
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    //NSLog(@"strOrderDetails=%@",strOrderDetails);
    
    //web parsing method:
    BaseViewController *baseviewcontroller = [[BaseViewController alloc]init];
    NSDictionary *dictionary =  [baseviewcontroller WebParsingMethod:str_ComplrteUrl:strOrderDetails];
    
    //NSLog(@"dict=%@",[dictionary valueForKey:@"GetProjectMasterListResult"]);
    [HUD hide:YES];
    
    self.arrayProjectList = [dictionary valueForKey:@"GetProjectMasterListResult"];
}


-(void)WebServiceForGetBuildingMasterListByRangeAndSearch{
    NSString *str_ComplrteUrl = [NSString stringWithFormat:@"http://166.62.81.20:8091/EnquiryManagement.svc/Web/GetBuildingMasterListByRangeAndSearch"] ;
    
    self.globalArrayOrderDetails = [[NSMutableArray alloc]init];
    
    //SaasId, LogInId, Password
    NSString *strDname =  [[NSUserDefaults standardUserDefaults]valueForKey:@"CompanyDataBasePath"];
    NSString *strsortOrder = @"";
    NSString *strSortField = @"";
    NSString *strindexToStartFrom = @"0";
    NSString *strNumberElemnet = @"0";
    NSString *strSearchOnField = @"ProjectId";
    NSString *strSearchFor = self.selectedProjectID;
    
    
    NSDictionary *dict;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            strDname, @"Dname",
            strsortOrder, @"sortOrder",
            strSortField, @"SortField",
            strindexToStartFrom, @"indexToStartFrom",
            strNumberElemnet, @"NumberElemnet",
            strSearchOnField, @"SearchOnField",
            strSearchFor, @"SearchFor",
            nil];
    [self.globalArrayOrderDetails addObject:dict];
    
    //NSLog(@"globalArrayOrderDetails=%@",globalArrayOrderDetails);
    
    NSData *jsonData4 = [NSJSONSerialization dataWithJSONObject:self.globalArrayOrderDetails options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strOrderDetails = [[NSString alloc] initWithData:jsonData4 encoding:NSUTF8StringEncoding];
    
    
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"[" withString:@""];
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    //NSLog(@"strOrderDetails=%@",strOrderDetails);
    
    //web parsing method:
    BaseViewController *baseviewcontroller = [[BaseViewController alloc]init];
    NSDictionary *dictionary =  [baseviewcontroller WebParsingMethod:str_ComplrteUrl:strOrderDetails];
    
    // NSLog(@"dict=%@",[dictionary valueForKey:@"GetBuildingMasterListByRangeAndSearchResult"]);
    
    [HUD hide:YES];
    
    
    self.arrayBuildingList = [[NSMutableArray alloc]init];
    
    NSDictionary *dictAll;
    dictAll = [NSDictionary dictionaryWithObjectsAndKeys:
               @"All", @"DisplayName",
               @"All", @"BuildingId",
               nil];
    [self.arrayBuildingList addObject:dictAll];
    
    
    
    NSArray *arrayResults = [dictionary valueForKey:@"GetBuildingMasterListByRangeAndSearchResult"];
    if ([arrayResults count]>0) {
        for (int i=0; i<[arrayResults count]; i++) {
            [self.arrayBuildingList addObject:[arrayResults objectAtIndex:i]];
        }
    }
}


-(void)WebServiceForOutstandingSummary {
    //http:// http://166.62.81.20:8091/EnquiryManagement.svc/Web/GetOutstandingReportForMobileApp
    
    /*{"SaasID" :"RI001","CompanyId" :"DE001","prmOutStandingReportModelResponse":{
    "OutStandingSummery":"0",
    "ProjectId":"0",
    "BuildingId":"0",
    "UnitId":"0",
    "GraceDays":"0",SummaryList
    "AmountingAbove":"0",
    "InterestOnAgreemtCost":"0",
    "InterestOnOtherCharges":"0",
    "WithInvestorFlag":"1",
    "OnlyInvetorFlag":"0",
    "NegativeInterestFlag":"0",
    "ReportDate":"\/Date(1446035448500)\/",
    "BookingDateWiseFlag":"0",
    "ShowZeroBalance":"0",
    "AcessPaymentFlag":"1",
    "ClubbedInterestFlag":"0",
    "BrokerId":"0",
    "SalesPersonId":"0",
    "LoanProviderId":"0",
    "ResidencialFlag":"0",
    "CommercialFlag":"0",
    "ExcludeNotForSale":"0"}
}} */
    
    NSString *str_ComplrteUrl = [NSString stringWithFormat:@"http://166.62.81.20:8091/EnquiryManagement.svc/Web/GetOutstandingReportForMobileApp"] ;
    
    self.globalArrayOrderDetails = [[NSMutableArray alloc]init];
    
    NSString *strButBuilding = self.btnBuildingList.titleLabel.text;
    NSString *strprmProjectId = self.selectedProjectID;
    
    NSString *strprmBuildingId;
    
    
    if([strButBuilding isEqualToString:@"All"])
    {
        strprmBuildingId = @"0";
    }else{
        strprmBuildingId = self.selectedBuildingID;
    }
    
    
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *dateStarted = [NSString stringWithFormat:@"/Date(%.0f)/", interval * 1000];
    
    
    NSDictionary *dictPrmOutStandingReportModelResponse = [NSDictionary dictionaryWithObjectsAndKeys:
            @"0", @"OutStandingSummery",
            strprmProjectId, @"ProjectId",
            strprmBuildingId, @"BuildingId",
            @"0", @"UnitId",
            @"0", @"GraceDays",
            @"0", @"AmountingAbove",
            @"0", @"InterestOnAgreemtCost",
            @"0", @"InterestOnOtherCharges",
            @"1", @"WithInvestorFlag",
            @"0", @"OnlyInvetorFlag",
            @"0", @"NegativeInterestFlag",
            dateStarted, @"ReportDate",
            @"0", @"BookingDateWiseFlag",
            @"0", @"ShowZeroBalance",
            @"1", @"AcessPaymentFlag",
            @"0", @"ClubbedInterestFlag",
            @"0", @"BrokerId",
            @"0", @"SalesPersonId",
            @"0", @"LoanProviderId",
            @"0", @"ResidencialFlag",
            @"0", @"CommercialFlag",
            @"0", @"ExcludeNotForSale",
            nil];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *strSaasId=[defaults objectForKey:@"SAASID"];
    NSString *strLogInId=[defaults objectForKey:@"strSelectedCompanyID"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          strSaasId, @"SaasID",
                          strLogInId, @"CompanyId",
                          dictPrmOutStandingReportModelResponse,@"prmOutStandingReportModelResponse", nil];
    
    
    [self.globalArrayOrderDetails addObject:dict];
    
    // NSLog(@"globalArrayOrderDetails=%@",globalArrayOrderDetails);
    
    NSData *jsonData4 = [NSJSONSerialization dataWithJSONObject:self.globalArrayOrderDetails options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strOrderDetails = [[NSString alloc] initWithData:jsonData4 encoding:NSUTF8StringEncoding];
    
    
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"[" withString:@""];
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    // NSLog(@"strOrderDetails=%@",strOrderDetails);
    
    //web parsing method:
    BaseViewController *baseviewcontroller = [[BaseViewController alloc]init];
    NSDictionary *dictionary =  [baseviewcontroller WebParsingMethod:str_ComplrteUrl:strOrderDetails];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (dictionary != nil && ([[dictionary objectForKey:@"GetOutstandingReportForMobileAppResult"] isKindOfClass:[NSArray class]] && [[dictionary objectForKey:@"GetOutstandingReportForMobileAppResult"] count] > 0)) {
            self.SummaryList = [NSArray arrayWithArray:[dictionary objectForKey:@"GetOutstandingReportForMobileAppResult"]];
            
            if ([self.SummaryList count] > 0) {
                [self.searchBar setHidden:NO];
                [self.tblSummaryList setHidden:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tblSummaryList reloadData];
                });
                
                
            }
        }else {
            [self.searchBar setHidden:YES];
            [self.tblSummaryList setHidden:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Data not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    });

    /*if (dictionary != nil && ([[dictionary objectForKey:@"GetOutstandingReportForMobileAppResult"] isKindOfClass:[NSArray class]] && [[dictionary objectForKey:@"GetOutstandingReportForMobileAppResult"] count] > 0)) {
        self.SummaryList = [NSArray arrayWithArray:[dictionary objectForKey:@"GetOutstandingReportForMobileAppResult"]];
        
        if ([self.SummaryList count] > 0) {
            [self.searchBar setHidden:NO];
            [self.tblSummaryList setHidden:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tblSummaryList reloadData];
            });
            
            
        }
    }else {
        [self.searchBar setHidden:YES];
        [self.tblSummaryList setHidden:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Data not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }*/
    
}

-(IBAction)ProjectPickerViewAction:(id)sender{
    
    self.strPickerViewSelected = @"Project";
    [self ShowPickerView];
}

-(IBAction)UnitTypePickerViewAction:(id)sender{
    
    self.strPickerViewSelected = @"Unit";
    [self ShowPickerView];
}

-(IBAction)BuildingPickerViewAction:(id)sender{
    
   self.strPickerViewSelected = @"Building";
    [self ShowPickerView];
    
}

-(IBAction)btnSearchClickedAction:(id)sender{
    
    [actionSheet removeFromSuperview];
    
    NSString *strButProject =  self.btnProjectList.titleLabel.text;
    NSString *strButBuilding = self.btnBuildingList.titleLabel.text;
    
    if([strButProject isEqualToString:@"Select Project"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select project." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else  if([strButBuilding isEqualToString:@"Select Building"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select building." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        [HUD showWhileExecuting:@selector(WebServiceForOutstandingSummary) onTarget:self withObject:nil animated:YES];
    }
    
}


-(void)ShowPickerView{
    ///PickerSheet
    [actionSheet removeFromSuperview];
    
    
    actionSheet = [[UIView alloc]init];
    // Date picker view
    UIPickerView * pickerViewEmirates = [[UIPickerView alloc]init];
    pickerViewEmirates.showsSelectionIndicator=YES;
    [pickerViewEmirates selectRow:0 inComponent:0 animated:YES];
    
    
    
    [pickerViewEmirates setBackgroundColor:[UIColor whiteColor]];
    
    // Toolbar create
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    // Check the ios version
    NSString *version = [[UIDevice currentDevice] systemVersion];
    int ver = [version intValue];
    if (ver < 7){
        //iOS 6 work
        toolbar.barStyle = UIBarStyleBlackTranslucent;
    }
    else{
        //iOS 7 related work
        toolbar.barStyle = UIBarStyleDefault;
    }
    [toolbar sizeToFit];
    
    // Adding Done button on toolbar
    [toolbar setItems:@[
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelMethodOfEmairates)],
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneMethod)]]];
    
    // Adding pickerview, toolbar and displaying in view
    
    
    pickerViewEmirates.delegate = self;
    pickerViewEmirates.dataSource = self;
    
    
    
    // Set the actionsheet frame for iPhone4 and iPhone5
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568)
    {
        
        [actionSheet setFrame:CGRectMake(0, self.view.frame.size.height-200, 320, 250)];
    }
    else{
        
        [actionSheet setFrame:CGRectMake(0, self.view.frame.size.height-246, 320, 258)];
        pickerViewEmirates.frame = CGRectMake(0, 44, 320, 214);
        
    }
    [actionSheet addSubview:pickerViewEmirates];
    [actionSheet addSubview:toolbar];
    [self.view addSubview:actionSheet];
}


//Cancel Method Of Emirates
-(void)cancelMethodOfEmairates{
    
    [actionSheet removeFromSuperview];
}

-(void)DoneMethod{
    [actionSheet removeFromSuperview];
    
    if([self.strPickerViewSelected isEqualToString:@"Project"]){
        if (self.selectedProjectName == nil) {
            [self.btnProjectList setTitle:@"Select Project" forState:UIControlStateNormal];
            self.selectedProjectID =nil;
        }else{
            [self.btnProjectList setTitle:self.selectedProjectName forState:UIControlStateNormal];
            [HUD showWhileExecuting:@selector(WebServiceForGetBuildingMasterListByRangeAndSearch) onTarget:self withObject:nil animated:YES];
        }
    }else if([self.strPickerViewSelected isEqualToString:@"Building"]){
        if (self.selectedBuildingName == nil) {
            [self.btnBuildingList setTitle:@"Select Building" forState:UIControlStateNormal];
            self.selectedBuildingID =nil;
        }else{
            [self.btnBuildingList setTitle:self.selectedBuildingName forState:UIControlStateNormal];
        }
    }
}

#pragma mark picker delegate method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// Picker view method
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([self.strPickerViewSelected isEqualToString:@"Project"]){
        return [self.arrayProjectList count];
    }else{
        return [self.arrayBuildingList count];
    }
}

// Picker view method
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([self.strPickerViewSelected isEqualToString:@"Project"]){
        return [[self.arrayProjectList objectAtIndex:row] valueForKey:@"DisplayName"];
    }else{
        return [[self.arrayProjectList objectAtIndex:row] valueForKey:@"DisplayName"];
    }
}

// Picker view method
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if([self.strPickerViewSelected isEqualToString:@"Project"]){
        self.selectedProjectName = [[self.arrayProjectList objectAtIndex:row] valueForKey:@"DisplayName"];
        self.selectedProjectID =[[self.arrayProjectList objectAtIndex:row] valueForKey:@"ProjectId"];
    }else{
        self.selectedBuildingName = [[self.arrayBuildingList objectAtIndex:row] valueForKey:@"DisplayName"];
        self.selectedBuildingID =[[self.arrayBuildingList objectAtIndex:row] valueForKey:@"BuildingId"];
    }
    
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    // Get the text of the row.
    NSString *rowItem;
    
    if([self.strPickerViewSelected isEqualToString:@"Project"]){
        rowItem = [[self.arrayProjectList objectAtIndex:row] valueForKey:@"DisplayName"];
    }else{
        rowItem = [[self.arrayBuildingList objectAtIndex:row] valueForKey:@"DisplayName"];
    }
    
    // Create and init a new UILabel.
    // We must set our label's width equal to our picker's width.
    // We'll give the default height in each row.
    UILabel *lblRow = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView bounds].size.width, 44.0f)];
    
    // Center the text.
    [lblRow setTextAlignment:NSTextAlignmentCenter];
    
    // Make the text color
    [lblRow setTextColor: [UIColor darkGrayColor]];
    [lblRow setFont:[UIFont fontWithName:@"GillSans" size:18]];
    // Add the text.
    [lblRow setText:rowItem];
    
    // Clear the background color to avoid problems with the display.
    [lblRow setBackgroundColor:[UIColor clearColor]];
    
    // Return the label.
    return lblRow;
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
        return [self.filteredSummaryList count];
    }
    else {
        return [self.SummaryList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *cellIdentifier = @"SummaryTableCell";
    
    SummaryTableCellTableViewCell *summaryCell = (SummaryTableCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (summaryCell == nil) {
        summaryCell = [[SummaryTableCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    NSDictionary *dict = nil;
    
    if (isSearching && [self.filteredSummaryList count]>0) {
        dict = [self.filteredSummaryList objectAtIndex:indexPath.row];
    }else {
        dict = [self.SummaryList objectAtIndex:indexPath.row];
    }
    
        summaryCell.thumbnailImageView.layer.cornerRadius = 20.0f;
        summaryCell.thumbnailImageView.layer.borderWidth = 0.2f;
        summaryCell.thumbnailImageView.layer.borderColor = [UIColor blackColor].CGColor;
        summaryCell.thumbnailImageView.clipsToBounds = YES;
        [summaryCell.thumbnailImageView setImageWithString:[dict objectForKey:@"Name"]];
    
    
        double totalBalance = [[dict objectForKey:@"BalnceAgainstDueOfAgreemetCost"] doubleValue] + [[dict objectForKey:@"BalnceAgainstDueOfOtherChargesTotal"] doubleValue];

    
        summaryCell.lblCustNameWithFlatNo.text = [NSString stringWithFormat:@"%@(%@) - %@" , [dict objectForKey:@"Name"],[dict objectForKey:@"UnitNoDesc"],[NSString stringWithFormat:@"%.2f",totalBalance]];
        summaryCell.lblMobileNo.text = [dict objectForKey:@"MobileNo"];
        [summaryCell.btnCall addTarget:self action:@selector(callPhoneNumber:) forControlEvents:UIControlEventTouchDown];

    
    
    return summaryCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SummaryDetailsViewController *vc = [[SummaryDetailsViewController alloc]initWithNibName:@"SummaryDetailsViewController" bundle:nil];
    

    if (isSearching && [self.filteredSummaryList count]>0) {
        vc.dictDetails = [self.filteredSummaryList objectAtIndex:indexPath.row];
    }else {
        vc.dictDetails = [self.SummaryList objectAtIndex:indexPath.row];
    }
    
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

-(void) callPhoneNumber:(id)sender {
    
    SummaryTableCellTableViewCell* cell = (SummaryTableCellTableViewCell*)[[sender superview] superview];
    NSIndexPath* indexPath = [self.tblSummaryList indexPathForCell:cell];
    
    NSDictionary *dict;
    
    if (isSearching && [self.filteredSummaryList count] >0) {
        dict = [self.filteredSummaryList objectAtIndex:indexPath.row];
    }else {
        dict = [self.SummaryList objectAtIndex:indexPath.row];
    }
    
    NSString *phNo = [dict objectForKey:@"MobileNo"];
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
    
    for (NSDictionary *dict in self.SummaryList) {
        NSString *tempStr = [dict objectForKey:@"Name"];

        NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            [self.filteredSummaryList addObject:dict];
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
    [self.filteredSummaryList removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching = YES;
        NSString *searchString = _searchBar.text;
        
        for (NSDictionary *dict in self.SummaryList) {
            NSString *tempStr = [dict objectForKey:@"Name"];
            
//            NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
//            if (result == NSOrderedSame) {
//                [self.filteredSummaryList addObject:dict];
//            }

            if (tempStr.length >= searchText.length)
            {
                NSRange titleResultsRange = [tempStr rangeOfString:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
                if (titleResultsRange.length > 0)
                {
                    [self.filteredSummaryList addObject:dict];
                }
            }
            
        }
    }
    else {
        isSearching = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblSummaryList reloadData];
    });
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
    isSearching = NO;
    _searchBar.showsCancelButton=NO;
    [_searchBar resignFirstResponder];
    [self.tblSummaryList reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    //[self searchTableList];
    [searchBar resignFirstResponder];
    
}


- (void)viewDidUnload {
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
