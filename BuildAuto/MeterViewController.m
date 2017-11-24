//
//  MeterViewController.m
//  BuildAuto
//
//  Created by Apple on 26/10/15.
//  Copyright © 2015 BuildAuto. All rights reserved.
//

#import "MeterViewController.h"
#import "CollectionViewCellMeter.h"
#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface MeterViewController ()
{
    NSArray *arrDataRecords;
}

@end

@implementation MeterViewController

@synthesize needleImageView;
@synthesize speedometerCurrentValue;
@synthesize prevAngleFactor;
@synthesize angle;
@synthesize speedometer_Timer;
@synthesize speedometerReading;
@synthesize maxVal;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Sales Summary";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //Set Main Cell in Collection View
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCellMeter" bundle:nil] forCellWithReuseIdentifier:@"MyCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    HUD.labelText = NSLocalizedString(@"Loading..",nil);
    HUD.dimBackground = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [HUD showWhileExecuting:@selector(WebServiceGetGauageList) onTarget:self withObject:nil animated:YES];
    
}


-(void)WebServiceGetGauageList{

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *strSaasId=[defaults objectForKey:@"SAASID"];
    NSString *strLogInId=[defaults objectForKey:@"strSelectedCompanyID"];
    
    
    NSString *str_ComplrteUrl = [NSString stringWithFormat:@"http://166.62.81.20:8091/EnquiryManagement.svc/Web/OutStandingGaugeReportForDashboard"] ;
    
    NSMutableArray *globalArray = [[NSMutableArray alloc]init];
    
    //SaasId, LogInId, Password
   // NSString *strSaasId = @"DE001";
   // NSString *strLogInId = @"DE003";
    
    
    NSDictionary *dict1;
    dict1 = [NSDictionary dictionaryWithObjectsAndKeys:
             @"0", @"ProjectId",
             @"0", @"BuildingId",
             @"0",@"UnitId",
             @"true", @"WithInvestorFlag",
             nil];
    
    
   // NSLog(@"dict1=%@",dict1);
    
    
    NSDictionary *dict;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            strSaasId, @"SaasID",
            strLogInId, @"CompanyId",
            dict1, @"PrmOutStandingReportModelResponse",
            nil];
    [globalArray addObject:dict];
    
   // NSLog(@"globalArray=%@",globalArray);
    
    NSData *jsonData4 = [NSJSONSerialization dataWithJSONObject:globalArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strOrderDetails = [[NSString alloc] initWithData:jsonData4 encoding:NSUTF8StringEncoding];
    
    
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"[" withString:@""];
    strOrderDetails = [strOrderDetails stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
   // NSLog(@"strOrderDetails=%@",strOrderDetails);
    
    //web parsing method:
    BaseViewController *baseviewcontroller = [[BaseViewController alloc]init];
    NSDictionary *dictionary =  [baseviewcontroller WebParsingMethod:str_ComplrteUrl:strOrderDetails];
    
   // NSLog(@"dictionary=%@",dictionary);
    
    arrDataRecords = [dictionary valueForKey:@"OutStandingGaugeReportForDashboardResult"];
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [HUD hide:YES];
            if ([arrDataRecords count]>0) {
                [self.collectionView reloadData];
        }
    });

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark : Collection View Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [arrDataRecords count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(100, 150);
}

- (CollectionViewCellMeter *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCellMeter *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];


    NSArray *arrData = [arrDataRecords objectAtIndex:indexPath.row];
    
    
    NSString *strPercentage = [NSString stringWithFormat:@"%2.0f%%",[[arrData valueForKey:@"Value"] floatValue]];
    cell.tempReading.text= strPercentage;
    
    cell.lblText.text = [NSString stringWithFormat:@"%@",[arrData valueForKey:@"ExtraDescription"]];
    
    cell.TotalAmt.text = [NSString stringWithFormat:@"%@ %@",[arrData valueForKey:@"ExtraUnit"],[arrData valueForKey:@"ExtraValue"]];
    cell.TotalAmt.textColor = [UIColor redColor];
    
    // Set Max Value //
    self.maxVal = @"100";
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.01f];
    
    self.speedometerCurrentValue = [[arrData valueForKey:@"Value"] floatValue];
    
    self.angle = ((self.speedometerCurrentValue *237.4)/[self.maxVal floatValue])-118.4;
    
    [cell.imgNeedle setTransform: CGAffineTransformMakeRotation((M_PI / 180) *self.angle)];
    
    [UIView commitAnimations];

    return cell;
}
@end
