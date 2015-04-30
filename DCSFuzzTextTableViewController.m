//
//  DCSFuzzTextTableViewController.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzTextTableViewController.h"
#import "DCSFuzzTextCell.h"
#import "DCSFuzzData.h"
#import "DCSFuzzWebViewController.h"


@interface DCSFuzzTextTableViewController ()

@property (nonatomic, strong) NSMutableArray *textArray;

@end

@implementation DCSFuzzTextTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datastore = [DCSFuzzDatastore sharedDataStore];
    self.textArray = [[NSMutableArray alloc]init];

    [self.tableView registerNib:[UINib nibWithNibName:@"DCSFuzzTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];

    [self prepareTableViewForResizingCells];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(10.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    
    for (DCSFuzzData *eachData in self.datastore.fuzzDataArray) {
        if ([eachData.type isEqualToString:@"text"]) {
            [self.textArray addObject:eachData];
        }
    }
    [self.tableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.textArray count];
}

- (void)prepareTableViewForResizingCells {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCSFuzzTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
    
    cell.fuzzText.text = ((DCSFuzzData *)self.textArray[indexPath.row]).data;

    cell.fuzzText.numberOfLines=0;
    cell.fuzzText.lineBreakMode= NSLineBreakByWordWrapping;
    
    return cell;
}


#pragma mark - Navigation
//originally used didSelectRowAtIndexPath
 - (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
     DCSFuzzWebViewController *webViewVC = [[DCSFuzzWebViewController alloc]init];
     webViewVC.webViewURLString = @"https://fuzzproductions.com/";
     [self presentViewController:webViewVC animated:YES completion:nil];
 
     return YES;
 }

@end
