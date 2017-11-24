//
//  EnquiryManagementViewController.m
//  BuildAuto
//
//  Created by Panacea on 9/13/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import "EnquiryManagementViewController.h"
#import "ProjectsViewController.h"
#import "EnquiryDialFollowUpViewController.h"

@interface EnquiryManagementViewController ()

@end

@implementation EnquiryManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.navigationItem.title = @"Enquiry Management";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnReports:(id)sender{
    ProjectsViewController *objView = [[ProjectsViewController alloc]initWithNibName:@"ProjectsViewController" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:objView animated:YES];
}

-(IBAction)btnDialFollowUp:(id)sender{
    EnquiryDialFollowUpViewController *objView = [[EnquiryDialFollowUpViewController alloc]initWithNibName:@"EnquiryDialFollowUpViewController" bundle:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:objView animated:YES];
}


@end
