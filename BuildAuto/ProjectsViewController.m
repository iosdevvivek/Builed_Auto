//
//  ProjectsViewController.m
//  BuildAuto
//
//  Created by Panacea on 8/2/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//


#import "ProjectsViewController.h"
#import "BaseViewController.h"
#import "AppDelegate.h"
#import "FloorwiseViewController.h"
#import "Reachability.h"
#import "MHMainTabBarController.h"
#import "AvailabilityChartViewController.h"


@interface ProjectsViewController ()<MHMainTabBarControllerDelegate>{
    NSMutableArray *globalArrayOrderDetails;
    
    NSArray *arrayProjectList;
    NSArray *arrayUnitTpeList;
    NSMutableArray *arrayBuildingList;
    
    NSString *strPickerViewSelected;
    
    NSString *selectedProjectName,*selectedProjectID;
    NSString *selectedBuildingName,*selectedBuildingID;
    NSString *selectedUnitTypeName;
}

@end

@implementation ProjectsViewController
@synthesize btnProjectList,btnBuildingList,btnUnitType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"Availability Chart";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    HUD.labelText = NSLocalizedString(@"Loading..",nil);
    HUD.dimBackground = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    arrayUnitTpeList = @[@"All",@"Flat",@"Shop",@"Office",@"Bunglow",@"Row House",@"Godown",@"Show Room",@"Duplex",@"Multiplex",@"Land",@"Plot"];
    
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

-(void)Logout{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:@"logout" forKey:@"status"];
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)WebServiceForAvailabilityChart{
    NSString *str_ComplrteUrl = [NSString stringWithFormat:@"http://166.62.81.20:8091/EnquiryManagement.svc/Web/GetProjectStatusOfUnitSaleViewResponse"] ;
    
    globalArrayOrderDetails = [[NSMutableArray alloc]init];
    
    NSString *strButBuilding = btnProjectList.titleLabel.text;
    
    NSString *strDname = [[NSUserDefaults standardUserDefaults]valueForKey:@"CompanyDataBasePath"];
    NSString *strprmBuildingId;
    NSString *strprmProjectId = selectedProjectID;

    if([strButBuilding isEqualToString:@"All"])
    {
        strprmBuildingId = @"0";
    }else{
        strprmBuildingId = selectedBuildingID;
    }
    
    NSDictionary *dict;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            strDname, @"Dname",
            @"", @"prmBuildingId",
            strprmProjectId, @"prmProjectId",
            nil];
    [globalArrayOrderDetails addObject:dict];
    
   // NSLog(@"globalArrayOrderDetails=%@",globalArrayOrderDetails);
    
    NSData *jsonData4 = [NSJSONSerialization dataWithJSONObject:globalArrayOrderDetails options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strOrderDetails = [[NSString alloc] initWithData:jsonData4 encoding:NSUTF8StringEncoding];
    
    
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"[" withString:@""];
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
   // NSLog(@"strOrderDetails=%@",strOrderDetails);
    
    //web parsing method:
    BaseViewController *baseviewcontroller = [[BaseViewController alloc]init];
    NSDictionary *dictionary =  [baseviewcontroller WebParsingMethod:str_ComplrteUrl:strOrderDetails];
    
    [self handleGetProjectStatusOfUnitSaleViewResponse:dictionary];
    //NSLog(@"dict=%@",[dictionary valueForKey:@"GetProjectStatusOfUnitSaleViewResponseResult"]);
    
    ;
}


