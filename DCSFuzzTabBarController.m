//
//  DCSFuzzTabBarController.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzTabBarController.h"

#import "DCSFuzzImagesTableViewController.h"
#import "DCSFuzzAllDataTableViewController.h"
#import "DCSFuzzTextTableViewController.h"
#import <FAKFontAwesome.h>


@interface DCSFuzzTabBarController ()

@end

@implementation DCSFuzzTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DCSFuzzAllDataTableViewController *allDataTVC = [self makeAllDataVC];
    DCSFuzzTextTableViewController *textTVC = [self makeTextVC];
    DCSFuzzImagesTableViewController *imagesTVC = [self makeImagesVC];
    
    self.viewControllers = @[allDataTVC, textTVC, imagesTVC];
    
    

}


-(DCSFuzzAllDataTableViewController *) makeAllDataVC {
    DCSFuzzAllDataTableViewController *dataVC = [[DCSFuzzAllDataTableViewController alloc]init];
    
    UIImage *dataBarImage = [[FAKFontAwesome fileOIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
    dataVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"All Data" image:dataBarImage tag:1];
    
    return dataVC;
}

-(DCSFuzzTextTableViewController *) makeTextVC {
    DCSFuzzTextTableViewController *textVC = [[DCSFuzzTextTableViewController alloc]init];
    
    UIImage *textBarImage = [[FAKFontAwesome fileTextOIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
    textVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Text" image:textBarImage tag:1];
    
    return textVC;
}

-(DCSFuzzImagesTableViewController *) makeImagesVC {
    DCSFuzzImagesTableViewController *imagesVC = [[DCSFuzzImagesTableViewController alloc]init];
    UIImage *imageBarImage = [[FAKFontAwesome fileImageOIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
    imagesVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Images" image:imageBarImage tag:1];
    
    return imagesVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
