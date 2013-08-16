//
//  ICSlider.h
//  SliderComponent
//
//  Created by Ilea Cristian on 8/8/13.
//  Copyright (c) 2013 ileacristian.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICSlider;

@protocol ICSliderDelegate

-(void)slider:(ICSlider*)slider didUpdateToValue:(CGFloat)value;
-(void)sliderDidReset:(ICSlider*)slider;

@end

@interface ICSlider : UIView
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) CGFloat maximumValue;
@property (nonatomic, strong) UILabel *minValueLabel;
@property (nonatomic, strong) UILabel *midValueLabel;
@property (nonatomic, strong) UILabel *maxValueLabel;
@property (nonatomic, assign) BOOL continuous;
@property (nonatomic, readonly, getter=isDisabled) BOOL disabled;
@property (nonatomic, weak) id<ICSliderDelegate> delegate;
@end
