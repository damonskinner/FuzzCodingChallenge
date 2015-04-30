//
//  DCSFuzzAllDataTableViewController.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzAllDataTableViewController.h"
#import "DCSFuzzData.h"
#import <AFNetworking.h>
#import "DCSFuzzImageViewController.h"
#import "DCSFuzzWebViewController.h"


@interface DCSFuzzAllDataTableViewController ()

@end

@implementation DCSFuzzAllDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datastore = [DCSFuzzDatastore sharedDataStore];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(10.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DCSFuzzTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DCSFuzzImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"imageCell"];
    
    [self prepareTableViewForResizingCells];
    
    
    self.datastore = [DCSFuzzDatastore sharedDataStore];
    [self.datastore populateDatastoreWithCompletionBlock:^{
        [self.tableView reloadData];
        
        for (NSInteger i=0;i<[self.datastore.fuzzDataArray count];i++) {
            if ([((DCSFuzzData *)self.datastore.fuzzDataArray[i]).type isEqualToString:@"image"]) {
                NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
                [myQueue setMaxConcurrentOperationCount:10];
                NSURL *imageURL = [NSURL URLWithString:((DCSFuzzData *)self.datastore.fuzzDataArray[i]).data];
                
                NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL:imageURL];
                AFHTTPRequestOperation *imageDownload = [[AFHTTPRequestOperation alloc] initWithRequest:imageRequest];
                imageDownload.responseSerializer = [[AFImageResponseSerializer alloc] init];
                
                [imageDownload setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    ((DCSFuzzData *)self.datastore.fuzzDataArray[i]).fuzzImage=responseObject;
                    
                    NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];

                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Fail!");
                    ((DCSFuzzData *)self.datastore.fuzzDataArray[i]).fuzzImage=[UIImage imageNamed:@"no_image"];
                    
                }];
                
                [myQueue addOperation:imageDownload];
                
            }
        }
    }];
    
}

- (void)prepareTableViewForResizingCells {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.0;
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
        DCSFuzzImageViewController *popUpImageVC = [[DCSFuzzImageViewController alloc] init];
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
    UIAlertController *idAlert = [UIAlertController alertControllerWithTitle:@"Data ID:"
                                                                     message:[NSString stringWithFormat:@"The ID of this data entry is: %@",((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).dataId]
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler: ^(UIAlertAction *action) {
                                                              
                                                          }];
    [idAlert addAction:defaultAction];
    
    [self presentViewController:idAlert animated:YES completion:nil];
    
    
}

@end
