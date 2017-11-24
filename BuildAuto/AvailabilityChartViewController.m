//
//  AvailabilityChartViewController.m
//  BuildAuto
//
//  Created by Panacea on 8/27/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import "AvailabilityChartViewController.h"
#import "FloorwiseViewController.h"
#import "CarbonKit.h"


@interface AvailabilityChartViewController ()<CarbonTabSwipeDelegate>
{
    CarbonTabSwipeNavigation *tabSwipe;
}


@end

@implementation AvailabilityChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",[[self.arrayResults objectAtIndex:0] valueForKey:@"DisplayName"]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    NSArray *names = @[@"Building A", @"Building B"];
    
    ///UIColor *color = self.navigationController.navigationBar.barTintColor;
    
    UIColor *color = [UIColor colorWithRed:40.0f/255.0f green:191.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
    tabSwipe = [[CarbonTabSwipeNavigation alloc] createWithRootViewController:self tabNames:names tintColor:color delegate:self];
    [tabSwipe setIndicatorHeight:3.f]; // default 3.f
    [tabSwipe addShadow];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[tabSwipe setTranslucent:NO]; // remove translucent
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   // [tabSwipe setTranslucent:YES]; // add translucent
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Carbon Tab Swipe Delegate
// required
- (UIViewController *)tabSwipeNavigation:(CarbonTabSwipeNavigation *)tabSwipe viewControllerAtIndex:(NSUInteger)index {
    
    if (index == 0) {
        FloorwiseViewController *objView = [[FloorwiseViewController alloc]initWithNibName:@"FloorwiseViewController" bundle:nil];
        objView.arrayResults = self.arrayResults;
        return objView;
    }else {
        FloorwiseViewController *objView = [[FloorwiseViewController alloc]initWithNibName:@"FloorwiseViewController" bundle:nil];
        objView.arrayResults = self.arrayResults;
        return objView;
    }
}

// optional
- (void)tabSwipeNavigation:(CarbonTabSwipeNavigation *)tabSwipe didMoveAtIndex:(NSInteger)index {
    NSLog(@"Current tab: %d", (int)index);
}




@end
