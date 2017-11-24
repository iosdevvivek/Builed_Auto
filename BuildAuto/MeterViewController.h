//
//  MeterViewController.h
//  BuildAuto
//
//  Created by Apple on 26/10/15.
//  Copyright © 2015 BuildAuto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MeterViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,MBProgressHUDDelegate>{
    
    UIImageView *needleImageView;
    float speedometerCurrentValue;
    float prevAngleFactor;
    float angle;
    NSTimer *speedometer_Timer;
    UILabel *speedometerReading;
    NSString *maxVal;
    MBProgressHUD *HUD;
    
}

@property(nonatomic,weak) IBOutlet UICollectionView *collectionView;


@property(nonatomic,retain) UIImageView *needleImageView;
@property(nonatomic,assign) float speedometerCurrentValue;
@property(nonatomic,assign) float prevAngleFactor;
@property(nonatomic,assign) float angle;
@property(nonatomic,retain) NSTimer *speedometer_Timer;
@property(nonatomic,retain) UILabel *speedometerReading;
@property(nonatomic,retain) NSString *maxVal;


@end
