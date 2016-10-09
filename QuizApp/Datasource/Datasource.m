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

/**
 Loads the questions
 */
+(NSArray*)questionsFromFile:(NSString*)file{
    
    NSString* name = file.stringByDeletingPathExtension;
    NSString* extension = file.pathExtension;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    NSData* questionsData = [NSData dataWithContentsOfFile:path];
    
    NSArray* questionDictionaries = @[];
    
    if(questionsData){
        NSError* error;
        questionDictionaries = [NSJSONSerialization JSONObjectWithData:questionsData options:NSJSONReadingAllowFragments error:&error];
        
        if(error){
            NSLog(@"Error loading from file %@.%@ Error Message: %@", name, extension, error.description);
        }
    }
    
    return questionDictionaries;
}

+(NSArray*)loadTimeBasedAggregates{
    
    return [self loadAggregates:@"timebasedResultsAggregate.plist"];
}

+(void)saveTimeBasedAggregates:(NSArray*)results forDate:(NSDate*)date{
    
    [self saveAggregates:@"timebasedResultsAggregate.plist" results:results forDate:date];
    
}


+(NSArray*)loadTrainingAggregates{
    
    return [self loadAggregates:@"trainingResultsAggregate.plist"];
}

+(void)saveTrainingAggregates:(NSArray*)results forDate:(NSDate*)date{
    
    [self saveAggregates:@"trainingResultsAggregate.plist" results:results forDate:date];

}

+(NSArray*)loadAggregates:(NSString*)filename{
    
    NSString *resultsStoragePath = [DocumentsDirectory stringByAppendingPathComponent:filename];
    
    NSMutableArray* aggregates = [NSKeyedUnarchiver unarchiveObjectWithFile:resultsStoragePath];
    if(!aggregates){
        aggregates = [NSMutableArray array];
    }
    
    return aggregates;
}

+(void)saveAggregates:(NSString*)filename results:(NSArray*)results forDate:(NSDate*)date {
    
    CGFloat correctScore = [Utils calculateCorrectScore:results];
    CGFloat correctPercent = [Utils calculateCorrectPercent:results];
    
    ResultAggregate* result = [[ResultAggregate alloc] init];
    result.date = date;
    result.percent = correctPercent * 100;
    result.points = correctScore;
    
    NSString *resultsStoragePath = [DocumentsDirectory stringByAppendingPathComponent:filename];
    
    NSMutableArray* aggregates = [NSKeyedUnarchiver unarchiveObjectWithFile:resultsStoragePath];
    
    if(!aggregates){
        aggregates = [NSMutableArray array];
    }
    
    [aggregates addObject:result];
    [NSKeyedArchiver archiveRootObject:aggregates toFile:resultsStoragePath];
    
}


@end
