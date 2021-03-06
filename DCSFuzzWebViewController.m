//
//  DCSFuzzWebViewController.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzWebViewController.h"

@interface DCSFuzzWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *fuzzWebView;
@property (weak, nonatomic) IBOutlet UIButton *returnButtonLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;

- (void)viewDidLoad;

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

- (IBAction)returnButton:(id)sender;

- (void)didReceiveMemoryWarning;

@end

@implementation DCSFuzzWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.bottomBarView.backgroundColor = [UIColor blackColor];
    self.returnButtonLabel.tintColor = [UIColor whiteColor];
    self.topBarView.backgroundColor = [UIColor blackColor];

    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.webViewURLString]];
    [self.fuzzWebView loadRequest:request];
    // Do any additional setup after loading the view from its nib.
}


#pragma - mark UIWebView Delegate Methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Loading URL :%@",request.URL.absoluteString);
    
    //return FALSE; //to stop loading
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Failed to load with error :%@",[error debugDescription]);
    
}



#pragma mark - Navigation

- (IBAction)returnButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Misc
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
