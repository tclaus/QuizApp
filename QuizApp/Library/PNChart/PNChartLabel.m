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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.minimumScaleFactor = 11.0f;
        self.numberOfLines = 0;
        self.font = [UIFont fontWithName:[ADVTheme mainFont] size:12];
        self.textColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentLeft;
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
