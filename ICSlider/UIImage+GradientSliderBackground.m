//
//  UIImage+GradientSliderBackground.m
//  SliderComponent
//
//  Created by Ilea Cristian on 8/8/13.
//  Copyright (c) 2013 ileacristian.com. All rights reserved.
//

#import "UIImage+GradientSliderBackground.h"

#define radians(degrees) ((degrees) * M_PI/180)


void drawRoudedRect(CGContextRef context, CGRect rect, CGColorRef color, CGFloat cornerRadius)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    UIBezierPath *roudedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    [roudedRect addClip];
    
    CGContextSetFillColorWithColor(context, color);
    CGContextFillRect(context, rect);
    CGColorSpaceRelease(colorSpace);

}

void drawHorizontalGradientInRoundedRect(CGContextRef context, CGRect rect, NSArray *colors) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    UIBezierPath *roudedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:7.0];

    CGFloat *locations = malloc(sizeof(CGFloat) * colors.count);
    locations[0] = 0;
    for (int i=1;i<colors.count;i++) {
        locations[i] = locations[i-1] + (1.0 / (colors.count - 1));
    }

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);

    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));

    CGContextSaveGState(context);

    [roudedRect addClip];
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@implementation UIImage (GradientSliderBackground)

+(UIImage*)gradientSliderImageForSize:(CGSize)size {

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context= UIGraphicsGetCurrentContext();

    UIColor *firstColor = [UIColor colorWithRed:255.0 green:0 blue:2.0 / 255.0 alpha:1];
    UIColor *secondColor = [UIColor colorWithRed:228.0 / 255.0 green:182.0 /255.0 blue:0 alpha:1];
    UIColor *thirdColor = [UIColor colorWithRed:67.0 /255.0 green:172.0 /255.0 blue:62.0 / 255.0 alpha:1];

    CGColorRef firstCGColor = [firstColor CGColor];
    CGColorRef secondCGColor = [secondColor CGColor];
    CGColorRef thirdCGColor = [thirdColor CGColor];

    drawHorizontalGradientInRoundedRect(context, CGRectMake(0, 0, size.width, size.height), @[(__bridge id)firstCGColor, (__bridge id)secondCGColor, (__bridge id)thirdCGColor]);

    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *imageResult = [UIImage imageWithCGImage:cgImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);

    return imageResult;
}

+(UIImage*)graySliderImageForSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    CGContextRef context= UIGraphicsGetCurrentContext();

    UIColor *color = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:173.0/255 alpha:1];
    CGColorRef grayColor = color.CGColor;
    drawRoudedRect(context, CGRectMake(0, 0, size.width, size.height), grayColor, size.height * 0.5);

    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *imageResult = [UIImage imageWithCGImage:cgImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);

    return imageResult;
}

+(UIImage*)sliderThumbImageWithSize:(CGSize)size {
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context= UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:173.0/255 alpha:1].CGColor);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:252.0/255 green:251.0/255.0 blue:233.0/255.0 alpha:1] CGColor]);

    CGContextBeginPath(context);
    CGRect circleRect = CGRectMake(2, 2,size.width - 4, size.height - 4);
    CGContextAddEllipseInRect(context, circleRect);
    CGContextDrawPath(context, kCGPathFillStroke);

    CGColorSpaceRelease(rgbColorSpace);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *imageResult = [UIImage imageWithCGImage:cgImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    return imageResult;
}

+(UIImage*)sliderResetButtonImageForSize:(CGSize)size {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context= UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:173.0/255 alpha:1] CGColor]);

    CGContextBeginPath(context);
    CGRect circleRect = CGRectMake(2, 2,size.width - 4, size.height - 4);
    CGContextAddEllipseInRect(context, circleRect);

    CGContextTranslateCTM( context, 0.5f * size.width, 0.5f * size.height );
    CGContextRotateCTM(context, radians(45.0f));
    CGContextTranslateCTM( context, -0.5f * size.width, -0.5f * size.height );

    CGContextMoveToPoint(context, size.width / 4.0, size.height / 2.0);
    CGContextAddLineToPoint(context, size.width - (size.width / 4.0), size.height / 2.0);
    CGContextMoveToPoint(context, size.width / 2.0, size.height / 4.0);
    CGContextAddLineToPoint(context, size.width / 2.0, size.height - (size.height / 4.0));
    CGContextDrawPath(context, kCGPathStroke);

    CGColorSpaceRelease(rgbColorSpace);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *imageResult = [UIImage imageWithCGImage:cgImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    return imageResult;
}


@end
