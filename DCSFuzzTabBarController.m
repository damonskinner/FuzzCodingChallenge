//
//  DCSFuzzTabBarController.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzTabBarController.h"
#import "DCSFuzzdatastore.h"

#import "DCSFuzzImagesViewController.h"
#import "DCSFuzzAllDataViewController.h"
#import "DCSFuzzTextViewController.h"
#import <FAKFontAwesome.h>


@interface DCSFuzzTabBarController ()

@property (nonatomic, strong) DCSFuzzDatastore *datastore;

-(void)viewDidLoad;

- (DCSFuzzAllDataViewController *)makeAllDataVC;
- (DCSFuzzTextViewController *)makeTextVC;
- (DCSFuzzImagesViewController *)makeImagesVC;

- (void)didReceiveMemoryWarning;

@end


@implementation DCSFuzzTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DCSFuzzAllDataViewController *allDataTVC = [self makeAllDataVC];
    DCSFuzzTextViewController *textTVC = [self makeTextVC];
    DCSFuzzImagesViewController *imagesTVC = [self makeImagesVC];
    
    self.viewControllers = @[allDataTVC, textTVC, imagesTVC];
    
}

#pragma mark - MakeChildVCs

-(DCSFuzzAllDataViewController *) makeAllDataVC {
    DCSFuzzAllDataViewController *dataVC = [[DCSFuzzAllDataViewController alloc]init];
    
    UIImage *dataBarImage = [[FAKFontAwesome fileOIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
    dataVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"All Data" image:dataBarImage tag:1];
    
    return dataVC;
}

-(DCSFuzzTextViewController *) makeTextVC {
    DCSFuzzTextViewController *textVC = [[DCSFuzzTextViewController alloc]init];
    
    UIImage *textBarImage = [[FAKFontAwesome fileTextOIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
    textVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Text" image:textBarImage tag:2];
    
    return textVC;
}

-(DCSFuzzImagesViewController *) makeImagesVC {
    DCSFuzzImagesViewController *imagesVC = [[DCSFuzzImagesViewController alloc]init];
    UIImage *imageBarImage = [[FAKFontAwesome fileImageOIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
    imagesVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Images" image:imageBarImage tag:3];
    
    return imagesVC;
}


#pragma mark - Misc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
