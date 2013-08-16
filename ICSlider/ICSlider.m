//
//  ICSlider.m
//  SliderComponent
//
//  Created by Ilea Cristian on 8/8/13.
//  Copyright (c) 2013 ileacristian.com. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "ICSlider.h"
#import "UIImage+GradientSliderBackground.h"

#define SLIDER_MAX_VALUE 1.0f
#define SLIDER_CENTER_VALUE 0.5f
#define SLIDER_MIN_VALUE 0.0f

#define SLIDER_WIDTH_PERCENT 0.85f
#define RESET_BUTTON_WIDTH_PERCENT 0.10f

#define NUMBER_OF_TEXT_LINES 0
#define LABEL_WIDTH 70
#define LABEL_Y_OFFSET 15
#define LABEL_FONT_SIZE 12.0
#define LABEL_FONT_NAME @"Helvetica-Bold"
#define LABEL_FONT_COLOR [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:173.0/255 alpha:1]

@interface ICSlider()
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIImage *sliderGradientBackground;
@property (nonatomic, strong) UIImage *sliderGrayBackground;
@property (nonatomic, assign, getter=isDisabled) BOOL disabled;

@end

@implementation ICSlider


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSUInteger sliderWidth = SLIDER_WIDTH_PERCENT * frame.size.width;
        _sliderGrayBackground = [[UIImage graySliderImageForSize:CGSizeMake(sliderWidth, 10)] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
        _sliderGradientBackground = [[UIImage gradientSliderImageForSize:CGSizeMake(sliderWidth, 10)] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
        
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 10, sliderWidth, 23)];
        [self setSliderBackground:self.sliderGrayBackground];
        [_slider setThumbImage:[[UIImage sliderThumbImageWithSize:CGSizeMake(26,26)]resizableImageWithCapInsets:UIEdgeInsetsMake(24, 24, 24, 24)] forState:UIControlStateNormal];
        [_slider setMaximumValue:SLIDER_MAX_VALUE];
        [_slider setMinimumValue:SLIDER_MIN_VALUE];
        [_slider addTarget:self action:@selector(sliderDidUpdate:) forControlEvents:UIControlEventValueChanged];
        [_slider setValue:SLIDER_CENTER_VALUE];
        
        [self addSubview:_slider];

        CGFloat resetButtonSize = RESET_BUTTON_WIDTH_PERCENT * frame.size.width;
        CGFloat resetButtonCenterX = frame.origin.x + frame.size.width - (resetButtonSize / 2.0);
        CGFloat resetButtonCenterY = _slider.center.y;

        _resetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, resetButtonSize, resetButtonSize)];
        [_resetButton setCenter:CGPointMake(resetButtonCenterX, resetButtonCenterY)];
        [_resetButton addTarget:self action:@selector(resetSlider) forControlEvents:UIControlEventTouchUpInside];
        [_resetButton setImage:[UIImage sliderResetButtonImageForSize:_resetButton.frame.size] forState:UIControlStateNormal];
        [self.resetButton setHidden:YES];
        [self addSubview:_resetButton];

        _minValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _slider.frame.size.height + LABEL_Y_OFFSET, LABEL_WIDTH, 40)];
        [_minValueLabel setTextAlignment:NSTextAlignmentLeft];
        [_minValueLabel setBackgroundColor:[UIColor clearColor]];
        [_minValueLabel setNumberOfLines:NUMBER_OF_TEXT_LINES];
        [_minValueLabel setFont:[UIFont fontWithName:LABEL_FONT_NAME size:LABEL_FONT_SIZE]];
        [_minValueLabel setTextColor:LABEL_FONT_COLOR];
        [_minValueLabel setText:@"Very dissatisfied"];
        [self addSubview:_minValueLabel];

        _midValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LABEL_WIDTH, 40)];
        [_midValueLabel setCenter:CGPointMake(_slider.center.x, _minValueLabel.center.y)];
        [_midValueLabel setTextAlignment:NSTextAlignmentCenter];
        [_midValueLabel setBackgroundColor:[UIColor clearColor]];
        [_midValueLabel setNumberOfLines:NUMBER_OF_TEXT_LINES];
        [_midValueLabel setFont:[UIFont fontWithName:LABEL_FONT_NAME size:LABEL_FONT_SIZE]];
        [_midValueLabel setTextColor:LABEL_FONT_COLOR];
        [_midValueLabel setText:@"Neutral"];
        [self addSubview:_midValueLabel];

        _maxValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(_slider.frame.size.width - LABEL_WIDTH, _slider.frame.size.height + LABEL_Y_OFFSET, LABEL_WIDTH, 40)];
        [_maxValueLabel setTextAlignment:NSTextAlignmentRight];
        [_maxValueLabel setBackgroundColor:[UIColor clearColor]];
        [_maxValueLabel setNumberOfLines:NUMBER_OF_TEXT_LINES];
        [_maxValueLabel setFont:[UIFont fontWithName:LABEL_FONT_NAME size:LABEL_FONT_SIZE]];
        [_maxValueLabel setTextColor:LABEL_FONT_COLOR];
        [_maxValueLabel setText:@"Very satisfied"];
        [self addSubview:_maxValueLabel];

    }
    return self;
}

- (void)setSliderBackground:(UIImage*)backgroundImage {
    [_slider setMaximumTrackImage:backgroundImage forState:UIControlStateNormal];
    [_slider setMinimumTrackImage:backgroundImage forState:UIControlStateNormal];
}


-(void)sliderDidUpdate:(UISlider*)slider {
    [self setDisabled:NO];
    [self setSliderBackground:self.sliderGradientBackground];
    [self.resetButton setHidden:NO];
    [self.delegate slider:self didUpdateToValue:self.slider.value];
}

-(void)resetSlider {
    [self.slider setValue:[self sliderCenterValue] animated:YES];
    [self.delegate sliderDidReset:self];
    [self setSliderBackground:self.sliderGrayBackground];
    [self setDisabled:YES];
    [self.resetButton setHidden:YES];
}

-(CGFloat)sliderCenterValue {
    return (self.slider.minimumValue + self.slider.maximumValue) / 2.0;
}

#pragma mark slider proxy methods

-(void)setValue:(CGFloat)value {
    [self.slider setValue:value];
}

-(void)setValue:(CGFloat)value animated:(BOOL)animated {
    [self.slider setValue:value animated:animated];
}

-(void)setMinimumValue:(CGFloat)minimumValue {
    [self.slider setMinimumValue:minimumValue];
}

-(void)setMaximumValue:(CGFloat)maximumValue {
    [self.slider setMaximumValue:maximumValue];
}

-(void)setContinuous:(BOOL)continuous {
    [self.slider setContinuous:continuous];
}

-(CGFloat)value {
    return self.slider.value;
}

-(CGFloat)minimumValue {
    return self.slider.minimumValue;
}

-(CGFloat)maximumValue {
    return self.slider.maximumValue;
}

-(BOOL)continuous {
    return self.slider.continuous;
}

@end
