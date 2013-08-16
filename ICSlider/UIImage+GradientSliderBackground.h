//
//  UIImage+GradientSliderBackground.h
//  SliderComponent
//
//  Created by Ilea Cristian on 8/8/13.
//  Copyright (c) 2013 ileacristian.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GradientSliderBackground)

+(UIImage*)gradientSliderImageForSize:(CGSize)size;
+(UIImage*)sliderThumbImageWithSize:(CGSize)size;
+(UIImage*)sliderResetButtonImageForSize:(CGSize)size;
+(UIImage*)graySliderImageForSize:(CGSize)size;

@end
