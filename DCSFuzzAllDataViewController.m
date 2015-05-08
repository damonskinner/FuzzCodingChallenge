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
#import "UIColor+SampleColors.h"


@interface DCSFuzzAllDataViewController ()

@property (nonatomic, strong) UITableView *myTableView;

- (void)viewDidLoad;

- (void)setupTableView;
- (void)reloadCell:(NSNotification *) notification;
- (void)reloadTable:(NSNotification *)notification;

- (void)prepareTableViewForResizingCells;
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void) idButtonWasTappedForIndexPath:(NSIndexPath *)indexPath;
-(UIAlertController *) makeIDAlertControllerWithIndexPath:(NSIndexPath *) indexPath;
-(UIAlertController *) makeErrorAlertWithError: (NSError *) error;
-(void)presentError:(NSNotification *) notification;

- (void)didReceiveMemoryWarning;
- (void)dealloc;

@end

@implementation DCSFuzzAllDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datastore = [DCSFuzzDatastore sharedDataStore];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_seamless"]];
    [self setupTableView];
    
    [self prepareTableViewForResizingCells];
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"reloadTheTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCell:) name:@"reloadTheCell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentError:) name:@"presentError" object:nil];
    
}

#pragma mark - SetupTableview

-(void) setupTableView {
    self.myTableView = [[UITableView alloc]init];
    [self.view addSubview:self.myTableView];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource=self;
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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

- (void)reloadCell:(NSNotification *) notification {
    
    for (NSInteger i=0; i<[self.datastore.fuzzDataArray count]; i++) {
        if ([notification.object isEqual:self.datastore.fuzzDataArray[i]]){
            NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
            [self.myTableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)reloadTable:(NSNotification *)notification {

    [self.myTableView reloadData];
    
}

#pragma mark - Tableview delegate

- (void)prepareTableViewForResizingCells {
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 50.0;
}

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
        return NO;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[DCSFuzzImageTableViewCell class]]) {
        CGFloat cornerRadius = 22.f;
        CAShapeLayer *cornerEdges = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = (CGRectInset(cell.bounds, 10, 5));
        
        cornerEdges.fillColor = [UIColor clearColor].CGColor;
        cornerEdges.strokeColor = [UIColor greenColor].CGColor;
        
        //top left
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds)+40, CGRectGetMinY(bounds));
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds)+20);
        
        //bottom left
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds)-20);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds)+40, CGRectGetMaxY(bounds));
        
        //top right
        CGPathMoveToPoint(pathRef, nil, CGRectGetMaxX(bounds)-40, CGRectGetMinY(bounds));
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds)+20);
        
        //bottom right
        CGPathMoveToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)-20);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds)-40, CGRectGetMaxY(bounds));
        
        
        cornerEdges.path = pathRef;
        
        CFRelease(pathRef);
        
        CGMutablePathRef pathRef2 = CGPathCreateMutable();
        
        CAShapeLayer *cornerFill = [[CAShapeLayer alloc]init];
        cornerFill.fillColor = [UIColor SampleGrayLight].CGColor;
        cornerEdges.strokeColor = [UIColor SampleGray].CGColor;
        
        //top left
        CGPathMoveToPoint(pathRef2, nil, CGRectGetMinX(bounds)+40, CGRectGetMinY(bounds));
        CGPathAddLineToPoint(pathRef2, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddLineToPoint(pathRef2, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds)+20);
        CGPathAddArcToPoint(pathRef2, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMinX(bounds)+40, CGRectGetMinY(bounds), cornerRadius);
        
        //bottom left
        CGPathMoveToPoint(pathRef2, nil, CGRectGetMinX(bounds)+40, CGRectGetMaxY(bounds));
        CGPathAddLineToPoint(pathRef2, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddLineToPoint(pathRef2, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds)-20);
        CGPathAddArcToPoint(pathRef2, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds)+40, CGRectGetMaxY(bounds), cornerRadius);
        
        //top right
        CGPathMoveToPoint(pathRef2, nil, CGRectGetMaxX(bounds)-40, CGRectGetMinY(bounds));
        CGPathAddLineToPoint(pathRef2, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        CGPathAddLineToPoint(pathRef2, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds)+20);
        CGPathAddArcToPoint(pathRef2, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds)-40, CGRectGetMinY(bounds), cornerRadius);
        
        //bottom right
        CGPathMoveToPoint(pathRef2, nil, CGRectGetMaxX(bounds)-40, CGRectGetMaxY(bounds));
        CGPathAddLineToPoint(pathRef2, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        CGPathAddLineToPoint(pathRef2, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)-20);
        CGPathAddArcToPoint(pathRef2, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds)-40, CGRectGetMaxY(bounds), cornerRadius);
        
        
        cornerFill.path=pathRef2;
        
        CFRelease(pathRef2);
        
        
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:cornerEdges atIndex:1];
        [testView.layer insertSublayer:cornerFill atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    } else {
        CGFloat cornerRadius = 8.f;
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = (CGRectInset(cell.bounds, 5, 5));
        
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = [UIColor blackColor].CGColor;
        
        
        CGPathMoveToPoint(pathRef, nil, CGRectGetMidX(bounds), CGRectGetMinY(bounds));  //topcenter
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
        
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMidY(bounds), CGRectGetMinX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMidX(bounds), CGRectGetMinY(bounds));
        
        layer.path = pathRef;
        CFRelease(pathRef);
        
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}

#pragma mark - Tableview data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.datastore.fuzzDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).type isEqualToString:@"image"]) {
        DCSFuzzImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
        
        cell.fuzzImage.image = ((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).fuzzImage;
        cell.dateLabel.text = ((DCSFuzzData *) self.datastore.fuzzDataArray[indexPath.row]).date;
        cell.delegate = self;

        return cell;
    } else if ([((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).type isEqualToString:@"text"]){
        DCSFuzzTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        
        cell.fuzzText.text = ((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).data;
        [cell.fuzzText sizeToFit];
        cell.dateLabel.text = ((DCSFuzzData *) self.datastore.fuzzDataArray[indexPath.row]).date;
        cell.delegate = self;

        
        return cell;
    } else {
        DCSFuzzTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        cell.fuzzText.text=((DCSFuzzData *)self.datastore.fuzzDataArray[indexPath.row]).data;
        cell.delegate =self;
        
        return cell;
    }
}

#pragma mark - Alerts

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

-(void)presentError:(NSNotification *) notification {
    
    UIAlertController *errorAlert = [self makeErrorAlertWithError:notification.object];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
}


#pragma mark - Misc
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
