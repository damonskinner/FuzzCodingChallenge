//
//  UIImage+HelperMethods.m
//  FuzzCodingChallenge
//
//  Created by Damon Skinner on 5/7/15.
//  Copyright (c) 2015 DamonSkinner. All rights reserved.
//

#import "UIImage+HelperMethods.h"

@implementation UIImage (HelperMethods)


-(UIImage *) reduceImageSize {
    CGSize newSize=CGSizeMake(1000,1000);
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
