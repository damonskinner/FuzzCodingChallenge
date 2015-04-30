//
//  DCSFuzzImagesTableViewController.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzImagesViewController.h"
#import "DCSFuzzImageTableViewCell.h"
#import "DCSFuzzData.h"
#import "DCSFuzzPopupImageViewController.h"

@interface DCSFuzzImagesViewController ()

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation DCSFuzzImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datastore = [DCSFuzzDatastore sharedDataStore];
    self.imageArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];

    [self prepareTableViewForResizingCells];
    
    for (DCSFuzzData *eachData in self.datastore.fuzzDataArray) {
        if ([eachData.type isEqualToString:@"image"]) {
            [self.imageArray addObject:eachData];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"reloadTheTable" object:nil];
    
    [self.myTableView reloadData];
}

-(void) setupTableView {
    self.myTableView = [[UITableView alloc]init];
    [self.view addSubview:self.myTableView];
    
    [self.view removeConstraints:self.view.constraints];
    [self.myTableView removeConstraints:self.myTableView.constraints];
    self.myTableView.translatesAutoresizingMaskIntoConstraints=NO;
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource=self;
    
    NSDictionary *views = @{@"view":self.view,@"tableView":self.myTableView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[tableView]-50-|" options:0 metrics:nil views:views]];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"DCSFuzzImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"imageCell"];
}


- (void)reloadTable:(NSNotification *)notification {
    [self.myTableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareTableViewForResizingCells {
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 50.0;
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
    cell.dateLabel.text = ((DCSFuzzData *)self.imageArray[indexPath.row]).date;
    
    cell.delegate = self;
    
    
    return cell;
}


#pragma mark - Navigation

//originally used didSelectRowAtIndexPath 
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    DCSFuzzPopupImageViewController *popUpImageVC = [[DCSFuzzPopupImageViewController alloc] init];
    popUpImageVC.selectedImage =((DCSFuzzData *)self.imageArray[indexPath.row]).fuzzImage;
    [self presentViewController:popUpImageVC animated:YES completion:nil];
    
    return NO;
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
