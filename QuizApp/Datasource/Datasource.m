//
//  Datasource.m
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0]


#import "Datasource.h"
#import "Topic.h"
#import "Question.h"
#import "Answer.h"
#import "Utils.h"
#import "ResultAggregate.h"

@implementation Datasource

+(NSArray*)questionsFromFile:(NSString*)file{
    
    NSString* name = [file stringByDeletingPathExtension];
    NSString* extension = [file pathExtension];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    NSData* questionsData = [NSData dataWithContentsOfFile:path];
    
    NSArray* questionDictionaries = [NSArray array];
    
    if(questionsData){
        NSError* error;
        questionDictionaries = [NSJSONSerialization JSONObjectWithData:questionsData options:NSJSONReadingAllowFragments error:&error];
        
        if(error){
            NSLog(@"Error loading from file %@.%@ Error Message: %@", name, extension, error.description);
        }
    }
    
    return questionDictionaries;
}

+(NSArray*)loadAggregates{
    
    NSString *resultsStoragePath = [DocumentsDirectory stringByAppendingPathComponent:@"resultsAggregate.plist"];
    
    NSMutableArray* aggregates = [NSKeyedUnarchiver unarchiveObjectWithFile:resultsStoragePath];
    if(!aggregates){
        aggregates = [NSMutableArray array];
    }

    return aggregates;
}

+(void)saveAggregates:(NSArray*)results forDate:(NSDate*)date{

    CGFloat correctScore = [Utils calculateCorrectScore:results];
    
    ResultAggregate* result = [[ResultAggregate alloc] init];
    result.date = date;
    result.percent = correctScore * 100;
    
    NSString *resultsStoragePath = [DocumentsDirectory stringByAppendingPathComponent:@"resultsAggregate.plist"];
    
    NSMutableArray* aggregates = [NSKeyedUnarchiver unarchiveObjectWithFile:resultsStoragePath];
    
    if(!aggregates){
        aggregates = [NSMutableArray array];
    }
    
    [aggregates addObject:result];
    [NSKeyedArchiver archiveRootObject:aggregates toFile:resultsStoragePath];
    
}


@end
