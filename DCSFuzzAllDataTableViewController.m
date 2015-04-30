//
//  DCSFuzzAllDataTableViewController.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzAllDataTableViewController.h"
#import "DCSFuzzData.h"
#import "DCSFuzzTextCell.h"
#import "DCSFuzzImageTableViewCell.h"
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
                    
                }];
                
                [myQueue addOperation:imageDownload];
                
            }
        }
    }];
    
    

    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
//        cell.contentView.backgroundColor = [UIColor redColor];
        
        cell.fuzzImage.image = ((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).fuzzImage;
        cell.fuzzImage.contentMode = UIViewContentModeScaleAspectFit;
        

        return cell;
    } else if ([((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).type isEqualToString:@"text"]){
        DCSFuzzTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        
        cell.fuzzText.text = ((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).data;
        
        cell.fuzzText.numberOfLines=0;
        cell.fuzzText.lineBreakMode= NSLineBreakByWordWrapping;
        return cell;
    } else {
        DCSFuzzTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        cell.textLabel.text=@"";
        
        return cell;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).type isEqualToString:@"image"]) {
        DCSFuzzImageViewController *popUpImageVC = [[DCSFuzzImageViewController alloc] init];
        popUpImageVC.selectedImage =((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).fuzzImage;
        [self presentViewController:popUpImageVC animated:YES completion:nil];
    } else if ([((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).type isEqualToString:@"text"]) {
        DCSFuzzWebViewController *webViewVC = [[DCSFuzzWebViewController alloc]init];
        webViewVC.webViewURLString = @"https://fuzzproductions.com/";
        [self presentViewController:webViewVC animated:YES completion:nil];
    }
    
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    return NO;
}

@end
