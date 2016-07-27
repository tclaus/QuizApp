//
//  PNLineChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNLineChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"
#import "ADVTheme.h"

#define dataPointSpacing 20.0f

@implementation PNLineChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ( (self = [super initWithCoder:aDecoder]) ) {
        [self initialize];
    }
    
    return self;
}

-(void)initialize{
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds   = YES;
    _chartLine           = [CAShapeLayer layer];
    _chartLine.lineCap   = kCALineCapRound;
    _chartLine.lineJoin  = kCALineJoinBevel;
    _chartLine.fillColor = [UIColor whiteColor].CGColor;
    _chartLine.lineWidth = 3.0;
    _chartLine.strokeEnd = 0.0;
    _showLabel           = YES;
    _pathPoints = [[NSMutableArray alloc] init];
    self.userInteractionEnabled = YES;
    _xLabelHeight = 20.0;
    _chartCavanHeight = self.frame.size.height - chartMargin * 2 - _xLabelHeight*2 ;
    [self.layer addSublayer:_chartLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self resizeToFitData];
}


-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    
    float max = 0;
    for (NSString * valueString in yValues) {
        float value = valueString.floatValue;
        if (value > max) {
            max = value;
        }
    }
    
    //Min value for Y label
    if (max < 5) {
        max = 5;
    }
    
    _yValueMax = (float)max;
    
    if (_showLabel) {
        self.yLabels = yValues;
    }
    
    [self resizeToFitData];
}

-(void)setYLabels:(NSArray *)yLabels
{
    
    float level = _yValueMax / 5.0;
	
    NSInteger index = 0;
	NSInteger num = yLabels.count + 1;
	while (num > 0) {
		CGFloat levelHeight = _chartCavanHeight /5.0;
		PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0,_chartCavanHeight - index * levelHeight + (levelHeight - yLabelHeight) , 20.0, yLabelHeight)];
		label.textAlignment = NSTextAlignmentRight;
		label.text = [NSString stringWithFormat:@"%1.f",level * index];
        label.textColor = [UIColor whiteColor];
		[self addSubview:label];
        index +=1 ;
		num -= 1;
	}
}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    
    if(_showLabel){
        _xLabelWidth = dataPointSpacing;//(self.frame.size.width - chartMargin - 30.0)/[xLabels count];
        //for (NSString * labelText in xLabels) {
        //for (int i = 0; i < xLabels.count; i+=3) {
        for (int i = 0; i < xLabels.count; i++) {

            NSString * labelText = xLabels[i];
            NSInteger index = [xLabels indexOfObject:labelText];
            PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(index * _xLabelWidth + 30.0, self.frame.size.height - 30.0, _xLabelWidth*3, 20.0)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = labelText;
            label.textColor = [UIColor whiteColor];
            [self addSubview:label];
        }
    }else{
        _xLabelWidth = dataPointSpacing;//(self.frame.size.width)/[xLabels count];
    }
    
    [self resizeToFitData];
}

-(void)setStrokeColor:(UIColor *)strokeColor
{
	_strokeColor = strokeColor;
	_chartLine.strokeColor = strokeColor.CGColor;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self chechPoint:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self chechPoint:touches withEvent:event];
}

-(void)chechPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGPathRef originalPath = _progressline.CGPath;
    CGPathRef strokedPath = CGPathCreateCopyByStrokingPath(originalPath, NULL, 3.0, kCGLineCapRound, kCGLineJoinRound, 3.0);
    BOOL pathContainsPoint = CGPathContainsPoint(strokedPath, NULL, touchPoint, NO);
    if (pathContainsPoint)
    {
        [_delegate userClickedOnLinePoint:touchPoint];
        for (NSValue *val in _pathPoints) {
            CGPoint p = val.CGPointValue;
            if (p.x + 3.0 > touchPoint.x && p.x - 3.0 < touchPoint.x && p.y + 3.0 > touchPoint.y && p.y - 3.0 < touchPoint.y ) {
                [_delegate userClickedOnLineKeyPoint:touchPoint andPointIndex:[_pathPoints indexOfObject:val]];
            }
        }
    }
}

-(void)strokeChart
{
    
    if(_yValues.count == 0){
        return;
    }
    UIGraphicsBeginImageContext(self.frame.size);
    
    _progressline = [UIBezierPath bezierPath];
    
    CGFloat firstValue = [_yValues[0] floatValue];
    
    CGFloat xPosition = _xLabelWidth;
    
    if(!_showLabel){
        _chartCavanHeight = self.frame.size.height  - _xLabelHeight*2;
        xPosition = 0;
    }
    
    float grade = (float)firstValue / (float)_yValueMax;
    

    [_progressline moveToPoint:CGPointMake( xPosition, _chartCavanHeight - grade * _chartCavanHeight + _xLabelHeight)];
    [_pathPoints addObject:[NSValue valueWithCGPoint:CGPointMake( xPosition, _chartCavanHeight - grade * _chartCavanHeight + _xLabelHeight)]];
    _progressline.lineWidth = 3.0;
    _progressline.lineCapStyle = kCGLineCapRound;
    _progressline.lineJoinStyle = kCGLineJoinRound;
    NSInteger index = 0;
    for (NSString * valueString in _yValues) {
        float value = valueString.floatValue;
        
        float grade = (float)value / (float)_yValueMax;
        if (index != 0) {
            
            
            CGPoint point = CGPointMake(index * _xLabelWidth  + 30.0 + _xLabelWidth /2.0, _chartCavanHeight - (grade * _chartCavanHeight) + _xLabelHeight);
            [_pathPoints addObject:[NSValue valueWithCGPoint:point]];
            [_progressline addLineToPoint:point];
            [_progressline moveToPoint:point];
        }
        
        index += 1;
    }
    [_progressline stroke];
    
    _chartLine.path = _progressline.CGPath;
	if (_strokeColor) {
		_chartLine.strokeColor = _strokeColor.CGColor;
	}else{
		_chartLine.strokeColor = [ADVTheme foregroundColor].CGColor;
	}
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @1.0f;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _chartLine.strokeEnd = 1.0;
    
    UIGraphicsEndImageContext();
}

- (CGFloat)widthToFitData {
    CGFloat res = 0;
    
    if (self.yValues) {
        res += (self.yValues.count - 1)*dataPointSpacing; // space occupied by data points
        //res += (self.edgeInsets.left + self.edgeInsets.right) ; // lateral margins;
    }
    
    return res;
}

- (void)resizeToFitData {
    CGFloat widthToFitData = [self widthToFitData];
    if (widthToFitData > self.frame.size.width) {
        [self changeFrameWidthTo:widthToFitData];
    }
}

- (void)changeFrameWidthTo:(CGFloat)width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

@end
