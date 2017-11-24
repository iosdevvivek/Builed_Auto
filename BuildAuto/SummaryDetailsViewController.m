//
//  SummaryDetailsViewController.m
//  BuildAuto
//
//  Created by Chetan Anarthe on 26/03/17.
//  Copyright © 2017 BuildAuto. All rights reserved.
//

#import "SummaryDetailsViewController.h"

@interface SummaryDetailsViewController ()

@end

@implementation SummaryDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
      self.navigationItem.title = @"Summary Details";
    
    self.summaryView.layer.cornerRadius = 10.0f;
    self.summaryView.layer.borderWidth = 1.0f;
    self.summaryView.layer.borderColor = [UIColor blackColor].CGColor;
    self.summaryView.clipsToBounds = YES;
    
    [self loadUIData];

}

- (void) loadUIData {
    
    self.lblCustName.text = [NSString stringWithFormat:@"%@ - (%@)",[self.dictDetails objectForKey:@"Name"],[self.dictDetails objectForKey:@"UnitNoDesc"]];;
    
    self.lblAgrmtCost.text = [NSString stringWithFormat:@"%.2f",[[self.dictDetails objectForKey:@"AgreementCost"] doubleValue]];;
    self.lblDueAgrmtCost.text = [NSString stringWithFormat:@"%.2f",[[self.dictDetails objectForKey:@"DueOfAgreemetCost"] doubleValue]];
    self.lblDuePerAgrmtCost.text = [NSString stringWithFormat:@"%.2f",[[self.dictDetails objectForKey:@"DuePecentOfAgreemetCost"] doubleValue]];
    self.lblRecAgaistDue.text = [NSString stringWithFormat:@"%.2f",[[self.dictDetails objectForKey:@"RecivedAgainstDueOfAgreemetCost"] doubleValue]];
    self.lblBalAgaistDue.text = [NSString stringWithFormat:@"%.2f",[[self.dictDetails objectForKey:@"BalnceAgainstDueOfAgreemetCost"] doubleValue]];
    self.lblTotalOtherCharges.text = [NSString stringWithFormat:@"%.2f",[[self.dictDetails objectForKey:@"OtherChargesTotal"] doubleValue]];
    self.lblDueOtherCharges.text = [NSString stringWithFormat:@"%.2f",[[self.dictDetails objectForKey:@"DueOfOtherChargesTotal"] doubleValue]];
    self.lblRecOtherCharges.text = [NSString stringWithFormat:@"%.2f",[[self.dictDetails objectForKey:@"RecivedAgainstDueOfOtherChargesTotal"] doubleValue]];
    self.lblBalOtherCharges.text = [NSString stringWithFormat:@"%.2f",[[self.dictDetails objectForKey:@"BalnceAgainstDueOfOtherChargesTotal"] doubleValue]];
    
    self.lblBuildingProjectName.text = [NSString stringWithFormat:@"%@ - %@", [self.dictDetails objectForKey:@"ProjectDesc"],[self.dictDetails objectForKey:@"BuildingDesc"]];
    self.lblMobile.text = [NSString stringWithFormat:@"%@",[self.dictDetails objectForKey:@"MobileNo"]];
    
    double totalBalance = [[self.dictDetails objectForKey:@"BalnceAgainstDueOfAgreemetCost"] doubleValue] + [[self.dictDetails objectForKey:@"BalnceAgainstDueOfOtherChargesTotal"] doubleValue];
    self.lblTotalBalance.text = [NSString stringWithFormat:@"%.2f",totalBalance];
}

- (IBAction) callPhoneNumber:(id)sender {

    NSString *phNo = [self.dictDetails objectForKey:@"MobileNo"];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *Aalert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Call facility is not available to %@ on Simulator!!!", phNo] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [Aalert show];
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

@end
