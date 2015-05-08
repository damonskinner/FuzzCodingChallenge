//
//  DCSFuzzTextCell.h
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCSFuzzTextLabel.h"

@protocol DCSFuzzTextCellDelegate <NSObject>

-(void) idButtonWasTappedForIndexPath: (NSIndexPath *) indexPath;

@end


@interface DCSFuzzTextCell : UITableViewCell

@property (nonatomic, strong) UITableView *parentTableView;

@property (weak, nonatomic) IBOutlet DCSFuzzTextLabel *fuzzText;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *idButtonLabel;

@property (nonatomic, strong) id <DCSFuzzTextCellDelegate> delegate;




- (IBAction)idButton:(id)sender;


@end
