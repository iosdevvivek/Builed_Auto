//
//  FloorwiseViewController.m
//  BuildAuto
//
//  Created by Panacea on 8/10/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import "FloorwiseViewController.h"
#import "CollectionViewCell.h"
#import "MONUniformFlowLayout.h"
#import "CollectionHeaderView.h"
#import "CollectionFooterView.h"

#import <MediaPlayer/MediaPlayer.h>
#import "GGFullscreenImageViewController.h"
#import "HCYoutubeParser.h"

static NSString *kCollectionViewCellIdentifier = @"kCollectionViewCellIdentifier";
static NSString *kCollectionViewSectionHeaderIdentifier = @"kCollectionViewSectionHeaderIdentifier";
static NSString *kCollectionViewSectionFooterIdentifier = @"kCollectionViewSectionFooterIdentifier";

@interface FloorwiseViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MONUniformFlowLayoutDelegate>{
    NSString *strFlagBooked, *strFlagHeld, *strFlagRefugee, *strFlagVacant, *strFlagNotForSale;
}

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) MONUniformFlowLayout *simpleLayout;

- (void)addVerticalConstraints:(NSArray **)verticalConstraints
         horizontalConstraints:(NSArray **)horizontalConstraints
                         views:(NSDictionary *)views
                       metrics:(NSDictionary *)metrics;

- (UIColor *)colorWithHexString:(NSString *)stringToConvert;


@end

