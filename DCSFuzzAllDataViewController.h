//
//  DCSFuzzAllDataTableViewController.h
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCSFuzzDatastore.h"
#import "DCSFuzzTextCell.h"
#import "DCSFuzzImageTableViewCell.h"

@interface DCSFuzzAllDataViewController : UIViewController <DCSFuzzTextCellDelegate, DCSFuzzImageCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DCSFuzzDatastore *datastore;


@end
