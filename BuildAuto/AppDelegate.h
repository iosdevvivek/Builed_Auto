//
//  AppDelegate.h
//  BuildAuto
//
//  Created by Panacea on 7/8/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@class EnquiryDetailsVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginViewController *LoginView;
@property (nonatomic, retain) UINavigationController *navigationController;


@property (strong, nonatomic) EnquiryDetailsVC *EnquiryDetails;

@end

