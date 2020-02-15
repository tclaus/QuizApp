//
//  Datasource.h
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultAggregate.h"

@class Questions;
@interface Datasource : NSObject

/**
 Loads the list of questions ever made as ResultAggregates
 */
+(NSArray*)loadTimeBasedAggregates;
+(NSArray*)loadTrainingAggregates;

+(void)saveTimeBasedAggregates:(Questions*) resultQuestions forDate:(NSDate*) date;
+(void)saveTrainingAggregates:(Questions*) resultQuestions forDate:(NSDate*) date;

@end
