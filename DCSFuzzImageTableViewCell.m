//
//  DCSFuzzImageTableViewCell.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzImageTableViewCell.h"

@implementation DCSFuzzImageTableViewCell


- (void)awakeFromNib {
    // Initialization code
    self.dateLabel.font = [UIFont fontWithName:@"Copperplate-Light" size:16];
    self.backgroundColor = [UIColor clearColor];
    
    self.fuzzImage.contentMode = UIViewContentModeScaleAspectFit;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UITableView *)parentTableView
{
    // get the superview
    id view = [self superview];
    
    // if the superview exists and is NOT a tableview, keep going up
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    
    // cast it
    UITableView *tableView = (UITableView *)view;
    
    return tableView;
}


- (IBAction)idButton:(id)sender {
    [self.delegate idButtonWasTappedForIndexPath:[self.parentTableView indexPathForCell:self]];
}
@end
