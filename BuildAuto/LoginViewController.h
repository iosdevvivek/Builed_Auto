//
//  LoginViewController.h
//  BuildAuto
//
//  Created by Panacea on 7/8/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"
#import "MBProgressHUD.h"

@class TPKeyboardAvoidingScrollView;

@interface LoginViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,BSKeyboardControlsDelegate,MBProgressHUDDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    MBProgressHUD *HUD;
    UIView *actionSheet;
}


@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@property(nonatomic,strong) IBOutlet UIImageView *imgTextCompIDBg;
@property(nonatomic,strong) IBOutlet UIImageView *imgTextUsernameBg;
@property(nonatomic,strong) IBOutlet UIImageView *imgTextPasswordBg;
@property(nonatomic,strong) IBOutlet UIImageView *imgTextSelectUserBg;

@property(nonatomic,strong) IBOutlet UIButton *btnLogin;



@property(nonatomic,strong) IBOutlet UITextField *txtCompanyID;
@property(nonatomic,strong) IBOutlet UITextField *txtUsername;
@property(nonatomic,strong) IBOutlet UITextField *txtPassword;
@property(nonatomic,strong) IBOutlet UIButton *btnUserType;

@end
