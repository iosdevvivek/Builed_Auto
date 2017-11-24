//
//  HomeViewController.m
//  BuildAuto
//
//  Created by Panacea on 9/13/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import "HomeViewController.h"
#import "EnquiryManagementViewController.h"
#import "LoginViewController.h"
#import "CustomerManagementViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Module";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationItem.hidesBackButton = YES;
    
    // Menu icon
    UIButton *btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btnMenu setImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
    [btnMenu setTitle:@"Logout" forState:UIControlStateNormal];
    
    [btnMenu addTarget:self action:@selector(Logout) forControlEvents:UIControlEventTouchUpInside];
    
    btnMenu.frame = CGRectMake(0, 0, 60, 25);
    
    UIBarButtonItem *buttonMenu = [[UIBarButtonItem alloc]initWithCustomView:btnMenu];
    self.navigationItem.rightBarButtonItem = buttonMenu;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnEnquiryManagement:(id)sender{
    EnquiryManagementViewController *objView = [[EnquiryManagementViewController alloc]initWithNibName:@"EnquiryManagementViewController" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:objView animated:YES];
}

-(IBAction)btnCustomersManagement:(id)sender{
    CustomerManagementViewController *objView = [[CustomerManagementViewController alloc]initWithNibName:@"CustomerManagementViewController" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:objView animated:YES];
}

-(void)Logout{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure, you want to logout?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = 15;
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 15) {
        if (buttonIndex == 0) {
            
            
        }else{
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:@"logout" forKey:@"status"];
            [defaults synchronize];
            
            LoginViewController *objView = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationController pushViewController:objView animated:YES];
        }
    }
    
}



@end