@implementation FloorwiseViewController
@synthesize arrayResults,viewDetails,viewBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     self.navigationItem.title = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:0] valueForKey:@"DisplayName"]];
    
     self.navigationController.navigationBarHidden = NO;
    
    
    strFlagBooked = @"True";
    strFlagHeld = @"True";
    strFlagNotForSale = @"True";
    strFlagRefugee = @"True";
    strFlagVacant = @"True";
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 25, 25);
    [btn setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(FilterMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn1=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem=btn1;
    
    viewDetails.layer.cornerRadius = 5.0f;
    viewDetails.layer.masksToBounds = YES;
    viewDetails.hidden = YES;
    viewBackground.hidden = YES;
    
    
    self.viewFilters.hidden = YES;
    self.viewFilters.layer.cornerRadius = 5.0f;
    self.viewFilters.layer.masksToBounds = YES;
    
    arrFloorID = [[NSMutableArray alloc]init];
    arrMutFloorwiseResults = [[NSMutableArray alloc]init];
    
    if ([arrayResults count]>0) {
        for (int i=0; i<[arrayResults count]; i++) {
            
            NSString *strFloorValue = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:i]valueForKey:@"Floor"]];
            if ([arrFloorID containsObject:strFloorValue]) {
               
            }else{
                [arrFloorID addObject:strFloorValue];
            }
        }
    }
    
    NSLog(@"arrFloorID=%@",arrFloorID);
    NSArray *myArray = [arrFloorID sortedArrayUsingDescriptors:
                        @[[NSSortDescriptor sortDescriptorWithKey:@"intValue"
                                                        ascending:YES]]];
    arrFloorID = [myArray mutableCopy];
    
    if ([arrFloorID count]>0) {
        for (int i=0; i<[arrFloorID count]; i++) {
            
            NSString *strFloorValue = [NSString stringWithFormat:@"%@",[arrFloorID objectAtIndex:i]];
             NSMutableArray *arrFloorWise = [[NSMutableArray alloc]init];
            
             for (int j=0; j<[arrayResults count]; j++) {
                  NSString *strResultFloorID = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:j]valueForKey:@"Floor"]];
                  if ([strFloorValue isEqualToString:strResultFloorID]) {
                      [arrFloorWise addObject:[arrayResults objectAtIndex:j]];
                  }
              }
            
            NSDictionary *dict;
            dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    strFloorValue, @"strFloorID",
                    arrFloorWise, @"arrFloorwiseResults",
                    nil];
            [arrMutFloorwiseResults addObject:dict];
            
        }
    }

    NSLog(@"arrMutFloorwiseResults=%@",arrMutFloorwiseResults);
    
    
    
    int cntVacant;
    cntVacant = 0;
    
    int cntRefuge;
    cntRefuge = 0;
    
    int cntNotforSale;
    cntNotforSale = 0;
    
    int cntBooked;
    cntBooked = 0;
    
    
    int cntHeld;
    cntHeld = 0;
    
    
    self.lblBuilding.text = [NSString stringWithFormat:@"Building %@",[[arrayResults objectAtIndex:0] valueForKey:@"BuildingDescription"]];
    
    self.lblProjectName.text = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:0] valueForKey:@"DisplayName"]];

    
    if ([arrayResults count]>0) {
        for (int i=0; i<[arrayResults count]; i++) {
            ;
            
            NSString *strHoldFlag;
            NSString *strIsBookFlag;
            
            if ([[arrayResults objectAtIndex:i] valueForKey:@"Hold"] == nil || [[arrayResults objectAtIndex:i] valueForKey:@"Hold"] == (id)[NSNull null]) {
                strHoldFlag = @"False";
                
                
            }else{
                if ([[[arrayResults objectAtIndex:i] valueForKey:@"Hold"]boolValue] == true) {
                    strHoldFlag = @"True";
                }else{
                 strHoldFlag = @"False";
                }
            }
            
            
            if ([[arrayResults objectAtIndex:i] valueForKey:@"IsBookFlag"] == nil || [[arrayResults objectAtIndex:i] valueForKey:@"IsBookFlag"] == (id)[NSNull null]) {
                strIsBookFlag = @"False";
            }else{
                if ([[[arrayResults objectAtIndex:i] valueForKey:@"IsBookFlag"]boolValue] == true) {
                    strIsBookFlag = @"True";
                }else{
                    strIsBookFlag = @"False";
                }
                
            }

            
                if (![strHoldFlag isEqualToString:@"True"] && ![[[arrayResults objectAtIndex:i] valueForKey:@"NotForSaleUnit"] boolValue] == true && ![strIsBookFlag isEqualToString:@"True"] && ![[[arrayResults objectAtIndex:i] valueForKey:@"RefusedUnit"] boolValue] == true)
                {
                    NSLog(@"True");
                    cntVacant = cntVacant+1;
                }else{
                    NSLog(@"False");
                    //cntVacant = cntVacant+1;
                }
                
    
            
            if ([[[arrayResults objectAtIndex:i] valueForKey:@"RefusedUnit"] boolValue] == true) {
                cntRefuge = cntRefuge +1;
            }
            
            if ([[[arrayResults objectAtIndex:i] valueForKey:@"NotForSaleUnit"] boolValue] == true) {
                cntNotforSale = cntNotforSale+1;
            }
            
            if ([strIsBookFlag isEqualToString:@"True"]) {
                cntBooked = cntBooked+1;
            }
            
            
            if ([strHoldFlag isEqualToString:@"True"]) {
                cntHeld = cntHeld+1;
            }
        }
        
        
    }
    NSLog(@"cntVacant=%d",cntVacant);
    
    self.lblBuildingVacant.text = [NSString stringWithFormat:@"%d",cntVacant];
    self.lblBuildingTotalUnit.text = [NSString stringWithFormat:@"%d",[arrayResults count]];
    
    self.lblBuildingRefuge.text = [NSString stringWithFormat:@"%d",cntRefuge];
    
    self.lblBuildingNotforsale.text = [NSString stringWithFormat:@"%d",cntNotforSale];
    
    self.lblBuildingBooked.text = [NSString stringWithFormat:@"%d",cntBooked];
    
    self.lblBuildingHeld.text = [NSString stringWithFormat:@"%d",cntHeld];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
    [self.collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewSectionHeaderIdentifier];
    [self.collectionView registerClass:[CollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kCollectionViewSectionFooterIdentifier];
    
    self.collectionView.frame = CGRectMake(0, 93, 320, 290);
    
    [self.view addSubview:self.collectionView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Add Vertical and Horizontal Constraints

- (void)addVerticalConstraints:(NSArray *__autoreleasing *)verticalConstraints
         horizontalConstraints:(NSArray *__autoreleasing *)horizontalConstraints
                         views:(NSDictionary *)views
                       metrics:(NSDictionary *)metrics {
    NSMutableArray *v = [NSMutableArray new];
    NSMutableArray *h = [NSMutableArray new];
    
    [v addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|" options:0 metrics:metrics views:views]];
    
    [h addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:metrics views:views]];
    
    *verticalConstraints = v;
    *horizontalConstraints = h;
}

#pragma mark -
#pragma mark - Collection View

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 105, 320, 354) collectionViewLayout:self.simpleLayout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
       
       // NSDictionary *contentInset = [self.inputInfo objectForKey:@"content_inset"];
       // _collectionView.contentInset = UIEdgeInsetsMake([[contentInset objectForKey:@"top"] floatValue],
                                                       // [[contentInset objectForKey:@"left"] floatValue],
                                                       // [[contentInset objectForKey:@"bottom"] floatValue],
                                                       // [[contentInset objectForKey:@"right"] floatValue]);
        
        _collectionView.contentInset = UIEdgeInsetsMake(0,5,5,5);
    }
    return _collectionView;
}

