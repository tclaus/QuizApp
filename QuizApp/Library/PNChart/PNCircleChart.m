//
//  PNCircleChart.m
//  PNChartDemo
//
//  Created by kevinzhow on 13-11-30.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNCircleChart.h"
#import "UICountingLabel.h"

@implementation PNCircleChart


- (instancetype)initWithFrame:(CGRect)frame andTotal:(NSNumber *)total andCurrent:(NSNumber *)current
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _total = total;
        _current = current;
        _strokeColor = PNFreshGreen;
        
        _lineWidth = @8.0f;
        UIBezierPath* circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x,self.center.y) radius:self.frame.size.height*0.5 startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(270.01) clockwise:NO];
        
        _circle               = [CAShapeLayer layer];
        _circle.path          = circlePath.CGPath;
        _circle.lineCap       = kCALineCapRound;
        _circle.fillColor     = [UIColor clearColor].CGColor;
        _circle.lineWidth     = _lineWidth.floatValue;
        _circle.zPosition     = 1;

        _circleBG             = [CAShapeLayer layer];
        _circleBG.path        = circlePath.CGPath;
        _circleBG.lineCap     = kCALineCapRound;
        _circleBG.fillColor   = [UIColor clearColor].CGColor;
        _circleBG.lineWidth   = _lineWidth.floatValue;
        _circleBG.strokeColor = PNLightYellow.CGColor;
        _circleBG.strokeEnd   = 1.0;
        _circleBG.zPosition   = -1;
        
        [self.layer addSublayer:_circle];
        [self.layer addSublayer:_circleBG];
        
    }
    
    return self;
    
}

-(void)strokeChart
{
    //Add count label
    
    UICountingLabel *gradeLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, 0, 50.0, 50.0)];
    gradeLabel.textAlignment = NSTextAlignmentCenter;
    gradeLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [gradeLabel setTextColor: PNDeepGrey];
    gradeLabel.center = CGPointMake(self.center.x,self.center.y);
    gradeLabel.method = UILabelCountingMethodEaseInOut;
    gradeLabel.format = @"%d%%";
   
    
    [self addSubview:gradeLabel];
    
    //Add circle params
    
    _circle.lineWidth   = _lineWidth.floatValue;
    _circleBG.lineWidth = _lineWidth.floatValue;
    _circleBG.strokeEnd = 1.0;
    _circle.strokeColor = _strokeColor.CGColor;
    
    //Add Animation
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @(_current.floatValue/_total.floatValue);
    [_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    _circle.strokeEnd   = _current.floatValue/_total.floatValue;
    
    [gradeLabel countFrom:0 to:_current.floatValue/_total.floatValue*100 withDuration:1.0];
   
}

@end
