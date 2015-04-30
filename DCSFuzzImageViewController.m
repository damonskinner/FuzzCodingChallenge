//
//  DCSFuzzImageViewController.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzImageViewController.h"

@interface DCSFuzzImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *popUpImage;

@end

@implementation DCSFuzzImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popUpImage.image=self.selectedImage;
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void) viewTapped: (UIGestureRecognizer *)gesture {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
