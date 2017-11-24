//
//  BuildingListViewController.m
//  BuildAuto
//
//  Created by Panacea on 8/9/15.
//  Copyright (c) 2015 BuildAuto. All rights reserved.
//

#import "BuildingListViewController.h"
#import "BuildingTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GGFullscreenImageViewController.h"
#import "HCYoutubeParser.h"


@interface BuildingListViewController (){
    NSMutableArray *arrFloorID;
    int tblheight;
}
@end

@implementation BuildingListViewController
@synthesize tblView,scrollViewProject,arrayResults;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Availability Chart";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    arrFloorID = [[NSMutableArray alloc]init];
    
    tblheight = 0;
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    HUD.labelText = NSLocalizedString(@"Loading..",nil);
    HUD.dimBackground = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    if ([arrayResults count]>0) {
        for (int i=0; i<[arrayResults count]; i++) {
            tblheight = tblheight + 93;
        }
    }
    
    tblView.frame = CGRectMake(0, 148, 320, tblheight+118);
    
    [scrollViewProject setContentSize:CGSizeMake(320, 300+tblheight)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 93;
    }else{
        return 93;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [arrayResults count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 118.0;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 118)];
    
    
    UILabel *lblBuilding = [[UILabel alloc] initWithFrame:CGRectMake(8, 3, 76, 23)];
    [lblBuilding setFont:[UIFont fontWithName:@"GillSans" size:15]];
    [lblBuilding setText:@"Building A"];
    lblBuilding.textColor = [UIColor blackColor];
    [view addSubview:lblBuilding];
    
    

        UILabel *lblTotalUnit = [[UILabel alloc] initWithFrame:CGRectMake(157, 3, 76, 23)];
        [lblTotalUnit setFont:[UIFont fontWithName:@"GillSans" size:15]];
        [lblTotalUnit setText:@"Total Unit :"];
        lblTotalUnit.textColor = [UIColor blackColor];
        [view addSubview:lblTotalUnit];
        
        
        UILabel *lblTotalUnitValue = [[UILabel alloc] initWithFrame:CGRectMake(227, 3, 90, 23)];
        [lblTotalUnitValue setFont:[UIFont fontWithName:@"GillSans" size:15]];
        [lblTotalUnitValue setText:@"0"];
        lblTotalUnitValue.textColor = [UIColor blackColor];
        [view addSubview:lblTotalUnitValue];
    
    
    
    UIButton *btnGallery = [[UIButton alloc] initWithFrame:CGRectMake(241, 88, 27, 31)];
    [btnGallery setBackgroundImage:[UIImage imageNamed:@"gallery_icon.png"] forState:UIControlStateNormal];
    [btnGallery addTarget:self action:@selector(btnProjectGalleryClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnGallery];
    
    
    UIButton *btnVideo = [[UIButton alloc] initWithFrame:CGRectMake(287, 91, 23, 23)];
    [btnVideo setBackgroundImage:[UIImage imageNamed:@"video_icon.png"] forState:UIControlStateNormal];
    [btnVideo addTarget:self action:@selector(btnProjectVideoClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnVideo];
    
    
    
    
    
    
        UILabel *lblVacantBox = [[UILabel alloc] initWithFrame:CGRectMake(8, 29, 24, 24)];
        [lblVacantBox setBackgroundColor:[UIColor colorWithRed:144.0f/255.0f green:192.0f/255.0f blue:109.0f/255.0f alpha:1.0f]];
        [view addSubview:lblVacantBox];
        
        UILabel *lblVacant = [[UILabel alloc] initWithFrame:CGRectMake(40, 29, 52, 23)];
        [lblVacant setFont:[UIFont fontWithName:@"GillSans" size:15]];
        [lblVacant setText:@"Vacant :"];
        lblVacant.textColor = [UIColor blackColor];
        [view addSubview:lblVacant];
        
        
        UILabel *lblVacantValue = [[UILabel alloc] initWithFrame:CGRectMake(91, 29, 61, 23)];
        [lblVacantValue setFont:[UIFont fontWithName:@"GillSans" size:15]];
        [lblVacantValue setText:@"0"];
        lblVacantValue.textColor = [UIColor blackColor];
        [view addSubview:lblVacantValue];
        
        
        
        
        
        UILabel *lblBookedBox = [[UILabel alloc] initWithFrame:CGRectMake(8, 60, 24, 24)];
        [lblBookedBox setBackgroundColor:[UIColor colorWithRed:214.0f/255.0f green:117.0f/255.0f blue:144.0f/255.0f alpha:1.0f]];
        [view addSubview:lblBookedBox];
        
        UILabel *lblBooked = [[UILabel alloc] initWithFrame:CGRectMake(40, 60, 60, 23)];
        [lblBooked setFont:[UIFont fontWithName:@"GillSans" size:15]];
        [lblBooked setText:@"Booked :"];
        lblBooked.textColor = [UIColor blackColor];
        [view addSubview:lblBooked];
        
        
        UILabel *lblBookedValue = [[UILabel alloc] initWithFrame:CGRectMake(98, 60, 54, 23)];
        [lblBookedValue setFont:[UIFont fontWithName:@"GillSans" size:15]];
        [lblBookedValue setText:@"0"];
        lblBookedValue.textColor = [UIColor blackColor];
        [view addSubview:lblBookedValue];
        
        
        
        
        
        UILabel *lblNotForSaleBox = [[UILabel alloc] initWithFrame:CGRectMake(8, 91, 24, 24)];
        [lblNotForSaleBox setBackgroundColor:[UIColor colorWithRed:130.0f/255.0f green:199.0f/255.0f blue:251.0f/255.0f alpha:1.0f]];
        [view addSubview:lblNotForSaleBox];
        
        UILabel *lblNotForSale = [[UILabel alloc] initWithFrame:CGRectMake(40, 91, 90, 23)];
        [lblNotForSale setFont:[UIFont fontWithName:@"GillSans" size:15]];
        [lblNotForSale setText:@"Not For Sale :"];
        lblNotForSale.textColor = [UIColor blackColor];
        [view addSubview:lblNotForSale];
        
        
        UILabel *lblNotForSaleValue = [[UILabel alloc] initWithFrame:CGRectMake(132, 91, 150, 23)];
        [lblNotForSaleValue setFont:[UIFont fontWithName:@"GillSans" size:15]];
        [lblNotForSaleValue setText:@"0"];
        lblNotForSaleValue.textColor = [UIColor blackColor];
        [view addSubview:lblNotForSaleValue];
        
        
        
        
        UILabel *lblHeldBox = [[UILabel alloc] initWithFrame:CGRectMake(160, 29, 24, 24)];
        [lblHeldBox setBackgroundColor:[UIColor colorWithRed:251.0f/255.0f green:204.0f/255.0f blue:114.0f/255.0f alpha:1.0f]];
        [view addSubview:lblHeldBox];
        
        
        UILabel *lblHeld = [[UILabel alloc] initWithFrame:CGRectMake(192, 29, 52, 23)];
        [lblHeld setFont:[UIFont fontWithName:@"GillSans" size:15]];
        [lblHeld setText:@"Held :"];
        lblHeld.textColor = [UIColor blackColor];
        [view addSubview:lblHeld];
        
        
        UILabel *lblHeldValue = [[UILabel alloc] initWithFrame:CGRectMake(246, 29, 69, 23)];
        [lblHeldValue setFont:[UIFont fontWithName:@"GillSans" size:15]];
        [lblHeldValue setText:@"0"];
        lblHeldValue.textColor = [UIColor blackColor];
        [view addSubview:lblHeldValue];
        
        
        
        
        
        UILabel *lblRefugeBox = [[UILabel alloc] initWithFrame:CGRectMake(160, 63, 24, 24)];
        [lblRefugeBox setBackgroundColor:[UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1.0f]];
        [view addSubview:lblRefugeBox];
        
        UILabel *lblRefuge = [[UILabel alloc] initWithFrame:CGRectMake(192, 63, 52, 23)];
        [lblRefuge setFont:[UIFont fontWithName:@"GillSans" size:15]];
        [lblRefuge setText:@"Refuge :"];
        lblRefuge.textColor = [UIColor blackColor];
        [view addSubview:lblRefuge];
        
        
        UILabel *lblRefugeValue = [[UILabel alloc] initWithFrame:CGRectMake(246, 63, 66, 23)];
        [lblRefugeValue setFont:[UIFont fontWithName:@"GillSans" size:15]];
        [lblRefugeValue setText:@"0"];
        lblRefugeValue.textColor = [UIColor blackColor];
        [view addSubview:lblRefugeValue];
        
        
        view.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:189.0f/255.0f blue:227.0f/255.0f alpha:1.0f];
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BuildingTableViewCell *cell=(BuildingTableViewCell *) [tblView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil)
    {
        
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"BuildingTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    NSString *strUnitNo = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:indexPath.row]valueForKey:@"UnitNo"]];
    NSString *strBHK = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:indexPath.row]valueForKey:@"BHK"]];
    NSString *strArea = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:indexPath.row]valueForKey:@"AreaBasic"]];
    
    
    NSString *strFloor = [NSString stringWithFormat:@"Floor %@",[[arrayResults objectAtIndex:indexPath.row]valueForKey:@"Floor"]];
    
    
    
    cell.lblUnitNo.text = strUnitNo;
    cell.lblBHK.text = strBHK;
    cell.lblArea.text = strArea;
    
    
    if(indexPath.row == 0){
        cell.lblFloorValue.text = strFloor;
        [arrFloorID addObject:[NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:indexPath.row]valueForKey:@"Floor"]]];
        cell.lblFloor.hidden = NO;
        cell.btnGallery.hidden = NO;
         cell.btnPlayarrow.hidden = NO;
        cell.btnGallery.tag = indexPath.row;
        cell.btnVideo.hidden = NO;
        cell.btnVideo.tag = indexPath.row;
        [cell.btnVideo addTarget:self action:@selector(btnVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnGallery addTarget:self action:@selector(btnGalleryClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        NSString *strFloorValue = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:indexPath.row]valueForKey:@"Floor"]];
        if ([arrFloorID containsObject:strFloorValue]) {
            cell.lblFloor.hidden = YES;
            cell.btnGallery.hidden = YES;
            cell.btnVideo.hidden = YES;
            cell.btnPlayarrow.hidden = YES;
        }else{
            cell.lblFloorValue.text = strFloor;
            [arrFloorID addObject:[NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:indexPath.row]valueForKey:@"Floor"]]];
            cell.lblFloor.hidden = NO;
            cell.btnGallery.hidden = NO;
            cell.btnPlayarrow.hidden = NO;
            cell.btnGallery.tag = indexPath.row;
            cell.btnVideo.hidden = NO;
            cell.btnVideo.tag = indexPath.row;
            [cell.btnVideo addTarget:self action:@selector(btnVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnGallery addTarget:self action:@selector(btnGalleryClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
       
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)btnVideoClicked:(id)sender{
    NSLog(@"tag=%d",[sender tag]);
}

-(void)btnGalleryClicked:(id)sender{
    NSLog(@"tag=%d",[sender tag]);
}

-(void)btnProjectGalleryClicked{
    
    NSString *strProjectImagePath = [NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:0]valueForKey:@"BuildingVideoLink"]];
     if (strProjectImagePath) {
         NSURL *url = [NSURL URLWithString:@"http://www.wallpaper77.com/upload/DesktopWallpapers/cache/Purple-Sky-city-wallpaper-travel-wallpapers-building-wallpaper-320x320.jpg"];
        // NSData *data = [NSData dataWithContentsOfURL:url];
         
        
         GGFullscreenImageViewController *vc = [[GGFullscreenImageViewController alloc] init];
         //vc.liftedImageView = strProjectImagePath;
         //[vc.liftedImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"BuildAutoLogo_1.jpg"]];
         vc.url = url;
         [self presentViewController:vc animated:YES completion:nil];
         
     }else{
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No video link found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         [alert show];
     }

}

-(void)btnProjectVideoClicked{
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No video link found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(IBAction)btnBuildingVideoClicked:(id)sender{
    NSURL *urlVideo = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrayResults objectAtIndex:0]valueForKey:@"BuildingVideoLink"]]];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No video link found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}
@end
