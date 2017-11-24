//
//  ReportsViewController.m
//  BuildAuto
//
//  Created by Panacea on 8/27/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import "ReportsViewController.h"

@interface ReportsViewController ()

@end

@implementation ReportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

     self.navigationItem.title = @"Chart";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
