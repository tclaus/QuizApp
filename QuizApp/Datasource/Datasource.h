//
//  Datasource.h
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Datasource : NSObject

+(NSArray*)loadAggregates;

+(void)saveAggregates:(NSArray*)results forDate:(NSDate*)date;

+(NSArray*)questionsFromFile:(NSString*)file;

@end
