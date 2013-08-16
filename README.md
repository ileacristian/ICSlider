ICSlider
========

ICSlider is an iOS component (ARC) that uses UISlider, some labes and a button to create the following result:

![SliderExample](https://raw.github.com/ileacristian/ICSlider/master/slider_example.png)

It has two callbacks for the delegate and several methods that simulate the real UISlider. The images userd are all made with QuartCore.

How to use
----------

1. In your project add the QuartzCore framework
2. Drag and Drop the ICSlider folder into your project - copy files if necessary
3. Include "ICSlider.h" where you want to use it.
4. `[[ICSlider alloc] initWithFrame:CGRectMake(0, 0, 320, 100)]` and add it as a subview
5. Register as a delegate

The interface
-------------
These are the public proprieties available:

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



The protocol
------------
This is the protocol that the delegate must conform to:

	@protocol ICSliderDelegate
	
	-(void)slider:(ICSlider*)slider didUpdateToValue:(CGFloat)value;
	-(void)sliderDidReset:(ICSlider*)slider;

	@end
	
Contact
-------
For suggestions and critique mail me at hello[at]ileacristian.com	

License
-------
	
This code is distributed under the terms and conditions of the [MIT license](https://github.com/ileacristian/ICSlider/blob/master/LICENSE).

