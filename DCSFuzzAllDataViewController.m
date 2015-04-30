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
    
    self.myTableView = [[UITableView alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTableView];
    
    [self.view removeConstraints:self.view.constraints];
    [self.myTableView removeConstraints:self.myTableView.constraints];
    self.myTableView.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"DCSFuzzTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource=self;
    
    NSDictionary *views = @{@"view":self.view,@"tableView":self.myTableView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[tableView]-20-|" options:0 metrics:nil views:views]];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.myTableView.contentInset = UIEdgeInsetsMake(10.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"DCSFuzzTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"DCSFuzzImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"imageCell"];
    
    [self prepareTableViewForResizingCells];
    
    
    self.datastore = [DCSFuzzDatastore sharedDataStore];
    [self.datastore populateDatastoreWithCompletionBlock:^{
        [self.myTableView reloadData];
        
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
                    [self.myTableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
                    if (i==[self.datastore.fuzzDataArray count]-1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTheTable" object:nil];
                    }

                    
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
