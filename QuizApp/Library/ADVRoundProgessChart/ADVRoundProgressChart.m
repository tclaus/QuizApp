//
//  ADVRoundProgressChart.m
//  QuizApp
//
//  Created by Tope Abayomi on 20/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//
//  With modifications from Thorsten Claus, Oct, 2016
//
#import "ADVRoundProgressChart.h"

@interface ADVRoundProgressChart ()

- (void)_initialize;

@property (nonatomic, strong) UILabel* percentLabel;

@property (nonatomic, strong) UILabel* detailLabel;

@end

@implementation ADVRoundProgressChart

-(void)setProgress:(CGFloat)newProgress {
	_progress = fmaxf(0.0f, fminf(1.0f, newProgress));
	[self setNeedsDisplay];
}

-(void)setChartBorderColor:(UIColor *)chartBorderColor{
    _chartBorderColor = chartBorderColor;
    [self setNeedsDisplay];
}

-(void)setChartBorderWidth:(CGFloat)chartBorderWidth{
    _chartBorderWidth = chartBorderWidth;
    [self setNeedsDisplay];
}

-(void)setChartFillColor:(UIColor *)chartFillColor{
    _chartFillColor = chartFillColor;
    [self setNeedsDisplay];
}

-(void)setDetailText:(NSString *)detailText{
    _detailText = detailText;
    [self setNeedsDisplay];
}

-(void)setFontName:(NSString *)fontName{
    _fontName = fontName;
    [self setNeedsDisplay];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
		[self _initialize];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)aFrame {
    if ((self = [super initWithFrame:aFrame])) {
		[self _initialize];
    }
    return self;
}

-(CGRect)precentLabelRect{
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGFloat midY = CGRectGetMidY(self.bounds);
    CGFloat labelSize = self.bounds.size.width*2/3;
    return CGRectMake(midX - labelSize/2, midY-labelSize/2, labelSize, labelSize);
}

-(CGRect)descriptionLabelRect{
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGFloat midY = CGRectGetMidY(self.bounds);
    CGFloat labelSize = self.bounds.size.width*2/3;
    return CGRectMake(midX - labelSize/2, midY+10, labelSize, labelSize/2);
}

- (void)_initialize {
	self.backgroundColor = [UIColor clearColor];
	
	self.progress = 0.0f;
	self.chartFillColor = [UIColor colorWithWhite:1.0 alpha:0.1f];
	self.chartBorderWidth = 2.0f;
	self.chartBorderColor = [UIColor blueColor];
    self.fontName = @"Helvetica";
    
    
    self.percentLabel = [[UILabel alloc] initWithFrame:[self precentLabelRect]];
    self.percentLabel.backgroundColor = [UIColor clearColor];
    self.percentLabel.textColor = [UIColor whiteColor];
    self.percentLabel.textAlignment = NSTextAlignmentCenter;
    self.percentLabel.font = [UIFont fontWithName:self.fontName size:45.0f];
    self.percentLabel.adjustsFontSizeToFitWidth = YES;
    self.percentLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:self.percentLabel];
    
    
    self.detailLabel = [[UILabel alloc] initWithFrame:[self descriptionLabelRect]];
    self.detailLabel.backgroundColor = [UIColor clearColor];
    self.detailLabel.textColor = [UIColor whiteColor];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.font = [UIFont fontWithName:self.fontName size:15.0f];
    self.detailLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.detailLabel];

}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect innerCircleRect = CGRectInset(rect, _chartBorderWidth*3/4, _chartBorderWidth*3/4);
    CGContextSetFillColorWithColor(context, _chartFillColor.CGColor);
    CGContextFillEllipseInRect (context, innerCircleRect);
    CGContextFillPath(context);

    CGRect strokeCircleRect = CGRectInset(rect, _chartBorderWidth, _chartBorderWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.0f alpha:0.5f].CGColor);
    CGContextSetLineWidth(context, _chartBorderWidth);
    CGContextStrokeEllipseInRect(context, strokeCircleRect);
    CGContextStrokePath(context);
    
    
    CGFloat angle = (360.0f * _progress);
    
    CGContextSetStrokeColorWithColor(context, _chartBorderColor.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(context, _chartBorderWidth);
    CGFloat radius = rect.size.width/2 - _chartBorderWidth;
    CGPathAddArc(path, NULL, rect.size.width/2, rect.size.height/2, radius, 0*3.142/180, angle*3.142/180, 0);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGPathRelease(path);
    
    _percentLabel.frame = [self precentLabelRect];
    _detailLabel.frame = [self descriptionLabelRect];
    
    _percentLabel.font = [UIFont fontWithName:self.fontName size:45.0f];
    _detailLabel.font = [UIFont fontWithName:self.fontName size:15.0f];
    
    _percentLabel.text = [NSString stringWithFormat:@"%.0f%%", _progress*100];
    _detailLabel.text = _detailText;
    
}

@end
