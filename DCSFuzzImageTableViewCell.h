//
//  DCSFuzzImageTableViewCell.h
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DCSFuzzImageCellDelegate <NSObject>

-(void) idButtonWasTappedForIndexPath: (NSIndexPath *) indexPath;

@end

@interface DCSFuzzImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *fuzzImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *idButtonLabel;

@property (nonatomic, strong) UITableView *parentTableView;

@property (nonatomic, strong) id <DCSFuzzImageCellDelegate> delegate;

- (IBAction)idButton:(id)sender;


@end
