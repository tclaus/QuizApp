#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(unsigned int, UILabelCountingMethod) {
    UILabelCountingMethodEaseInOut,
    UILabelCountingMethodEaseIn,
    UILabelCountingMethodEaseOut,
    UILabelCountingMethodLinear
};

typedef NSString* (^UICountingLabelFormatBlock)(float value);


@interface UICountingLabel : UILabel

@property (nonatomic, strong) NSString *format;
@property (nonatomic, assign) UILabelCountingMethod method;

@property (nonatomic, copy) UICountingLabelFormatBlock formatBlock;
@property (nonatomic, copy) void (^completionBlock)(void);


-(void)countFrom:(float)startValue to:(float)endValue;
-(void)countFrom:(float)startValue to:(float)endValue withDuration:(NSTimeInterval)duration;

@end

