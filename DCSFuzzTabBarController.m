//
//  DCSFuzzTabBarController.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzTabBarController.h"
#import "DCSFuzzData.h"
#import "DCSFuzzImagesTableViewController.h"
#import "DCSFuzzAllDataTableViewController.h"
#import "DCSFuzzTextTableViewController.h"


@interface DCSFuzzTabBarController ()

@end

@implementation DCSFuzzTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    self.datastore = [DCSFuzzDatastore sharedDataStore];
    [self.datastore populateDatastoreWithCompletionBlock:^{
       
    }];
    
    // Do any additional setup after loading the view.
}


-(void) makeAllDataVC {
    
}

-(void) makeTextVC {
    
}

-(void) makeImagesVC {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
