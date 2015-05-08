//
//  DCSFuzzDatastore.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 4/29/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "DCSFuzzDatastore.h"
#import "DCSFuzzAPI.h"
#import <AFNetworking.h>
#import "UIImage+HelperMethods.h"

@implementation DCSFuzzDatastore

+ (instancetype)sharedDataStore {
    static DCSFuzzDatastore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[DCSFuzzDatastore alloc] init];
    });
    
    return _sharedDataStore;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _fuzzDataArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void) populateDatastoreWithCompletionBlock:(void (^)(BOOL, NSError *))completionBlock {
    
    [DCSFuzzAPI getFuzzDataWithCompletionBlock:^(NSArray *arrayOfDicts, BOOL success) {
        
        if (success) {
            for (NSDictionary *eachDictionary in arrayOfDicts) {
                [self.fuzzDataArray addObject:[DCSFuzzData dataFromDictionary:eachDictionary]];
                
            }
            completionBlock(YES, nil);
        } else {
            completionBlock(NO, arrayOfDicts[0]);
        }
        
    }];
    
}


-(void) downloadImagesWithCompletionBlock:(void (^)(DCSFuzzData *fuzzData))completionBlock {
    for (NSInteger i=0;i<[self.fuzzDataArray count];i++) {
        if ([((DCSFuzzData *)self.fuzzDataArray[i]).type isEqualToString:@"image"]) {
            NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
            [myQueue setMaxConcurrentOperationCount:10];
            
            NSURL *imageURL = [NSURL URLWithString:((DCSFuzzData *)self.fuzzDataArray[i]).data];
            
            NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL:imageURL];
            AFHTTPRequestOperation *imageDownload = [[AFHTTPRequestOperation alloc] initWithRequest:imageRequest];
            imageDownload.responseSerializer = [[AFImageResponseSerializer alloc] init];
            
            [imageDownload setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                UIImage *newImage = responseObject;
                if (newImage.size.width>=1000 && newImage.size.height>=1000) {
                    
                    newImage = [newImage reduceImageSize];
                    
                    ((DCSFuzzData *)self.fuzzDataArray[i]).fuzzImage=newImage;
                } else {
                    ((DCSFuzzData *)self.fuzzDataArray[i]).fuzzImage=newImage;
                }
        
                
                completionBlock(((DCSFuzzData *)self.fuzzDataArray[i]));
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Fail!");
                ((DCSFuzzData *)self.fuzzDataArray[i]).fuzzImage=[UIImage imageNamed:@"no_image"];
                
            }];
            
            [myQueue addOperation:imageDownload];
            
        }
    }
}


@end
