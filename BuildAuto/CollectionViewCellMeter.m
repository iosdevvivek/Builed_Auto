//
//  CollectionViewCell.m
//  Meter
//
//  Created by Krishna on 10/10/15.
//  Copyright (c) 2015 Yarrana. All rights reserved.
//

#import "CollectionViewCellMeter.h"

@implementation CollectionViewCellMeter

//- (void)awakeFromNib {
    // Initialization code
//}

- (void)awakeFromNib {
    
    //self = [super initWithFrame:aRect];
    //{
        //  Needle //
        self.imgNeedle = [[UIImageView alloc]initWithFrame:CGRectMake(45.5,35.5, 11, 42)];
        
        self.imgNeedle.layer.anchorPoint = CGPointMake(self.imgNeedle.layer.anchorPoint.x, self.imgNeedle.layer.anchorPoint.y*2);
        self.imgNeedle.backgroundColor = [UIColor clearColor];
        self.imgNeedle.image = [UIImage imageNamed:@"arrow11.png"];
        [self addSubview:self.imgNeedle];
        
        
        // Needle Dot //
        self.meterImageViewDot = [[UIImageView alloc]initWithFrame:CGRectMake(40.5, 50.5, 22.5,22)];
        self.meterImageViewDot.image = [UIImage imageNamed:@"center_wheel.png"];
        [self addSubview:self.meterImageViewDot];
        
        
        // Speedometer Reading //
        self.tempReading = [[UILabel alloc] initWithFrame:CGRectMake(30.5, 85, 40, 20)];
        //self.speedometerReading = tempReading;
        
        self.tempReading.textAlignment = NSTextAlignmentCenter;
        self.tempReading.backgroundColor = [UIColor blackColor];
        
        //NSString *strPercentage = [NSString stringWithFormat:@"%2.0f%%",[[arrData valueForKey:@"Value"] floatValue]];
        self.tempReading.text= @"100%";
        self.tempReading.font = [UIFont fontWithName:@"Arial" size:12];
        self.tempReading.textColor = [UIColor whiteColor];
        [self addSubview:self.tempReading ];
    //}
    //return self;
}
@end
