//
//  ResultAggregate.h
//  QuizApp
//
//  Created by Tope Abayomi on 22/01/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultAggregate : NSObject <NSCoding>

@property (nonatomic, strong) NSDate* date;

/**
 In training mode (fixed number of Questions -) percent
 */
@property (nonatomic, assign) CGFloat percent;

/**
 In quiz mode (fixed time) - the total points
 */
@property (nonatomic, assign) CGFloat points;

@end
