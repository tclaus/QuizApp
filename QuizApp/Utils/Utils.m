//
//  Utils.m
//  QuizApp
//
//  Created by Tope Abayomi on 23/01/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "Utils.h"
#import "ResultAggregate.h"
#import "Config.h"
#import "Topic.h"
#import "Question.h"

@implementation Utils

+(CGFloat)calculateAverageTestScores:(NSArray*)aggregates{
    
    CGFloat average = 0.0;
    
    for (ResultAggregate* aggregate in aggregates) {
        average+= aggregate.percent;
    }
    
    if(aggregates.count > 0){
        average /= aggregates.count;
    }
    return average;
}

+(CGFloat)getLastTestScore:(NSArray*)aggregates{

    CGFloat scorePercent = 0.0;
    if(aggregates.count > 0){
        
        ResultAggregate* aggregate = aggregates[aggregates.count - 1];
        scorePercent = aggregate.percent;
    }
    
    return scorePercent;
}


+(NSArray*)getLast:(NSInteger)count scoresFromAggregates:(NSArray*)aggregates{
    
    NSMutableArray* scores = [NSMutableArray array];
    for(ResultAggregate* aggregate in aggregates){
        
        [scores addObject:[NSNumber numberWithFloat:aggregate.percent]];
    }
    
    return [self getLast:count elementsFromArray:scores];
}

+(NSArray*)getLast:(NSInteger)count labelsForAggregates:(NSArray *)aggregates{

    NSMutableArray* labels = [NSMutableArray array];
    for(ResultAggregate* aggregate in aggregates){
        
        [labels addObject:[NSString stringWithFormat:@"%.0f%%", aggregate.percent]];
    }
    
    return [self getLast:count elementsFromArray:labels];
}

+(CGFloat)calculateCorrectScore:(NSArray*)questions{
    
    CGFloat fractionCorrect = 0.0;
    
    if(questions.count  > 0){
        
        NSInteger correctCount = [self calculateNumberOfCorrectAnswers:questions];
        fractionCorrect = correctCount/(CGFloat)questions.count;
    }
    
    
    return fractionCorrect;
}

+(NSInteger)calculateNumberOfCorrectAnswers:(NSArray*)questions{
    
    NSInteger correctCount = 0;

    if(questions.count  > 0){
        for (Question* question in questions) {
            if([question hasBeenAnsweredCorrectly]){
                correctCount++;
            }
        }
    }

    return correctCount;
}

+(NSArray*)loadQuestionsFromTopics:(NSArray*)selectedTopics forTotalNumberOfQuestions:(NSInteger)questionCount{
    
    NSMutableArray *allQuestions = [NSMutableArray array];
    for (Topic* topic in selectedTopics) {
        
        for (NSDictionary* questionDic in topic.questionJSONObjects) {
            Question* question = [[Question alloc] initWithDictionary:questionDic];
            [allQuestions addObject:question];
        }
    }
    
    NSArray* shuffledQuestions = [self shuffleArray:allQuestions];
    NSArray* batch = [self getFirst:questionCount elementsFromArray:shuffledQuestions];
    
    for (Question* question in batch) {
        NSArray* shuffledAnswers = [self shuffleArray:question.answers];
        question.answers = shuffledAnswers;
    }
    
    return batch;
}


+(NSArray*)shuffleArray:(NSArray*)array
{
    NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:array];
    static BOOL seeded = NO;
    if(!seeded)
    {
        seeded = YES;
        srandom((unsigned int)time(NULL));
    }
    
    NSUInteger count = array.count;
    for (NSUInteger i = 0; i < count; ++i) {
        NSUInteger nElements = count - i;
        NSUInteger n = (random() % nElements) + i;
        [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    return mutableArray;
}

+(NSArray*)getFirst:(NSInteger)count elementsFromArray:(NSArray*)array{
    NSMutableArray *newArray = [NSMutableArray array];
    
    count = MIN(count, array.count);
    
    for (NSUInteger i= 0; i < count; i++) {
        [newArray addObject:array[i]];
    }
    
    return newArray;
}

+(NSArray*)getLast:(NSInteger)count elementsFromArray:(NSArray*)array{
    NSMutableArray *newArray = [NSMutableArray array];
    
    if(array.count == 0){
        //return nothing
    }
    else if(array.count <= count){
        [newArray addObjectsFromArray:array];
    }else{
        for (NSInteger i = array.count - 1; i >= array.count - count; i--) {
            [newArray addObject:array[i]];
        }
    }
    
    return newArray;
}

+(void)addConstraintsToSuperView:(UIView*)mainView andSubView:(UIView*)subView withPadding:(CGFloat)padding{
    
    NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeTop multiplier:1.0 constant:padding];
    
    NSLayoutConstraint* left = [NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:padding];
    
    
    NSLayoutConstraint* right = [NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-padding];
    
    NSLayoutConstraint* bottom = [NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-padding];
    
    [mainView addConstraints:@[top, bottom, left, right]];
}


@end