-(void) handleGetProjectStatusOfUnitSaleViewResponse :(NSDictionary*) dictionary {

dispatch_async(dispatch_get_main_queue(), ^ {

        [HUD hide:YES];

    NSArray *arrayResults = [dictionary valueForKey:@"GetProjectStatusOfUnitSaleViewResponseResult"];
    
    if ([arrayResults isKindOfClass:[NSArray class]] && [arrayResults count] > 0 ) {
        
            NSMutableArray *arrBuildingWise = [[NSMutableArray alloc]init];
            NSMutableArray *arrBuildingWiseResults = [[NSMutableArray alloc]init];
            
            if ([arrayResults count]>0) {
                for (int i=0; i<[arrayResults count]; i++) {
                    
                    NSString *strFloorValue = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:i]valueForKey:@"BuildingDescription"]];
                    if ([arrBuildingWise containsObject:strFloorValue]) {
                        
                    }else{
                        [arrBuildingWise addObject:strFloorValue];
                    }
                }
            }
            
            //NSLog(@"arrBuildingWise=%@",arrBuildingWise);
            NSArray *arraySorted = [arrBuildingWise copy];
            arraySorted = [arraySorted sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            arrBuildingWise = [arraySorted mutableCopy];
            
            if ([arrBuildingWise count]>0) {
                for (int i=0; i<[arrBuildingWise count]; i++) {
                    
                    NSString *strBuildingName = [NSString stringWithFormat:@"%@",[arrBuildingWise objectAtIndex:i]];
                    NSMutableArray *arrBuildingWise = [[NSMutableArray alloc]init];
                    
                    for (int j=0; j<[arrayResults count]; j++) {
                        NSString *strBuilding = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:j]valueForKey:@"BuildingDescription"]];
                        if ([strBuildingName isEqualToString:strBuilding]) {
                            [arrBuildingWise addObject:[arrayResults objectAtIndex:j]];
                        }
                    }
                    
                    NSDictionary *dict;
                    dict = [NSDictionary dictionaryWithObjectsAndKeys:
                            strBuildingName, @"strBuildingWise",
                            arrBuildingWise, @"arrBuildingWiseResults",
                            nil];
                    [arrBuildingWiseResults addObject:dict];
                    
                }
            }
            
            NSLog(@"arrBuildingWiseResults=%@",arrBuildingWiseResults);
            
            
            NSMutableArray *arrViewControllers;
            arrViewControllers = [[NSMutableArray alloc]init];
            
            if ([arrBuildingWiseResults count]>0) {
                for (int k=0; k<[arrBuildingWiseResults count]; k++) {
                    FloorwiseViewController *listViewController = [[FloorwiseViewController alloc] initWithNibName:@"FloorwiseViewController" bundle:nil];
                    [arrViewControllers addObject:listViewController];
                    listViewController.title = [[arrBuildingWiseResults objectAtIndex:k]valueForKey:@"strBuildingWise"];
                    listViewController.arrayResults = [[arrBuildingWiseResults objectAtIndex:k]valueForKey:@"arrBuildingWiseResults"];
                }
            }
            
            
            int cntVacant;
            cntVacant = 0;
            
            int cntRefuge;
            cntRefuge = 0;
            
            int cntNotforSale;
            cntNotforSale = 0;
            
            int cntBooked;
            cntBooked = 0;
            
            
            int cntHeld;
            cntHeld = 0;
            
            if ([arrBuildingWiseResults count]>0) {
                for (int h=0;h<[arrBuildingWiseResults count]; h++) {
                    
                    NSArray *arrData  = [[arrBuildingWiseResults objectAtIndex:h]valueForKey:@"arrBuildingWiseResults"];
                    
                    if ([arrData count]>0) {
                        for (int i=0; i<[arrData count]; i++) {
                            ;
                            
                            NSString *strHoldFlag;
                            NSString *strIsBookFlag;
                            
                            if ([[arrData objectAtIndex:i] valueForKey:@"Hold"] == nil || [[arrData objectAtIndex:i] valueForKey:@"Hold"] == (id)[NSNull null]) {
                                strHoldFlag = @"False";
                                
                                
                            }else{
                                if ([[[arrData objectAtIndex:i] valueForKey:@"Hold"]boolValue] == true) {
                                    strHoldFlag = @"True";
                                }else{
                                    strHoldFlag = @"False";
                                }
                            }
                            
                            
                            if ([[arrData objectAtIndex:i] valueForKey:@"IsBookFlag"] == nil || [[arrData objectAtIndex:i] valueForKey:@"IsBookFlag"] == (id)[NSNull null]) {
                                strIsBookFlag = @"False";
                            }else{
                                if ([[[arrData objectAtIndex:i] valueForKey:@"IsBookFlag"]boolValue] == true) {
                                    strIsBookFlag = @"True";
                                }else{
                                    strIsBookFlag = @"False";
                                }
                                
                            }
                            
                            
                            if (![strHoldFlag isEqualToString:@"True"] && ![[[arrData objectAtIndex:i] valueForKey:@"NotForSaleUnit"] boolValue] == true && ![strIsBookFlag isEqualToString:@"True"] && ![[[arrData objectAtIndex:i] valueForKey:@"RefusedUnit"] boolValue] == true)
                            {
                                NSLog(@"True");
                                cntVacant = cntVacant+1;
                            }else{
                                NSLog(@"False");
                                //cntVacant = cntVacant+1;
                            }
                            
                            
                            
                            if ([[[arrData objectAtIndex:i] valueForKey:@"RefusedUnit"] boolValue] == true) {
                                cntRefuge = cntRefuge +1;
                            }
                            
                            if ([[[arrData objectAtIndex:i] valueForKey:@"NotForSaleUnit"] boolValue] == true) {
                                cntNotforSale = cntNotforSale+1;
                            }
                            
                            if ([strIsBookFlag isEqualToString:@"True"]) {
                                cntBooked = cntBooked+1;
                            }
                            
                            
                            if ([strHoldFlag isEqualToString:@"True"]) {
                                cntHeld = cntHeld+1;
                            }
                        }
                        
                        
                    }
                    
                    
                    
                }
            }
            
            
            NSLog(@"cntHeld=%d",cntHeld);
            NSLog(@"cntBooked=%d",cntBooked);
            NSLog(@"cntNotforSale=%d",cntNotforSale);
            NSLog(@"cntRefuge=%d",cntRefuge);
            NSLog(@"cntVacant=%d",cntVacant);
            
            int totalUnit = cntHeld+cntBooked+cntNotforSale+cntRefuge+cntVacant;
            
            
            NSString *strcntHeld = [NSString stringWithFormat:@"%d",cntHeld];
            NSString *strcntBooked = [NSString stringWithFormat:@"%d",cntBooked];
            NSString *strcntNotforSale = [NSString stringWithFormat:@"%d",cntNotforSale];
            NSString *strcntRefuge = [NSString stringWithFormat:@"%d",cntRefuge];
            NSString *strcntVacant = [NSString stringWithFormat:@"%d",cntVacant];
            NSString *strtotalUnit = [NSString stringWithFormat:@"%d",totalUnit];
            
            NSString *strBuildingImageLink;
            NSString *strBuildingVideoLink;
            if ([arrayResults count]>0) {
                strBuildingImageLink = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:0]valueForKey:@"BuildingImageLink"]];
                
                strBuildingVideoLink = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:0]valueForKey:@"BuildingVideoLink"]];
            }else{
                strBuildingImageLink = @"";
                strBuildingVideoLink = @"";
            }
            
            //BuildingImageLink : null
            
            MHMainTabBarController *tabBarController = [[MHMainTabBarController alloc] initWithNibName:@"MHMainTabBarController" bundle:nil];
            
            tabBarController.delegate = self;
            tabBarController.viewControllers = arrViewControllers;
            
            tabBarController.cntRefuge = strcntRefuge;
            tabBarController.cntBooked = strcntBooked;
            tabBarController.cntHeld = strcntHeld;
            tabBarController.cntNotforSale = strcntNotforSale;
            tabBarController.cntVacant = strcntVacant;
            tabBarController.strTotalUnit = strtotalUnit;
            tabBarController.strBuildingImageLink = strBuildingImageLink;
            tabBarController.strBuildingVideoLink = strBuildingVideoLink;
            
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationController pushViewController:tabBarController animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Data not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    });
    
}


