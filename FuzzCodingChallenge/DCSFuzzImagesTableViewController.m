//
//  DCSFuzzImagesTableViewController.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzImagesTableViewController.h"
#import "DCSFuzzImageTableViewCell.h"
#import "DCSFuzzData.h"
#import "DCSFuzzImageViewController.h"

@interface DCSFuzzImagesTableViewController ()

@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation DCSFuzzImagesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datastore = [DCSFuzzDatastore sharedDataStore];
    self.imageArray = [[NSMutableArray alloc]init];

    [self.tableView registerNib:[UINib nibWithNibName:@"DCSFuzzImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"imageCell"];
    
    [self prepareTableViewForResizingCells];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(10.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    
    for (DCSFuzzData *eachData in self.datastore.fuzzDataArray) {
        if ([eachData.type isEqualToString:@"image"]) {
            [self.imageArray addObject:eachData];
        }
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareTableViewForResizingCells {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.0;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.imageArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCSFuzzImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
    
    if(cell==nil) {
        [tableView registerNib:[UINib nibWithNibName:@"DCSFuzzImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"imageCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
    }
    
    cell.fuzzImage.image = ((DCSFuzzData *)self.imageArray[indexPath.row]).fuzzImage;
    cell.fuzzImage.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
}


#pragma mark - Navigation

//originally used didSelectRowAtIndexPath 
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    DCSFuzzImageViewController *popUpImageVC = [[DCSFuzzImageViewController alloc] init];
    popUpImageVC.selectedImage =((DCSFuzzData *)self.imageArray[indexPath.row]).fuzzImage;
    [self presentViewController:popUpImageVC animated:YES completion:nil];
    
    return NO;
}

@end
