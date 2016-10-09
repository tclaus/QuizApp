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

+(CGFloat)calculateCorrectPercent:(NSArray*)questions{
    
    CGFloat fractionCorrect = 0.0;
    
    if(questions.count  > 0){
        
        NSInteger correctCount = [self calculateNumberOfCorrectAnswers:questions];
        fractionCorrect = correctCount/(CGFloat)questions.count;
    }
    
    
    return fractionCorrect;
}

+(NSInteger)calculateCorrectScore:(NSArray*)questions{
    
    NSInteger fractionCorrect = 0;
    
    if(questions.count  > 0){
        for (Question* question in questions) {
            if(question.hasBeenAnsweredCorrectly){
                fractionCorrect = fractionCorrect + question.points ;
            }
        }
    }
    
    
    return fractionCorrect;
}

+(NSInteger)calculateNumberOfCorrectAnswers:(NSArray*)questions{
    
    NSInteger correctCount = 0;

    if(questions.count  > 0){
        for (Question* question in questions) {
            if(question.hasBeenAnsweredCorrectly){
                correctCount++;
            }
        }
    }

    return correctCount;
}

/**
 Loads the free number of questions for the given topic
 */
+(NSArray*)loadFreeQuestionsForTopic:(Topic*)topic{
    // For base Topic: get a list of questions
    // For all other (future) topics - all questions
    
    NSMutableArray *allQuestions = [NSMutableArray array];
    
        for (NSDictionary* questionDic in topic.questionJSONObjects) {
            [allQuestions addObject:questionDic];
        }
    
    NSArray* shuffledQuestions = [self shuffleArray:allQuestions];
    NSArray* batch = [self getFirst:[Config sharedInstance].quizIAP.numberofFreeQuestions elementsFromArray:shuffledQuestions];
    
    return batch;
}

+(NSArray*)loadQuestionsWithIncreasingLevelFromTopics:(NSArray *)selectedTopics forTotalNumberOfQuestions:(NSInteger)questionCount {
    NSArray *questions = [self loadQuestionsFromTopics:selectedTopics forTotalNumberOfQuestions:questionCount];
    
   questions = [questions sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
       Question *q1 = obj1;
       Question *q2 = obj2;
       
       if (q1.level == q2.level) {
           return NSOrderedSame;
       }
       
       if (q1.level > q2.level) {
           return NSOrderedDescending;
       }
       
       if (q1.level < q2.level) {
           return NSOrderedAscending;
       }
       
       return NSOrderedSame;
       
   }];
    
    
    return questions;
    
    
}

+(NSArray*)loadQuestionsFromTopics:(NSArray*)selectedTopics forTotalNumberOfQuestions:(NSInteger)questionCount{
    
    NSMutableArray *allQuestions = [NSMutableArray array];
    for (Topic* topic in selectedTopics) {
        
        if (!topic.inAppPurchaseIdentifier) { // Base questions, just get a subset of questions until bought
            
            for (NSDictionary* questionDic in [self loadFreeQuestionsForTopic:topic]) {
                Question* question = [[Question alloc] initWithDictionary:questionDic];
                [allQuestions addObject:question];
            }
        } else { // For all other topics get all other qustions
            for (NSDictionary* questionDic in topic.questionJSONObjects) {
                Question* question = [[Question alloc] initWithDictionary:questionDic];
                [allQuestions addObject:question];
            }
        }
        
    }
    
    NSArray* shuffledQuestions = [self shuffleArray:allQuestions];
    NSArray* batch;
    if (questionCount > 0 ) {
        batch = [self getFirst:questionCount elementsFromArray:shuffledQuestions];
    } else {
        batch = [NSArray arrayWithArray:shuffledQuestions];
    }
    
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
