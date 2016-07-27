//
//  FDCaptionGraphView.h
//  SampleProj
//
//  Created by frank on 20/03/13.
//  Copyright (c) 2013 Francesco Di Lorenzo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNBarChart.h"

@class PNBarChart;


@interface PNScrollBarChart : UIScrollView

@property (nonatomic, strong) PNBarChart *graphView;
@property (nonatomic, strong) UIColor * strokeColor;

- (void)setYValues:(NSArray *)values;
- (void)setXLabels:(NSArray *)labels;
- (void)setLegend:(NSString*)legend;
- (void)strokeChart;


@end