- (MONUniformFlowLayout *)simpleLayout {
    if (!_simpleLayout) {
        _simpleLayout = [[MONUniformFlowLayout alloc] init];
       // NSDictionary *itemSpacingInfo = [self.inputInfo objectForKey:@"item_spacing"];
        _simpleLayout.interItemSpacing = MONInterItemSpacingMake(10,
                                                                 10);
        //_simpleLayout.enableStickyHeader = [[self.inputInfo objectForKey:@"sticky_header"] boolValue];
        _simpleLayout.enableStickyHeader = true;
    }
    return _simpleLayout;
}

#pragma mark -
#pragma mark - Collection View Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
   
    // NSArray *sections = [self.inputInfo objectForKey:@"sections"];
   // NSArray *sections = @[@"one",@"two",@"three"];
   // NSDictionary *sectionDetails = [sections objectAtIndex:indexPath.section];
    //cell.backgroundColor = [self colorWithHexString:[sectionDetails objectForKey:@"item_color"]];
    
    NSArray *arrData = [[arrMutFloorwiseResults objectAtIndex:indexPath.section] objectForKey:@"arrFloorwiseResults"];
    
    
    
    UIView *imgview = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 70, 70)];
    //imgview.image = [UIImage imageNamed:@"Box_Grey.png"];
    //imgview.contentMode = UIViewContentModeScaleToFill;
    imgview.layer.cornerRadius = 5.0f;
    imgview.layer.masksToBounds = YES;
    
    
    
    
    
    imgview.backgroundColor = [UIColor colorWithRed:130.0f/255.0f green:183.0f/255.0f blue:77.0f/255.0f alpha:1.0f];
    
    UIImageView *imgboxview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    imgboxview.image = [UIImage imageNamed:@"box3d.png"];
    imgboxview.contentMode = UIViewContentModeScaleToFill;
    imgboxview.backgroundColor = [UIColor clearColor];
    imgboxview.opaque = NO;
    imgboxview.alpha = 0.3;
    [imgview addSubview:imgboxview];

    
    //imgview.backgroundColor = [UIColor colorWithRed:40.0f/255.0f green:191.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
    
    NSString *strHoldFlag;
    NSString *strIsBookFlag;
    
    if ([[arrData objectAtIndex:indexPath.row] valueForKey:@"Hold"] == nil || [[arrData objectAtIndex:indexPath.row] valueForKey:@"Hold"] == (id)[NSNull null]) {
        strHoldFlag = @"False";
  
    }else{
        strHoldFlag = @"True";
    }
    
    
    
    if ([[arrData objectAtIndex:indexPath.row] valueForKey:@"IsBookFlag"] == nil || [[arrData objectAtIndex:indexPath.row] valueForKey:@"IsBookFlag"] == (id)[NSNull null]) {
        strIsBookFlag = @"False";
    }else{
        strIsBookFlag = @"True";
    }
    
    if ([[[arrData objectAtIndex:indexPath.row] valueForKey:@"RefusedUnit"] boolValue] == true) {
        imgview.backgroundColor = [UIColor colorWithRed:174.0f/255.0f green:174.0f/255.0f blue:174.0f/255.0f alpha:1.0f];
    }
    
    if ([[[arrData objectAtIndex:indexPath.row] valueForKey:@"NotForSaleUnit"] boolValue] == true) {
        imgview.backgroundColor = [UIColor colorWithRed:117.0f/255.0f green:184.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    }
    
    if ([strIsBookFlag isEqualToString:@"True"]) {
       imgview.backgroundColor = [UIColor colorWithRed:198.0f/255.0f green:94.0f/255.0f blue:127.0f/255.0f alpha:1.0f];
    }
    
    
    if ([strHoldFlag isEqualToString:@"True"]) {
       imgview.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:195.0f/255.0f blue:79.0f/255.0f alpha:1.0f];
    }
    
    
    
    
    
    //UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    //imgview.image = [UIImage imageNamed:@"Box_Grey.png"];
    //imgview.contentMode = UIViewContentModeScaleToFill;
    
    
    UILabel *lblUnitNo = [[UILabel alloc]initWithFrame:CGRectMake(4, 5, 60, 70)];
    lblUnitNo.text = [NSString stringWithFormat:@"Unit No %@",[[arrData objectAtIndex:indexPath.row]valueForKey:@"UnitNo"]];
    lblUnitNo.textColor = [UIColor blackColor];
    [lblUnitNo setFont:[UIFont fontWithName:@"GillSans" size:13]];
    lblUnitNo.backgroundColor = [UIColor clearColor];
    lblUnitNo.textAlignment = NSTextAlignmentCenter;
    lblUnitNo.numberOfLines = 0;
    [imgview addSubview:lblUnitNo];
    
    
    [cell addSubview:imgview];
    

    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(IBAction)btnclose:(id)sender{
    self.collectionView.userInteractionEnabled = YES;
    viewDetails.hidden = YES;
    viewBackground.hidden = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
     NSArray *arrData = [[arrMutFloorwiseResults objectAtIndex:indexPath.section] objectForKey:@"arrFloorwiseResults"];
    
    self.viewFilters.hidden = YES;
    
    self.collectionView.userInteractionEnabled = NO;
    viewDetails.hidden = NO;
    viewBackground.hidden = NO;
    viewDetails.layer.zPosition = 1;
    
    self.lblUnitNo.text = [NSString stringWithFormat:@"Unit No : %@",[[arrData objectAtIndex:indexPath.row]valueForKey:@"UnitNo"]];
    
    self.lblArea.text = [NSString stringWithFormat:@"Area : %@",[[arrData objectAtIndex:indexPath.row]valueForKey:@"AreaBasic"]];
    
    self.lblBhk.text = [NSString stringWithFormat:@"BHK : %@",[[arrData objectAtIndex:indexPath.row]valueForKey:@"BHK"]];


}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    //UICollectionReusableView *reusableView = nil;
    NSArray *arrData = [[arrMutFloorwiseResults objectAtIndex:indexPath.section] objectForKey:@"arrFloorwiseResults"];
    
    
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
       
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCollectionViewSectionHeaderIdentifier forIndexPath:indexPath];
        
        
         UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
         view.backgroundColor = [UIColor colorWithRed:40.0f/255.0f green:191.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
        
        //headerView.backgroundColor = [UIColor colorWithRed:38.0f/255.0f green:114.0f/255.0f blue:175.0f/255.0f alpha:1.0f];
        
        headerView.backgroundColor = [UIColor colorWithRed:40.0f/255.0f green:191.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
        
        UILabel *lblFloorNo = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 35)];
        lblFloorNo.text = [NSString stringWithFormat:@"Floor %@",[[arrData objectAtIndex:indexPath.row]valueForKey:@"Floor"]];
        lblFloorNo.textColor = [UIColor whiteColor];
        [lblFloorNo setFont:[UIFont fontWithName:@"GillSans" size:17]];
        lblFloorNo.backgroundColor = [UIColor clearColor];
        lblFloorNo.textAlignment = NSTextAlignmentLeft;
        lblFloorNo.numberOfLines = 0;
        [view addSubview:lblFloorNo];
       
        
        
        UIButton *btnGallery = [[UIButton alloc]initWithFrame:CGRectMake(280, 3, 30, 30)];
        [btnGallery setImage:[UIImage imageNamed:@"gallery_icon.png"] forState:UIControlStateNormal];
        btnGallery.tag = indexPath.row;
        [btnGallery addTarget:self action:@selector(ImageLinkMethod:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btnGallery];
        
        [headerView addSubview:view];
        
        
         return headerView;
        //reusableView = headerView;
    }else {
        CollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCollectionViewSectionFooterIdentifier forIndexPath:indexPath];
        //footerView.backgroundColor = [self colorWithHexString:[sectionDetails objectForKey:@"footer_color"]];
         footerView.backgroundColor = [UIColor greenColor];
        //reusableView = footerView;
        return footerView;
    }
   
}

