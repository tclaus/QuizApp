//
//  PNChartLabel.m
//  PNChart
//
//  Created by kevin on 10/3/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNChartLabel.h"
#import "PNColor.h"
#import "ADVTheme.h"

@implementation PNChartLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setLineBreakMode:NSLineBreakByWordWrapping];
        [self setMinimumScaleFactor:11.0f];
        [self setNumberOfLines:0];
        [self setFont:[UIFont fontWithName:[ADVTheme mainFont] size:9]];
        [self setTextColor:[UIColor colorWithWhite:0.5f alpha:1.0f]];
        self.backgroundColor = [UIColor clearColor];
        [self setTextAlignment:NSTextAlignmentLeft];
        self.userInteractionEnabled = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
