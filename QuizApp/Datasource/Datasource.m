//
//  Datasource.m
//  QuizApp
//
#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0]


#import "Datasource.h"
#import "Utils.h"
#import "ResultAggregate.h"
#import "GameStats.h"
#import <DasQuiz-Swift.h>

@implementation Datasource

/**
 Loads all questions from a file
 */
+(Questions*)questionsFromFile:(NSString*)file {
    
    NSString* name = file.stringByDeletingPathExtension;
    NSString* extension = file.pathExtension;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    NSData* questionsData = [NSData dataWithContentsOfFile:path];
    
    Questions* questionContainer = [[Questions alloc] init];
    
    if (questionsData) {
        NSError* error;
        NSArray* questionDictionaries = [NSJSONSerialization JSONObjectWithData:questionsData options:NSJSONReadingAllowFragments error:&error];
        NSMutableArray<Question*>* questions = [NSMutableArray array];
        
        for (NSDictionary *item in questionDictionaries) {
            // NSLog(@"Item: %@", item);
            [questions addObject:[[Question alloc] initWithDictionary:item]];
        }
        
        questionContainer.listOfQuestions = questions;
        
        if(error){
            NSLog(@"Error loading from file %@.%@ Error Message: %@", name, extension, error.description);
        }
    }
    
    return questionContainer;
}

+(NSArray*)loadTimeBasedAggregates{
    return [self loadAggregates:@"timebasedResultsAggregate.plist"];
}

+(void)saveTimeBasedAggregates:(Questions*) resultQuestions forDate:(NSDate*)date{
    [self saveAggregates:@"timebasedResultsAggregate.plist" results:resultQuestions forDate:date];
}

+(NSArray*)loadTrainingAggregates{
    return [self loadAggregates:@"trainingResultsAggregate.plist"];
}

+(void)saveTrainingAggregates:(Questions*)resultQuestions forDate:(NSDate*)date{
    [self saveAggregates:@"trainingResultsAggregate.plist" results:resultQuestions forDate:date];
}

+(NSArray*)loadAggregates:(NSString*)filename{
    
    NSString *resultsStoragePath = [DocumentsDirectory stringByAppendingPathComponent:filename];
    
    NSMutableArray* aggregates = [NSKeyedUnarchiver unarchiveObjectWithFile:resultsStoragePath];
    if(!aggregates){
        aggregates = [NSMutableArray array];
    }
    
    return aggregates;
}

+(void)saveAggregates:(NSString*)filename results:(Questions*)resultQuestions forDate:(NSDate*)date {
    
    CGFloat correctScore = [Utils calculateCorrectScore:resultQuestions];
    CGFloat correctPercent = [Utils calculateCorrectPercent:resultQuestions];
    
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


