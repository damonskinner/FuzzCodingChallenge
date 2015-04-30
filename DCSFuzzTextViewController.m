//
//  DCSFuzzTextTableViewController.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzTextViewController.h"
#import "DCSFuzzData.h"
#import "DCSFuzzWebViewController.h"


@interface DCSFuzzTextViewController ()

@property (nonatomic, strong) NSMutableArray *textArray;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation DCSFuzzTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datastore = [DCSFuzzDatastore sharedDataStore];
    self.textArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];

    [self prepareTableViewForResizingCells];
    
    for (DCSFuzzData *eachData in self.datastore.fuzzDataArray) {
        if ([eachData.type isEqualToString:@"text"]) {
            [self.textArray addObject:eachData];
        }
    }
    [self.myTableView reloadData];
}

-(void) setupTableView {
    self.myTableView = [[UITableView alloc]init];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource=self;
    
    [self.view addSubview:self.myTableView];
    
    [self.view removeConstraints:self.view.constraints];
    [self.myTableView removeConstraints:self.myTableView.constraints];
    self.myTableView.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"DCSFuzzTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    
    NSDictionary *views = @{@"view":self.view,@"tableView":self.myTableView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[tableView]-50-|" options:0 metrics:nil views:views]];
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
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 50.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCSFuzzTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
    
    cell.fuzzText.text = ((DCSFuzzData *)self.textArray[indexPath.row]).data;

    cell.fuzzText.numberOfLines=0;
    cell.fuzzText.lineBreakMode= NSLineBreakByWordWrapping;
    cell.dateLabel.text=((DCSFuzzData *)self.textArray[indexPath.row]).date;
    cell.delegate = self;
    
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

-(void) idButtonWasTappedForIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *idAlert = [self makeIDAlertControllerWithIndexPath:indexPath];
    [self presentViewController:idAlert animated:YES completion:nil];
    
}

-(UIAlertController *) makeIDAlertControllerWithIndexPath:(NSIndexPath *) indexPath {
    UIAlertController *idAlert = [UIAlertController alertControllerWithTitle:@"Data ID:"
                                                                     message:[NSString stringWithFormat:@"The ID of this data entry is: %@",((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).dataId]
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler: ^(UIAlertAction *action) {
                                                              
                                                          }];
    [idAlert addAction:defaultAction];
    return idAlert;
}


@end