-(void)ImageLinkMethod:(id)sender{
    NSString *strProjectImagePath = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:[sender tag]]valueForKey:@"ImageLink"]];
    if (strProjectImagePath) {
        NSURL *url = [NSURL URLWithString:strProjectImagePath];
        // NSData *data = [NSData dataWithContentsOfURL:url];
        
        GGFullscreenImageViewController *vc = [[GGFullscreenImageViewController alloc] init];
        vc.url = url;
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No image uploaded." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
   
    
    return [[[arrMutFloorwiseResults objectAtIndex:section] objectForKey:@"arrFloorwiseResults"] count];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //return [[self.inputInfo objectForKey:@"sections"] count];
    return [arrMutFloorwiseResults count];
}

#pragma mark -
#pragma mark - Get Number of Columns

- (NSUInteger)getNumberOfColumnsInSection:(NSInteger)section {
    UIDevice *device = [UIDevice currentDevice];
    //NSArray *sections = [self.inputInfo objectForKey:@"sections"];
   // NSDictionary *sectionDetails = [sections objectAtIndex:section];
    if (UIDeviceOrientationIsLandscape(device.orientation)) {
       // return [[sectionDetails objectForKey:@"landscape_number_of_columns"] floatValue];
        return 6;
    } else {
       // return [[sectionDetails objectForKey:@"portrait_number_of_columns"] floatValue];
        return 4;
    }
}

