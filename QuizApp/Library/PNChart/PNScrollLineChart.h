//
//  FDCaptionGraphView.h
//  SampleProj
//
//  Created by frank on 20/03/13.
//  Copyright (c) 2013 Francesco Di Lorenzo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNLineChart.h"

@class PNLineChart;


@interface PNScrollLineChart : UIScrollView

@property (nonatomic, strong) PNLineChart *graphView;
- (void)setYValues:(NSArray *)values;
- (void)setXLabels:(NSArray *)labels;
- (void)strokeChart;

@end
