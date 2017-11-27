//
//  AppDelegate.m
//  BuildAuto
//
//  Created by Panacea on 7/8/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "EnquiryDetailsVC.h"

#import "JWSlideMenuController.h"
#import "JWNavigationController.h"

#import "SHSidebarController.h"
#import "HomeViewController.h"
#import "CustomerManagementViewController.h"
#import "EnquiryManagementViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize LoginView,navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
     
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.0f/255.0f green:69.0f/255.0f blue:127.0f/255.0f alpha:1.0f]];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:69.0f/255.0f blue:127.0f/255.0f alpha:1.0f]];
    
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    shadow.shadowColor = [UIColor darkGrayColor];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"GillSans" size:20.0f],
                                                            NSShadowAttributeName: shadow
                                                            }];
   
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *loginStatus=[defaults objectForKey:@"status"];

    if([loginStatus isEqualToString:@"login"])
    {
        
        
        NSMutableArray *vcs = [NSMutableArray array];
        
        
        
        HomeViewController *objViewHome = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        
        //Navigation Controller is required
        UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:objViewHome];
        
        
        //Dictionary of the view and title
        NSDictionary *viewHome = [NSDictionary dictionaryWithObjectsAndKeys:navHome, @"vc", @"Home", @"title", nil];
        
        //And we finally add it to the array
        [vcs addObject:viewHome];
        
        
        EnquiryManagementViewController *objView = [[EnquiryManagementViewController alloc]initWithNibName:@"EnquiryManagementViewController" bundle:nil];
        
        //Navigation Controller is required
        UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:objView];
        
        
        //Dictionary of the view and title
        NSDictionary *view = [NSDictionary dictionaryWithObjectsAndKeys:nav1, @"vc", @"Enquiry Management", @"title", nil];
        
        //And we finally add it to the array
        [vcs addObject:view];

        
        CustomerManagementViewController *objViewCust = [[CustomerManagementViewController alloc]initWithNibName:@"CustomerManagementViewController" bundle:nil];
        
        //Navigation Controller is required
        UINavigationController *navCust = [[UINavigationController alloc] initWithRootViewController:objViewCust];
        
        
        //Dictionary of the view and title
        NSDictionary *viewCust = [NSDictionary dictionaryWithObjectsAndKeys:navCust, @"vc", @"Customer Management", @"title", nil];
        
        //And we finally add it to the array
        [vcs addObject:viewCust];
        
        
        
        //Create controller and set views
        SHSidebarController *sidebar = [[SHSidebarController alloc] initWithArrayOfVC:vcs];
        
        
        
        self.window.rootViewController = sidebar;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
    }else{
        
        
        
        _EnquiryDetails = [[EnquiryDetailsVC alloc]initWithNibName:@"EnquiryDetailsVC" bundle:nil];
        navigationController = [[UINavigationController alloc]initWithRootViewController:_EnquiryDetails];
        self.window.rootViewController = self.navigationController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
       /*
        LoginView = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        navigationController = [[UINavigationController alloc]initWithRootViewController:LoginView];
        self.window.rootViewController = self.navigationController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
        */
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