#pragma mark -
#pragma mark - Simple Flow Layout Delegate

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(MONUniformFlowLayout *)layout
      itemHeightInSection:(NSInteger)section {
   // NSArray *sections = [self.inputInfo objectForKey:@"sections"];
   // NSDictionary *sectionDetails = [sections objectAtIndex:section];
   // return [[sectionDetails objectForKey:@"item_height"] floatValue];
    return 75;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(MONUniformFlowLayout *)layout
    headerHeightInSection:(NSInteger)section {
   // NSArray *sections = [self.inputInfo objectForKey:@"sections"];
   // NSDictionary *sectionDetails = [sections objectAtIndex:section];
   // return [[sectionDetails objectForKey:@"header_height"] floatValue];
    return 35;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(MONUniformFlowLayout *)layout
    footerHeightInSection:(NSInteger)section {
   // NSArray *sections = [self.inputInfo objectForKey:@"sections"];
   // NSDictionary *sectionDetails = [sections objectAtIndex:section];
   // return [[sectionDetails objectForKey:@"footer_height"] floatValue];
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
  sectionSpacingForlayout:(MONUniformFlowLayout *)layout {
   // return [[self.inputInfo objectForKey:@"section_spacing"] floatValue];
    return 5;
}

- (NSUInteger)collectionView:(UICollectionView *)collectionView
                      layout:(MONUniformFlowLayout *)layout
    numberOfColumnsInSection:(NSInteger)section {
    return [self getNumberOfColumnsInSection:section];
}

#pragma mark -
#pragma mark - Convert Hext String to Color

- (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}


-(IBAction)btnBuildingGalleryClicked:(id)sender{
    
    NSString *strProjectImagePath = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:0]valueForKey:@"BuildingImageLink"]];
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


-(IBAction)btnProjectGalleryClicked:(id)sender{
    
    NSString *strProjectImagePath = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:0]valueForKey:@"ProjectImageLink"]];
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

-(IBAction)btnProjectVideoClicked:(id)sender{
    NSURL *urlVideo = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:0]valueForKey:@"ProjectVideoLink"]]];
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


