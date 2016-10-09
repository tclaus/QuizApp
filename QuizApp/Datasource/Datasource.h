//
//  Datasource.h
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultAggregate.h"

@interface Datasource : NSObject

/**
 Loads the list of questions ever made as ResultAggregates
 */
+(NSArray*)loadTimeBasedAggregates;
+(NSArray*)loadTrainingAggregates;

+(void)saveTimeBasedAggregates:(NSArray*)results forDate:(NSDate*)date;
+(void)saveTrainingAggregates:(NSArray*)results forDate:(NSDate*)date;

+(NSArray*)questionsFromFile:(NSString*)file;

@end
