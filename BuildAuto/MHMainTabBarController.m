/*
 * Copyright (c) 2011-2012 Matthijs Hollemans
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MHMainTabBarController.h"
#import "FloorwiseViewController.h"


#import <MediaPlayer/MediaPlayer.h>
#import "GGFullscreenImageViewController.h"
#import "HCYoutubeParser.h"

static const NSInteger TagOffset = 1000;

@implementation MHMainTabBarController
{
    UIView *tabButtonsContainerView;
    UIView *contentContainerView;
    UIImageView *indicatorImageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Availability Chart";
    
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.tabBarHeight);
    tabButtonsContainerView = [[UIView alloc] initWithFrame:rect];
    tabButtonsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  
    [self.view addSubview:tabButtonsContainerView];
    
    rect.origin.y = self.tabBarHeight;
    rect.size.height = self.view.bounds.size.height - self.tabBarHeight;
    contentContainerView = [[UIView alloc] initWithFrame:rect];
    contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:contentContainerView];
    
    //indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MHTabBarIndicator"]];
    indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 4)];
    indicatorImageView.backgroundColor=[UIColor colorWithRed:39.0f/255.0f green:171.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
   // [self.view addSubview:indicatorImageView];
    
    
    UIImageView *imgline = [[UIImageView alloc] initWithFrame:CGRectMake(0,120, 320, 2)];
    imgline.backgroundColor=[UIColor colorWithRed:39.0f/255.0f green:171.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    [self.view addSubview:imgline];
    

    [self reloadTabButtons];
    
    
    self.lblcntBooked.text = self.cntBooked;
    self.lblcntVacant.text = self.cntVacant;
    self.lblcntHeld.text = self.cntHeld;
    self.lblcntNotforSale.text = self.cntNotforSale;
    self.lblcntRefuge.text = self.cntRefuge;
    self.lblTotalUnit.text = self.strTotalUnit;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationController.navigationBar.hidden = NO;
}

- (void) viewDidLayoutSubviews {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        viewBounds.origin.y = topBarOffset * -1;
        self.view.bounds = viewBounds;
    }
   [self layoutTabButtons];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Only rotate if all child view controllers agree on the new orientation.
    for (UIViewController *viewController in self.viewControllers)
    {
        if (![viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation])
            return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        tabButtonsContainerView = nil;
        contentContainerView = nil;
        indicatorImageView = nil;
    }
}

- (void)reloadTabButtons
{
    [self removeTabButtons];
    [self addTabButtons];
    
    // Force redraw of the previously active tab.
    NSUInteger lastIndex = _selectedIndex;
    _selectedIndex = NSNotFound;
    self.selectedIndex = lastIndex;
}

- (void)addTabButtons
{
    NSUInteger index = 0;
    for (UIViewController *viewController in self.viewControllers)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.tag = TagOffset + index;
        UIOffset offset = viewController.tabBarItem.titlePositionAdjustment;
        button.titleEdgeInsets = UIEdgeInsetsMake(offset.vertical, offset.horizontal, 0.0f, 0.0f);
        button.imageEdgeInsets = viewController.tabBarItem.imageInsets;
        [button setTitle:viewController.tabBarItem.title forState:UIControlStateNormal];
        //[button setImage:viewController.tabBarItem.image forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
        [self deselectTabButton:button];
        [tabButtonsContainerView addSubview:button];
        
        ++index;
    }
}

- (void)removeTabButtons
{
    while ([tabButtonsContainerView.subviews count] > 0)
    {
        [[tabButtonsContainerView.subviews lastObject] removeFromSuperview];
    }
}

- (void)layoutTabButtons
{
    NSUInteger index = 0;
    NSUInteger count = [self.viewControllers count];
    
    CGRect rect = CGRectMake(0.0f, 85.0f, floorf(self.view.bounds.size.width / count), self.tabBarHeight-80);
    
    indicatorImageView.hidden = YES;
    
    NSArray *buttons = [tabButtonsContainerView subviews];
    for (UIButton *button in buttons)
    {
        if (index == count - 1)
            rect.size.width = self.view.bounds.size.width - rect.origin.x;
        
        button.frame = rect;
        rect.origin.x += rect.size.width;
        
        if (index == self.selectedIndex)
            [self centerIndicatorOnButton:button];
        
        ++index;
    }
}

- (void)centerIndicatorOnButton:(UIButton *)button
{
    CGRect rect = indicatorImageView.frame;
    rect.origin.x = button.center.x - floorf(indicatorImageView.frame.size.width/2.0f);
    rect.origin.y = self.tabBarHeight - indicatorImageView.frame.size.height;
    indicatorImageView.frame = rect;
    indicatorImageView.hidden = NO;
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
   // NSAssert([newViewControllers count] >= 2, @"MHMainTabBarController requires at least two view controllers");
    
    UIViewController *oldSelectedViewController = self.selectedViewController;
    
    // Remove the old child view controllers.
    for (UIViewController *viewController in _viewControllers)
    {
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
    }
    
    _viewControllers = [newViewControllers copy];
    
    // This follows the same rules as UITabBarController for trying to
    // re-select the previously selected view controller.
    NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
    if (newIndex != NSNotFound)
        _selectedIndex = newIndex;
    else if (newIndex < [_viewControllers count])
        _selectedIndex = newIndex;
    else
        _selectedIndex = 0;
    
    // Add the new child view controllers.
    for (UIViewController *viewController in _viewControllers)
    {
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
    
    if ([self isViewLoaded])
        [self reloadTabButtons];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
    [self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
    NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");
    
    if ([self.delegate respondsToSelector:@selector(mh_tabBarController1:shouldSelectViewController:atIndex:)])
    {
        UIViewController *toViewController = (self.viewControllers)[newSelectedIndex];
        if (![self.delegate mh_tabBarController1:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
            return;
    }
    
    if (![self isViewLoaded])
    {
        _selectedIndex = newSelectedIndex;
    }
    else if (_selectedIndex != newSelectedIndex)
    {
        UIViewController *fromViewController;
        UIViewController *toViewController;
        
        if (_selectedIndex != NSNotFound)
        {
            UIButton *fromButton = (UIButton *)[tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
            [self deselectTabButton:fromButton];
            fromViewController = self.selectedViewController;
        }
        
        NSUInteger oldSelectedIndex = _selectedIndex;
        _selectedIndex = newSelectedIndex;
        
        UIButton *toButton;
        if (_selectedIndex != NSNotFound)
        {
            toButton = (UIButton *)[tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
            [self selectTabButton:toButton];
            toViewController = self.selectedViewController;
        }
        
        if (toViewController == nil)  // don't animate
        {
            [fromViewController.view removeFromSuperview];
        }
        else if (fromViewController == nil)  // don't animate
        {
            toViewController.view.frame = contentContainerView.bounds;
            [contentContainerView addSubview:toViewController.view];
            [self centerIndicatorOnButton:toButton];
            
            if ([self.delegate respondsToSelector:@selector(mh_tabBarController1:didSelectViewController:atIndex:)])
                [self.delegate mh_tabBarController1:self didSelectViewController:toViewController atIndex:newSelectedIndex];
        }
        else if (animated)
        {
            CGRect rect = contentContainerView.bounds;
            if (oldSelectedIndex < newSelectedIndex)
                rect.origin.x = rect.size.width;
            else
                rect.origin.x = -rect.size.width;
            
            toViewController.view.frame = rect;
            tabButtonsContainerView.userInteractionEnabled = NO;
            
            [self transitionFromViewController:fromViewController
                              toViewController:toViewController
                                      duration:0.3f
                                       options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
                                    animations:^
             {
                 CGRect rect = fromViewController.view.frame;
                 if (oldSelectedIndex < newSelectedIndex)
                     rect.origin.x = -rect.size.width;
                 else
                     rect.origin.x = rect.size.width;
                 
                 fromViewController.view.frame = rect;
                 toViewController.view.frame = contentContainerView.bounds;
                 [self centerIndicatorOnButton:toButton];
             }
                                    completion:^(BOOL finished)
             {
                 tabButtonsContainerView.userInteractionEnabled = YES;
                 
                 if ([self.delegate respondsToSelector:@selector(mh_tabBarController1:didSelectViewController:atIndex:)])
                     [self.delegate mh_tabBarController1:self didSelectViewController:toViewController atIndex:newSelectedIndex];
             }];
        }
        else  // not animated
        {
            [fromViewController.view removeFromSuperview];
            
            toViewController.view.frame = contentContainerView.bounds;
            [contentContainerView addSubview:toViewController.view];
            [self centerIndicatorOnButton:toButton];
            
            if ([self.delegate respondsToSelector:@selector(mh_tabBarController1:didSelectViewController:atIndex:)])
                [self.delegate mh_tabBarController1:self didSelectViewController:toViewController atIndex:newSelectedIndex];
        }
    }
}

- (UIViewController *)selectedViewController
{
    if (self.selectedIndex != NSNotFound)
        return (self.viewControllers)[self.selectedIndex];
    else
        return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
    [self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated
{
    NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
    if (index != NSNotFound)
        [self setSelectedIndex:index animated:animated];
}
/*
-(IBAction)btnVideoLinkClicked:(id)sender{
    NSURL *urlVideo = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.strBuildingVideoLink]];
    if (urlVideo) {
        
        [HCYoutubeParser thumbnailForYoutubeURL:urlVideo thumbnailSize:YouTubeThumbnailDefaultHighQuality completeBlock:^(UIImage *image, NSError *error) {
            
            if (!error) {
                
                [HCYoutubeParser h264videosWithYoutubeURL:urlVideo completeBlock:^(NSDictionary *videoDictionary, NSError *error) {
                    
                    //_playButton.hidden = NO;
                    //_activityIndicator.hidden = YES;
                    
                    NSDictionary *qualities = videoDictionary;
                    
                    NSString *URLString = nil;
                    if ([qualities objectForKey:@"small"] != nil) {
                        URLString = [qualities objectForKey:@"small"];
                    }
                    else if ([qualities objectForKey:@"live"] != nil) {
                        URLString = [qualities objectForKey:@"live"];
                    }
                    else {
                        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't find youtube video" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
                        return;
                    }
                    NSURL *strurlToLoad = [NSURL URLWithString:URLString];
                    
                    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:strurlToLoad];
                    [self presentViewController:mp animated:YES completion:NULL];
                }];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No video uploaded." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }

}



-(IBAction)btnImageLinkClicked:(id)sender{
    NSString *strProjectImagePath = [NSString stringWithFormat:@"%@",self.strBuildingImageLink];
    if (strProjectImagePath) {
        NSURL *url = [NSURL URLWithString:strProjectImagePath];
        // NSData *data = [NSData dataWithContentsOfURL:url];
        
        
        
        GGFullscreenImageViewController *vc = [[GGFullscreenImageViewController alloc] init];
        //vc.liftedImageView = strProjectImagePath;
        //[vc.liftedImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"BuildAutoLogo_1.jpg"]];
        vc.url = url;
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No image uploaded." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}
*/
- (void)tabButtonPressed:(UIButton *)sender
{
    [self setSelectedIndex:sender.tag - TagOffset animated:YES];
}

#pragma mark - Change these methods to customize the look of the buttons

- (void)selectTabButton:(UIButton *)button
{
    [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    
     [button setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:69.0f/255.0f blue:127.0f/255.0f alpha:1.0f]];
}

- (void)deselectTabButton:(UIButton *)button
{
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   [button setBackgroundColor:[UIColor colorWithRed:40.0f/255.0f green:191.0f/255.0f blue:166.0f/255.0f alpha:1.0f]];
}

- (CGFloat)tabBarHeight
{
    return 120.0f;
}

@end