-(void)FilterMethod{
    
   
}

-(IBAction)btnFilterSearch:(id)sender{
    self.viewFilters.hidden = YES;
    viewBackground.hidden = YES;
    self.collectionView.userInteractionEnabled = YES;
    
    arrMutFloorwiseResults = [[NSMutableArray alloc]init];
    if ([arrayResults count]>0) {
        for (int i=0; i<[arrayResults count]; i++) {
            
            NSString *strFloorValue = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:i]valueForKey:@"Floor"]];
            if ([arrFloorID containsObject:strFloorValue]) {
                
            }else{
                [arrFloorID addObject:strFloorValue];
            }
        }
    }
    
   // NSLog(@"arrFloorID=%@",arrFloorID);
    if ([arrFloorID count]>0) {
        for (int i=0; i<[arrFloorID count]; i++) {
            NSString *strFlagNOTSALE;
            NSString *strFlagVACANT;
            NSString *strFlagREFUGE;
            NSString *strFlagHELD;
            NSString *strFlagBOOKED;
        
            NSString *strFLAGMAIN;
            strFLAGMAIN = @"FALSE";
            
            NSString *strFloorValue = [NSString stringWithFormat:@"%@",[arrFloorID objectAtIndex:i]];
            
            NSMutableArray *arrFloorWise = [[NSMutableArray alloc]init];
            
            for (int j=0; j<[arrayResults count]; j++) {
                
                NSString *strResultFloorID = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:j]valueForKey:@"Floor"]];
                
                if ([strFloorValue isEqualToString:strResultFloorID]) {
                    
                    NSString *strHoldFlag;
                    NSString *strIsBookFlag;
                    
                    
                    if ([[arrayResults objectAtIndex:j] valueForKey:@"Hold"] == nil || [[arrayResults objectAtIndex:j] valueForKey:@"Hold"] == (id)[NSNull null]) {
                        strHoldFlag = @"False";
                        
                        
                    }else{
                        if ([[[arrayResults objectAtIndex:j] valueForKey:@"Hold"]boolValue] == true) {
                            strHoldFlag = @"True";
                        }else{
                            strHoldFlag = @"False";
                        }
                    }
                    
                    
                    if ([[arrayResults objectAtIndex:j] valueForKey:@"IsBookFlag"] == nil || [[arrayResults objectAtIndex:j] valueForKey:@"IsBookFlag"] == (id)[NSNull null]) {
                        strIsBookFlag = @"False";
                    }else{
                        if ([[[arrayResults objectAtIndex:j] valueForKey:@"IsBookFlag"]boolValue] == true) {
                            strIsBookFlag = @"True";
                        }else{
                            strIsBookFlag = @"False";
                        }
                        
                    }
                    
                    
                    
                    if ([strFlagVacant isEqualToString:@"False"]) {
                       
                        
                        NSString *strFlag;
                        
                        if ([[[arrayResults objectAtIndex:j] valueForKey:@"RefusedUnit"] boolValue] == true) {
                            strFlag = @"TRUE";
                        }
                        
                        if ([[[arrayResults objectAtIndex:j] valueForKey:@"NotForSaleUnit"] boolValue] == true) {
                            strFlag = @"TRUE";
                        }
                        
                        if ([strIsBookFlag isEqualToString:@"True"]) {
                            strFlag = @"TRUE";
                        }
                        
                        if ([strHoldFlag isEqualToString:@"True"]) {
                            strFlagHELD = @"TRUE";
                        }
                        
                        if ([strFlag isEqualToString:@"TRUE"]) {
                             strFlagVACANT = @"FALSE";
                        }else{
                            strFlagVACANT = @"TRUE";
                        }
                        
                        
                    }
                    
                    
                    if ([strFlagRefugee isEqualToString:@"False"]) {
                        if ([[[arrayResults objectAtIndex:j] valueForKey:@"RefusedUnit"] boolValue] == true) {
                            strFlagREFUGE = @"TRUE";
                        }
                    }
                    
                    
                    
                    if ([strFlagNotForSale isEqualToString:@"False"]) {
                        if ([[[arrayResults objectAtIndex:j] valueForKey:@"NotForSaleUnit"] boolValue] == true) {
                            strFlagNOTSALE = @"TRUE";
                        }
                    }
                    
                    
                    
                    if ([strFlagBooked isEqualToString:@"False"]) {
                        if ([strIsBookFlag isEqualToString:@"True"]) {
                            strFlagBOOKED = @"TRUE";
                        }
                    }
                    
                    
                    
                    if ([strFlagHeld isEqualToString:@"False"]) {
                        if ([strHoldFlag isEqualToString:@"True"]) {
                            strFlagHELD = @"TRUE";
                        }
                    }
                    
                    if ([strFlagVACANT isEqualToString:@"TRUE"] || [strFlagHELD isEqualToString:@"TRUE"] || [strFlagBOOKED isEqualToString:@"TRUE"] ||[strFlagNOTSALE isEqualToString:@"TRUE"] ||[strFlagREFUGE isEqualToString:@"TRUE"] ) {
                        
                    }else{
                        strFLAGMAIN = @"TRUE";
                        [arrFloorWise addObject:[arrayResults objectAtIndex:j]];
                    }
                    
                    
                }
                
            }
            
            
            
            if ([strFLAGMAIN isEqualToString:@"TRUE"]) {
                NSDictionary *dict;
                dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        strFloorValue, @"strFloorID",
                        arrFloorWise, @"arrFloorwiseResults",
                        nil];
                [arrMutFloorwiseResults addObject:dict];
            }
            
            
            
        }
        
    }
    
    //NSLog(@"arrMutFloorwiseResults=%@",arrMutFloorwiseResults);
    
    [self.collectionView reloadData];
    
}


