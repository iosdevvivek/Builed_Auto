//
//  LoginViewController.m
//  BuildAuto
//
//  Created by Panacea on 7/8/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "BSKeyboardControls.h"
#import "Reachability.h"

#import "JWSlideMenuController.h"
#import "JWNavigationController.h"
#import "FloorwiseViewController.h"
#import "ProjectsViewController.h"

#import "SHSidebarController.h"
#import "CustomerManagementViewController.h"
#import "EnquiryManagementViewController.h"
#import "HomeViewController.h"

@interface LoginViewController (){
     NSMutableArray *globalArrayOrderDetails;
     NSString *selectedPickerItem,*selectedPickerItemID;
    NSArray *arrUserTypes;
    NSArray *arrResults;
}

@end

@implementation LoginViewController
@synthesize imgTextCompIDBg,imgTextPasswordBg,imgTextSelectUserBg,imgTextUsernameBg,btnLogin;
@synthesize txtCompanyID,txtPassword,txtUsername,btnUserType,scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;

    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    txtCompanyID.text = @"";
    txtPassword.text = @"";
    txtUsername.text = @"";
    
    btnUserType.userInteractionEnabled = NO;
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    HUD.labelText = NSLocalizedString(@"Loading..",nil);
    HUD.dimBackground = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    // Custom keyboard with previous, next & done button
    NSArray *fields = @[ self.txtCompanyID, self.txtUsername, self.txtPassword];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
    
    // Ajay - Viveak working here 
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [txtCompanyID resignFirstResponder];
    [txtUsername resignFirstResponder];
    [txtPassword resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView adjustOffsetToIdealIfNeeded];
    [self.keyboardControls setActiveField:textField];
    
}

// keyboard control direction
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls directionPressed:(BSKeyboardControlsDirection)direction
{
    UIView *view = self.keyboardControls.activeField.superview.superview;
    [self.scrollView scrollRectToVisible:view.frame animated:YES];
}

// keyboard control done button
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.keyboardControls.activeField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField == txtPassword) {
        [txtCompanyID resignFirstResponder];
        [txtUsername resignFirstResponder];
        [txtPassword resignFirstResponder];
        if ([txtCompanyID.text isEqualToString:@""]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter company ID." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if([txtUsername.text isEqualToString:@""]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else if([txtPassword.text isEqualToString:@""])
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            
            if (networkStatus == NotReachable) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please turn on internet connection or use Wi-Fi to access data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            } else {
                [HUD showWhileExecuting:@selector(WebServiceGetCompanyList) onTarget:self withObject:nil animated:YES];
                
            }
        }
    }
    
}


-(IBAction)pickerViewAction:(id)sender{
    
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
    if (selectedPickerItem == nil) {
        [btnUserType setTitle:@"Select User Type" forState:UIControlStateNormal];
        selectedPickerItemID =nil;
    }else{
        
        [btnUserType setTitle:selectedPickerItem forState:UIControlStateNormal];
        selectedPickerItem = nil;
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
    
    return [arrUserTypes count];
    
    
}

// Picker view method
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[arrUserTypes objectAtIndex:row] valueForKey:@"Name"];
}

// Picker view method
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    selectedPickerItem = [[arrUserTypes objectAtIndex:row] valueForKey:@"Name"];
    selectedPickerItemID =[[arrUserTypes objectAtIndex:row] valueForKey:@"Id"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedPickerItemID forKey:@"strSelectedCompanyID"];
    [defaults synchronize];
    
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    // Get the text of the row.
    NSString *rowItem = [[arrUserTypes objectAtIndex:row] valueForKey:@"Name"];
    
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