-(void)WebServiceForFetchProjectList{
    NSString *str_ComplrteUrl = [NSString stringWithFormat:@"http://166.62.81.20:8091/EnquiryManagement.svc/Web/GetProjectMasterList"] ;
    
    globalArrayOrderDetails = [[NSMutableArray alloc]init];
    
    //SaasId, LogInId, Password
    NSString *strDname = [[NSUserDefaults standardUserDefaults]valueForKey:@"CompanyDataBasePath"];
    
    
    NSDictionary *dict;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            strDname, @"DName",
            nil];
    [globalArrayOrderDetails addObject:dict];
    
    //NSLog(@"globalArrayOrderDetails=%@",globalArrayOrderDetails);
    
    NSData *jsonData4 = [NSJSONSerialization dataWithJSONObject:globalArrayOrderDetails options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strOrderDetails = [[NSString alloc] initWithData:jsonData4 encoding:NSUTF8StringEncoding];
    
    
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"[" withString:@""];
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    //NSLog(@"strOrderDetails=%@",strOrderDetails);
    
    //web parsing method:
    BaseViewController *baseviewcontroller = [[BaseViewController alloc]init];
    NSDictionary *dictionary =  [baseviewcontroller WebParsingMethod:str_ComplrteUrl:strOrderDetails];
    
    //NSLog(@"dict=%@",[dictionary valueForKey:@"GetProjectMasterListResult"]);
    [HUD hide:YES];
    
    arrayProjectList = [dictionary valueForKey:@"GetProjectMasterListResult"];
}


