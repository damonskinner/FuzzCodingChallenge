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

- (void)viewDidLoad;

- (void)setupTableView;
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)reloadTable:(NSNotification *)notification;

- (void)prepareTableViewForResizingCells;
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)presentError:(NSNotification *) notification;
- (UIAlertController *) makeErrorAlertWithError: (NSError *) error;
- (void)idButtonWasTappedForIndexPath:(NSIndexPath *)indexPath;
- (UIAlertController *) makeIDAlertControllerWithIndexPath:(NSIndexPath *) indexPath;

- (void)didReceiveMemoryWarning;
- (void)dealloc;

@end


@implementation DCSFuzzTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datastore = [DCSFuzzDatastore sharedDataStore];
    self.textArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_seamless"]];
    
    [self setupTableView];

    [self prepareTableViewForResizingCells];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"reloadTheTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentError:) name:@"presentError" object:nil];
    
    for (DCSFuzzData *eachData in self.datastore.fuzzDataArray) {
        if ([eachData.type isEqualToString:@"text"]) {
            [self.textArray addObject:eachData];
        }
    }
    [self.myTableView reloadData];
}

#pragma mark - SetupTableview

-(void) setupTableView {
    self.myTableView = [[UITableView alloc]init];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource=self;
    self.myTableView.backgroundColor = [UIColor clearColor];
    
    self.myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.myTableView];
    
    [self.view removeConstraints:self.view.constraints];
    [self.myTableView removeConstraints:self.myTableView.constraints];
    self.myTableView.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"DCSFuzzTextCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    
    NSDictionary *views = @{@"view":self.view,@"tableView":self.myTableView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[tableView]-50-|" options:0 metrics:nil views:views]];
}

//originally used didSelectRowAtIndexPath
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    DCSFuzzWebViewController *webViewVC = [[DCSFuzzWebViewController alloc]init];
    webViewVC.webViewURLString = @"https://fuzzproductions.com/";
    [self presentViewController:webViewVC animated:YES completion:nil];
    
    return NO;
}

- (void)reloadTable:(NSNotification *)notification {
    
    for (DCSFuzzData *eachData in self.datastore.fuzzDataArray) {
        if ([eachData.type isEqualToString:@"text"]) {
            [self.textArray addObject:eachData];
        }
    }
    
    [self.myTableView reloadData];
}

#pragma mark - Tableview delegate

- (void)prepareTableViewForResizingCells {
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 50.0;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cornerRadius = 8.f;
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect bounds = (CGRectInset(cell.bounds, 10, 3));
    
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

#pragma mark - Tableview data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.textArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCSFuzzTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
    
    cell.fuzzText.text = ((DCSFuzzData *)self.textArray[indexPath.row]).data;

    cell.dateLabel.text=((DCSFuzzData *)self.textArray[indexPath.row]).date;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - Alerts

-(void)presentError:(NSNotification *) notification {
    
    UIAlertController *errorAlert = [self makeErrorAlertWithError:notification.object];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
    
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

-(void) idButtonWasTappedForIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *idAlert = [self makeIDAlertControllerWithIndexPath:indexPath];
    [self presentViewController:idAlert animated:YES completion:nil];
    
}

-(UIAlertController *) makeIDAlertControllerWithIndexPath:(NSIndexPath *) indexPath {
    UIAlertController *idAlert = [UIAlertController alertControllerWithTitle:@"Data ID:"
                                                                     message:[NSString stringWithFormat:@"The ID of this data entry is: %@",((DCSFuzzData *)self.textArray[indexPath.row]).dataId]
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler: ^(UIAlertAction *action) {
                                                              
                                                          }];
    [idAlert addAction:defaultAction];
    return idAlert;
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
