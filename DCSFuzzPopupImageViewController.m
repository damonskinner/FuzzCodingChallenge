//
//  DCSFuzzImageViewController.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzPopupImageViewController.h"

@interface DCSFuzzPopupImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *popUpImage;

@end

@implementation DCSFuzzPopupImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.popUpImage.image=self.selectedImage;
    self.popUpImage.contentMode = UIViewContentModeScaleAspectFit;
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
