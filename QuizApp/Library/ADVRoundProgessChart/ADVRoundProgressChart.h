//
//  ADVRoundProgressChart.h
//  QuizApp
//
//  Created by Tope Abayomi on 20/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADVRoundProgressChart : UIView

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) CGFloat chartBorderWidth;

@property (nonatomic, strong) UIColor *chartBorderColor;

@property (nonatomic, strong) UIColor *chartFillColor;

@property (nonatomic, strong) NSString *fontName;

@property (nonatomic, strong) NSString *detailText;

@end
