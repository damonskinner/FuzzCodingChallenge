//
//  DCSFuzzTextLabel.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 5/8/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzTextLabel.h"

@implementation DCSFuzzTextLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
    
    [super layoutSubviews];
}


@end
