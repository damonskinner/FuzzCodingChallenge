//
//  DCSFuzzAllDataTableViewController.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzAllDataViewController.h"
#import "DCSFuzzData.h"
#import <AFNetworking.h>
#import "DCSFuzzPopupImageViewController.h"
#import "DCSFuzzWebViewController.h"


@interface DCSFuzzAllDataViewController ()

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation DCSFuzzAllDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datastore = [DCSFuzzDatastore sharedDataStore];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
    
    [self prepareTableViewForResizingCells];
    
   
    [self.datastore populateDatastoreWithCompletionBlock:^(BOOL success, NSError *error){
        
        if (success) {
            [self.myTableView reloadData];
            
            [self.datastore downloadImagesWithCompletionBlock:^(NSInteger j) {
                NSIndexPath *ip = [NSIndexPath indexPathForRow:j inSection:0];
                [self.myTableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
            }];
        } else {
            UIAlertController *errorAlert = [self makeErrorAlertWithError:error];
            
            [self presentViewController:errorAlert animated:YES completion:nil];
        }
        
    }];
    
}

-(void) setupTableView {
    self.myTableView = [[UITableView alloc]init];
    [self.view addSubview:self.myTableView];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource=self;
    
    [self.view removeConstraints:self.view.constraints];
    [self.myTableView removeConstraints:self.myTableView.constraints];
    self.myTableView.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"DCSFuzzTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    
    NSDictionary *views = @{@"view":self.view,@"tableView":self.myTableView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[tableView]-50-|" options:0 metrics:nil views:views]];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"DCSFuzzTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"DCSFuzzImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"imageCell"];
}

- (void)prepareTableViewForResizingCells {
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 50.0;
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
    return [self.datastore.fuzzDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).type isEqualToString:@"image"]) {
        DCSFuzzImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
        
        if(cell==nil) {
            [tableView registerNib:[UINib nibWithNibName:@"DCSFuzzImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"imageCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        }
        
        cell.fuzzImage.image = ((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).fuzzImage;
        cell.fuzzImage.contentMode = UIViewContentModeScaleAspectFit;
        cell.dateLabel.text = ((DCSFuzzData *) self.datastore.fuzzDataArray[indexPath.row]).date;
        cell.delegate = self;

        return cell;
    } else if ([((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).type isEqualToString:@"text"]){
        DCSFuzzTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        
        cell.fuzzText.text = ((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).data;
        cell.dateLabel.text = ((DCSFuzzData *) self.datastore.fuzzDataArray[indexPath.row]).date;
        
        cell.fuzzText.numberOfLines=0;
        cell.fuzzText.lineBreakMode= NSLineBreakByWordWrapping;
        cell.delegate = self;
        return cell;
    } else {
        DCSFuzzTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        cell.fuzzText.text=((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).data;
        cell.delegate =self;
        return cell;
    }
}


#pragma mark - Navigation
//originally used didSelectRowAtIndexPath 
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).type isEqualToString:@"image"]) {
        DCSFuzzPopupImageViewController *popUpImageVC = [[DCSFuzzPopupImageViewController alloc] init];
        popUpImageVC.selectedImage =((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).fuzzImage;
        [self presentViewController:popUpImageVC animated:YES completion:nil];
        return NO;
    } else if ([((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).type isEqualToString:@"text"]) {
        DCSFuzzWebViewController *webViewVC = [[DCSFuzzWebViewController alloc]init];
        webViewVC.webViewURLString = @"https://fuzzproductions.com/";
        [self presentViewController:webViewVC animated:YES completion:nil];
        return YES;
    }
    
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

-(UIAlertController *) makeErrorAlertWithError: (NSError *) error {
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"No Connection"
                                                                        message:[NSString stringWithFormat:@"%@",error.localizedDescription]
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler: ^(UIAlertAction *action) {
                                                              
                                                          }];
    [errorAlert addAction:defaultAction];
    
    return errorAlert;
}

@end