-(IBAction)btnFilterClose:(id)sender{
    self.viewFilters.hidden = YES;
    viewBackground.hidden = YES;
    self.collectionView.userInteractionEnabled = YES;
}




-(IBAction)btnBooked:(id)sender{
    
    if ([strFlagBooked isEqualToString:@"True"]) {
        strFlagBooked = @"False";
        [self.btnBooked setBackgroundImage:[UIImage imageNamed:@"uncheckbox.png"] forState:UIControlStateNormal];
    }else{
        strFlagBooked = @"True";
        [self.btnBooked setBackgroundImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
    }
   
}
-(IBAction)btnHeld:(id)sender{
    if ([strFlagHeld isEqualToString:@"True"]) {
        strFlagHeld = @"False";
        [self.btnHeld setBackgroundImage:[UIImage imageNamed:@"uncheckbox.png"] forState:UIControlStateNormal];
    }else{
        strFlagHeld = @"True";
        [self.btnHeld setBackgroundImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
    }
}
-(IBAction)btnNotforsale:(id)sender{
    if ([strFlagNotForSale isEqualToString:@"True"]) {
        strFlagNotForSale = @"False";
        [self.btnNotForSale setBackgroundImage:[UIImage imageNamed:@"uncheckbox.png"] forState:UIControlStateNormal];
    }else{
        strFlagNotForSale = @"True";
        [self.btnNotForSale setBackgroundImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
    }
}
-(IBAction)btnRefuge:(id)sender{
    if ([strFlagRefugee isEqualToString:@"True"]) {
        strFlagRefugee = @"False";
        [self.btnRefuge setBackgroundImage:[UIImage imageNamed:@"uncheckbox.png"] forState:UIControlStateNormal];
    }else{
        strFlagRefugee = @"True";
        [self.btnRefuge setBackgroundImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
    }
}
-(IBAction)btnVacant:(id)sender{
    if ([strFlagVacant isEqualToString:@"True"]) {
        strFlagVacant = @"False";
        [self.btnVacant setBackgroundImage:[UIImage imageNamed:@"uncheckbox.png"] forState:UIControlStateNormal];
    }else{
        strFlagVacant = @"True";
        [self.btnVacant setBackgroundImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)btnFilterSettings:(id)sender{
    self.viewDetails.hidden = YES;
    self.collectionView.userInteractionEnabled = NO;
    
    viewBackground.hidden = NO;
    self.viewFilters.hidden = NO;
    self.viewFilters.layer.zPosition = 1;

}


@end
