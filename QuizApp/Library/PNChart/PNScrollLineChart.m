//
//  FDCaptionGraphView.m
//  SampleProj
//
//  Created by frank on 20/03/13.
//  Copyright (c) 2013 Francesco Di Lorenzo. All rights reserved.
//

#import "PNScrollLineChart.h"

#import <QuartzCore/QuartzCore.h>


@interface PNScrollLineChart ()

@end

@implementation PNScrollLineChart

- (id)initWithFrame:(CGRect)frame {
    if ( (self = [super initWithFrame:frame]) ) {
        [self initialize];        
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ( (self = [super initWithCoder:aDecoder]) ) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    
    CGRect graphViewFrame = self.frame;
    graphViewFrame.origin.x = 0;
    graphViewFrame.origin.y = 0;
    
    _graphView = [[PNLineChart alloc] initWithFrame:graphViewFrame];
    //_graphView.autoresizeToFitData = YES;
    _graphView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = self.graphView.backgroundColor;
    
    [self addSubview:_graphView];
}

- (CGSize)contentSizeWithWidth:(CGFloat)width {
    return CGSizeMake(width, self.frame.size.height);
}

- (void)setYValues:(NSArray *)values{
    [self.graphView setYValues:values];
    self.contentSize = [self contentSizeWithWidth:self.graphView.frame.size.width];
}

- (void)setXLabels:(NSArray *)labels{
    [self.graphView setXLabels:labels];
    self.contentSize = [self contentSizeWithWidth:self.graphView.frame.size.width];
}


#pragma mark - Actions

- (void)strokeChart{
    [self.graphView strokeChart];
}

@end
