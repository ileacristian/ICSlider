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

        [self setupSliderBackgroundsForWidth:sliderWidth];
        [self setupSliderForWidth:sliderWidth];
        [self setupResetButton];
        [self setupLabels];

    }
    return self;
}

- (void)setupSliderBackgroundsForWidth:(CGFloat)width {
    UIEdgeInsets capInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    self.sliderGrayBackground = [[UIImage graySliderImageForSize:CGSizeMake(width, 10)] resizableImageWithCapInsets:capInsets];
    self.sliderGradientBackground = [[UIImage gradientSliderImageForSize:CGSizeMake(width, 10)] resizableImageWithCapInsets:capInsets];
}

- (void)setupSliderForWidth:(CGFloat)width {
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 10, width, 23)];
    [self setSliderBackground:self.sliderGrayBackground];

    UIImage *sliderThumbImage = [UIImage sliderThumbImageWithSize:CGSizeMake(26,26)];
    sliderThumbImage = [sliderThumbImage resizableImageWithCapInsets:UIEdgeInsetsMake(24, 24, 24, 24)];

    [self.slider setThumbImage:sliderThumbImage forState:UIControlStateNormal];
    [self.slider setMaximumValue:SLIDER_MAX_VALUE];
    [self.slider setMinimumValue:SLIDER_MIN_VALUE];
    [self.slider addTarget:self action:@selector(sliderDidUpdate:) forControlEvents:UIControlEventValueChanged];
    [self.slider setValue:SLIDER_CENTER_VALUE];

    [self addSubview:self.slider];
}

- (void)setupResetButton {
    CGFloat resetButtonSize = RESET_BUTTON_WIDTH_PERCENT * self.frame.size.width;
    CGFloat resetButtonCenterX = self.frame.size.width - (resetButtonSize / 2.0);
    CGFloat resetButtonCenterY = self.slider.center.y;

    self.resetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, resetButtonSize, resetButtonSize)];
    [self.resetButton setCenter:CGPointMake(resetButtonCenterX, resetButtonCenterY)];
    [self.resetButton addTarget:self action:@selector(resetSlider) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton setImage:[UIImage sliderResetButtonImageForSize:_resetButton.frame.size] forState:UIControlStateNormal];
    [self.resetButton setHidden:YES];
    [self addSubview:self.resetButton];
}

- (void)setupLabels {
    CGFloat sliderWidth = self.slider.frame.size.width;
    CGFloat sliderHeight = self.slider.frame.size.height;

    CGRect minValueLabelFrame = CGRectMake(0, sliderHeight + LABEL_Y_OFFSET, LABEL_WIDTH, 40);
    CGRect midValueLabelFrame = CGRectMake((sliderWidth - LABEL_WIDTH) / 2.0 , minValueLabelFrame.origin.y, LABEL_WIDTH, 40);
    CGRect maxValueLabelFrame = CGRectMake(sliderWidth - LABEL_WIDTH, sliderHeight + LABEL_Y_OFFSET, LABEL_WIDTH, 40);

    self.minValueLabel = [self labelWithText:@"Minimum value" frame:minValueLabelFrame alignment:NSTextAlignmentLeft];
    self.midValueLabel = [self labelWithText:@"Medium value" frame:midValueLabelFrame alignment:NSTextAlignmentCenter];
    self.maxValueLabel = [self labelWithText:@"Maximum value" frame:maxValueLabelFrame alignment:NSTextAlignmentRight];

    [self addSubview:self.minValueLabel];
    [self addSubview:self.midValueLabel];
    [self addSubview:self.maxValueLabel];
}

- (UILabel*)labelWithText:(NSString*)text frame:(CGRect)frame alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];

    [label setTextAlignment:alignment];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:NUMBER_OF_TEXT_LINES];
    [label setFont:[UIFont fontWithName:LABEL_FONT_NAME size:LABEL_FONT_SIZE]];
    [label setTextColor:LABEL_FONT_COLOR];
    [label setText:text];

    return label;
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
