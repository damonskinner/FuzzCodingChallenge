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
#import "UIColor+SampleColors.h"

@interface DCSFuzzImagesViewController ()

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation DCSFuzzImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datastore = [DCSFuzzDatastore sharedDataStore];
    self.imageArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_seamless"]];
    
    [self setupTableView];

    [self prepareTableViewForResizingCells];
    
    for (DCSFuzzData *eachData in self.datastore.fuzzDataArray) {
        if ([eachData.type isEqualToString:@"image"]) {
            [self.imageArray addObject:eachData];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"reloadTheTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCell:) name:@"reloadTheCell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentError:) name:@"presentError" object:nil];
    

}

-(void) setupTableView {
    self.myTableView = [[UITableView alloc]init];
    [self.view addSubview:self.myTableView];
    
    [self.view removeConstraints:self.view.constraints];
    [self.myTableView removeConstraints:self.myTableView.constraints];
    self.myTableView.translatesAutoresizingMaskIntoConstraints=NO;
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource=self;
    self.myTableView.backgroundColor = [UIColor clearColor];
    
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
                                                                     message:[NSString stringWithFormat:@"The ID of this data entry is: %@",((DCSFuzzData *)self.imageArray[indexPath.row]).dataId]
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

-(void)reloadCell:(NSNotification *) notification {
    for (NSInteger i=0; i<[self.imageArray count]; i++) {
        if ([notification.object isEqual:self.imageArray[i]]){
            NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
            [self.myTableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
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
}


@end