-(void)WebServiceForGetBuildingMasterListByRangeAndSearch{
    NSString *str_ComplrteUrl = [NSString stringWithFormat:@"http://166.62.81.20:8091/EnquiryManagement.svc/Web/GetBuildingMasterListByRangeAndSearch"] ;
    
    globalArrayOrderDetails = [[NSMutableArray alloc]init];
    
    //SaasId, LogInId, Password
    NSString *strDname =  [[NSUserDefaults standardUserDefaults]valueForKey:@"CompanyDataBasePath"];
    NSString *strsortOrder = @"";
    NSString *strSortField = @"";
    NSString *strindexToStartFrom = @"0";
    NSString *strNumberElemnet = @"0";
    NSString *strSearchOnField = @"ProjectId";
    NSString *strSearchFor = selectedProjectID;
    
    
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
    [globalArrayOrderDetails addObject:dict];
    
    //NSLog(@"globalArrayOrderDetails=%@",globalArrayOrderDetails);
    
    NSData *jsonData4 = [NSJSONSerialization dataWithJSONObject:globalArrayOrderDetails options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strOrderDetails = [[NSString alloc] initWithData:jsonData4 encoding:NSUTF8StringEncoding];
    
    
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"[" withString:@""];
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    //NSLog(@"strOrderDetails=%@",strOrderDetails);
    
    //web parsing method:
    BaseViewController *baseviewcontroller = [[BaseViewController alloc]init];
    NSDictionary *dictionary =  [baseviewcontroller WebParsingMethod:str_ComplrteUrl:strOrderDetails];
    
   // NSLog(@"dict=%@",[dictionary valueForKey:@"GetBuildingMasterListByRangeAndSearchResult"]);
    
    [HUD hide:YES];
    
    
    arrayBuildingList = [[NSMutableArray alloc]init];
    
    NSDictionary *dictAll;
    dictAll = [NSDictionary dictionaryWithObjectsAndKeys:
            @"All", @"DisplayName",
            @"All", @"BuildingId",
            nil];
    [arrayBuildingList addObject:dictAll];

    
    
    NSArray *arrayResults = [dictionary valueForKey:@"GetBuildingMasterListByRangeAndSearchResult"];
    if ([arrayResults count]>0) {
        for (int i=0; i<[arrayResults count]; i++) {
            [arrayBuildingList addObject:[arrayResults objectAtIndex:i]];
        }
    }
}



-(IBAction)ProjectPickerViewAction:(id)sender{
    
    strPickerViewSelected = @"Project";
    [self ShowPickerView];
    
}




