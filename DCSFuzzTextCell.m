//
//  DCSFuzzTextCell.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzTextCell.h"

@implementation DCSFuzzTextCell

- (void)awakeFromNib {
    // Initialization code
    
    
    [self.contentView removeConstraints:self.contentView.constraints];
    [self.textLabel removeConstraints:self.textLabel.constraints];
    
    self.textLabel.translatesAutoresizingMaskIntoConstraints=NO;
    
    NSLayoutConstraint *textLabelLeft = [NSLayoutConstraint
                                         constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                         attribute:NSLayoutAttributeLeftMargin
                                         multiplier:1.0
                                         constant:0];
    
    [self.contentView addConstraint:textLabelLeft];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
