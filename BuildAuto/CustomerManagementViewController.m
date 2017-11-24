//
//  CustomerManagementViewController.m
//  BuildAuto
//
//  Created by Panacea on 9/13/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import "CustomerManagementViewController.h"
#import "MeterViewController.h"
#import "OutstandingSummaryViewController.h"

@interface CustomerManagementViewController ()

@end

@implementation CustomerManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Customer Management";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnSalesReports:(id)sender{
    MeterViewController *vc = [[MeterViewController alloc]initWithNibName:@"MeterViewController" bundle:nil];
       self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnOutstandingSummary:(id)sender{
    OutstandingSummaryViewController *vc = [[OutstandingSummaryViewController alloc]initWithNibName:@"OutstandingSummaryViewController" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
