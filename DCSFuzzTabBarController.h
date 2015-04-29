//
//  DCSFuzzTabBarController.h
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCSFuzzDatastore.h"

@interface DCSFuzzTabBarController : UITabBarController

@property (nonatomic, strong) DCSFuzzDatastore *datastore;

@end
