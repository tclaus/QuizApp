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
+(NSArray*) loadAggregates;

+(void)saveAggregates:(NSArray*)results forDate:(NSDate*)date;

+(NSArray*)questionsFromFile:(NSString*)file;

@end