-(IBAction)UnitTypePickerViewAction:(id)sender{
    
    strPickerViewSelected = @"Unit";
    [self ShowPickerView];
    
}



-(IBAction)BuildingPickerViewAction:(id)sender{
    
    strPickerViewSelected = @"Building";
    [self ShowPickerView];
    
}



-(IBAction)btnSearchClickedAction:(id)sender{
    
    [actionSheet removeFromSuperview];
    
    NSString *strButProject =  btnProjectList.titleLabel.text;
    NSString *strButBuilding = btnBuildingList.titleLabel.text;
    NSString *strButUnitType = btnUnitType.titleLabel.text;
    
    if([strButProject isEqualToString:@"Select Project"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select project." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if([strButUnitType isEqualToString:@"Select Unit Type"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select unit type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else  if([strButBuilding isEqualToString:@"Select Building"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select building." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        [HUD showWhileExecuting:@selector(WebServiceForAvailabilityChart) onTarget:self withObject:nil animated:YES];
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
    
    if([strPickerViewSelected isEqualToString:@"Project"]){
        if (selectedProjectName == nil) {
            [btnProjectList setTitle:@"Select Project" forState:UIControlStateNormal];
            selectedProjectID =nil;
        }else{
            [btnProjectList setTitle:selectedProjectName forState:UIControlStateNormal];
            [HUD showWhileExecuting:@selector(WebServiceForGetBuildingMasterListByRangeAndSearch) onTarget:self withObject:nil animated:YES];
        }
    }else if([strPickerViewSelected isEqualToString:@"Building"]){
        if (selectedBuildingName == nil) {
            [btnBuildingList setTitle:@"Select Building" forState:UIControlStateNormal];
            selectedBuildingID =nil;
        }else{
            [btnBuildingList setTitle:selectedBuildingName forState:UIControlStateNormal];
        }
    }else{
        if (selectedUnitTypeName == nil) {
            [btnUnitType setTitle:@"Select Unit Type" forState:UIControlStateNormal];
            
        }else{
            [btnUnitType setTitle:selectedUnitTypeName forState:UIControlStateNormal];
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
    if([strPickerViewSelected isEqualToString:@"Project"]){
         return [arrayProjectList count];
    }else if([strPickerViewSelected isEqualToString:@"Unit"]){
         return [arrayUnitTpeList count];
    }else{
         return [arrayBuildingList count];
    }
}

// Picker view method
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([strPickerViewSelected isEqualToString:@"Project"]){
         return [[arrayProjectList objectAtIndex:row] valueForKey:@"DisplayName"];
    }else if([strPickerViewSelected isEqualToString:@"Unit"]){
         return [arrayUnitTpeList objectAtIndex:row];
    }else{
         return [[arrayProjectList objectAtIndex:row] valueForKey:@"DisplayName"];
    }
}

// Picker view method
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if([strPickerViewSelected isEqualToString:@"Project"]){
        selectedProjectName = [[arrayProjectList objectAtIndex:row] valueForKey:@"DisplayName"];
        selectedProjectID =[[arrayProjectList objectAtIndex:row] valueForKey:@"ProjectId"];
    }else if([strPickerViewSelected isEqualToString:@"Unit"]){
        selectedUnitTypeName = [arrayUnitTpeList objectAtIndex:row];
    }else{
        selectedBuildingName = [[arrayBuildingList objectAtIndex:row] valueForKey:@"DisplayName"];
        selectedBuildingID =[[arrayBuildingList objectAtIndex:row] valueForKey:@"BuildingId"];
    }
 
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    // Get the text of the row.
    NSString *rowItem;
    
    if([strPickerViewSelected isEqualToString:@"Project"]){
        rowItem = [[arrayProjectList objectAtIndex:row] valueForKey:@"DisplayName"];
    }else if([strPickerViewSelected isEqualToString:@"Unit"]){
        rowItem = [arrayUnitTpeList objectAtIndex:row];
    }else{
        rowItem = [[arrayBuildingList objectAtIndex:row] valueForKey:@"DisplayName"];
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



@end