-(IBAction)btnSubmitClicked:(id)sender{
    

    
    NSString *strButUserType = btnUserType.titleLabel.text;
    
    if ([txtCompanyID.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter company ID." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([txtUsername.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if([txtPassword.text isEqualToString:@""])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([strButUserType isEqualToString:@"Select User Type"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select user type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
         [HUD showWhileExecuting:@selector(WebServiceLoginIntoApplication) onTarget:self withObject:nil animated:YES];
    }
}

- (NSString *)getDefaultJSONString {
    NSBundle *bundle = [NSBundle mainBundle];
    return [NSString stringWithContentsOfFile:[bundle pathForResource:@"default" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
}


-(void)WebServiceGetCompanyList{
    
    [txtCompanyID resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtUsername resignFirstResponder];
    
    NSString *str_ComplrteUrl = [NSString stringWithFormat:@"http://166.62.81.20:8091/EnquiryManagement.svc/Web/GetCompanyListForAuthetication"] ;
    
    globalArrayOrderDetails = [[NSMutableArray alloc]init];
    
    //SaasId, LogInId, Password
    //NSString *strSaasId = @"DO0001";
    //NSString *strLogInId = @"Krishna";
    //NSString *strPassword = @"k";
    
    NSString *strSaasId = txtCompanyID.text;
    NSString *strLogInId = txtUsername.text;
    NSString *strPassword = txtPassword.text;
    
    NSDictionary *dict;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            strSaasId, @"SaasId",
            strLogInId, @"LogInId",
            strPassword, @"Password",
            nil];
    [globalArrayOrderDetails addObject:dict];
    
   // NSLog(@"globalArrayOrderDetails=%@",globalArrayOrderDetails);
    
    NSData *jsonData4 = [NSJSONSerialization dataWithJSONObject:globalArrayOrderDetails options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strOrderDetails = [[NSString alloc] initWithData:jsonData4 encoding:NSUTF8StringEncoding];
    
    
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"[" withString:@""];
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    //NSLog(@"strOrderDetails=%@",strOrderDetails);
    
    //web parsing method:
    BaseViewController *baseviewcontroller = [[BaseViewController alloc]init];
    NSDictionary *dictionary =  [baseviewcontroller WebParsingMethod:str_ComplrteUrl:strOrderDetails];
    
    //NSLog(@"dict=%@",[dictionary valueForKey:@"GetCompanyListForAutheticationResult"]);
    dispatch_async(dispatch_get_main_queue(), ^
    {
    [HUD hide:YES];
    
    arrUserTypes = [dictionary valueForKey:@"GetCompanyListForAutheticationResult"];
    
    if ([arrUserTypes count]>0) {
        btnUserType.userInteractionEnabled = YES;
        
    }else if ([[[dictionary valueForKey:@"ObjBaseResponse"] valueForKey:@"strMessage"] isEqualToString:@"Authentication Failed"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Invalid username or password. Please check login details entered." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Server is under maintainence. Try after some time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    });
}


-(void)WebServiceLoginIntoApplication{
    NSString *str_ComplrteUrl = [NSString stringWithFormat:@"http://166.62.81.20:8091/EnquiryManagement.svc/Web/AutheticatUserWithCompany"] ;
    
    globalArrayOrderDetails = [[NSMutableArray alloc]init];
    
    
    NSString *strSaasId = txtCompanyID.text;
    NSString *strLogInId = txtUsername.text;
    NSString *strPassword = txtPassword.text;
    NSString *strCompanyId = selectedPickerItemID;
   
    
    NSDictionary *dict;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            strSaasId, @"SaasId",
            strCompanyId, @"CompanyId",
            strLogInId, @"LogInId",
            strPassword, @"Password",
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
    
    //NSLog(@"dict=%@",[dictionary valueForKey:@"AutheticatUserWithCompanyResult"]);
    
  
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
      [HUD hide:YES];
        
    arrResults = [dictionary valueForKey:@"AutheticatUserWithCompanyResult"];
    
    if ([arrUserTypes count]>0) {
        
        NSString *strCompanyDataBasePath = [[dictionary valueForKey:@"AutheticatUserWithCompanyResult"]valueForKey:@"CompanyDataBasePath"];
        NSString *strCompanyDesc = [[dictionary valueForKey:@"AutheticatUserWithCompanyResult"]valueForKey:@"CompanyDesc"];
        NSString *strGlobalMasterDataBase = [[dictionary valueForKey:@"AutheticatUserWithCompanyResult"]valueForKey:@"GlobalMasterDataBase"];
        NSString *strSAASID = [[dictionary valueForKey:@"AutheticatUserWithCompanyResult"]valueForKey:@"SAASID"];
        NSString *strSalesPersonId = [[dictionary valueForKey:@"AutheticatUserWithCompanyResult"]valueForKey:@"SalesPersonId"];
        NSString *strUserID = [[dictionary valueForKey:@"AutheticatUserWithCompanyResult"]valueForKey:@"UserID"];
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:@"login" forKey:@"status"];
        [defaults setObject:strCompanyDataBasePath forKey:@"CompanyDataBasePath"];
        [defaults setObject:strSaasId forKey:@"LoginSaasId"];
        [defaults setObject:strLogInId forKey:@"LogInId"];
        [defaults setObject:strPassword forKey:@"Password"];
        [defaults setObject:strCompanyId forKey:@"CompanyId"];
        [defaults setObject:strCompanyDesc forKey:@"CompanyDesc"];
        [defaults setObject:strGlobalMasterDataBase forKey:@"GlobalMasterDataBase"];
        [defaults setObject:strSAASID forKey:@"SAASID"];
        [defaults setObject:strSalesPersonId forKey:@"SalesPersonId"];
        [defaults setObject:strUserID forKey:@"UserID"];
        [defaults synchronize];
        
        NSMutableArray *vcs = [NSMutableArray array];
        
        
        HomeViewController *objViewHome = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        
        //Navigation Controller is required
        UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:objViewHome];
        
        
        //Dictionary of the view and title
        NSDictionary *viewHome = [NSDictionary dictionaryWithObjectsAndKeys:navHome, @"vc", @"Home", @"title", nil];
        
        //And we finally add it to the array
        [vcs addObject:viewHome];
        

        EnquiryManagementViewController *objView = [[EnquiryManagementViewController alloc]initWithNibName:@"EnquiryManagementViewController" bundle:nil];
                
        //Navigation Controller is required
        UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:objView];
    
        
        //Dictionary of the view and title
        NSDictionary *view = [NSDictionary dictionaryWithObjectsAndKeys:nav1, @"vc", @"Enquiry Management", @"title", nil];
                
        //And we finally add it to the array
        [vcs addObject:view];
        
        
        
        CustomerManagementViewController *objViewCust = [[CustomerManagementViewController alloc]initWithNibName:@"CustomerManagementViewController" bundle:nil];
        
        //Navigation Controller is required
        UINavigationController *navCust = [[UINavigationController alloc] initWithRootViewController:objViewCust];
        
        
        //Dictionary of the view and title
        NSDictionary *viewCust = [NSDictionary dictionaryWithObjectsAndKeys:navCust, @"vc", @"Customer Management", @"title", nil];
        
        //And we finally add it to the array
        [vcs addObject:viewCust];
        
        
 
        //Create controller and set views
        SHSidebarController *sidebar = [[SHSidebarController alloc] initWithArrayOfVC:vcs];
        
        [self.navigationController pushViewController:sidebar animated:YES];
        
  
    }else if ([[[dictionary valueForKey:@"ObjBaseResponse"] valueForKey:@"strMessage"] isEqualToString:@"You May not Have Right To Selected Comapny"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"You may not have rights to selected company." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Server is under maintainence. Try after some time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    });
   
}






@end
