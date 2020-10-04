//
//  Utils.m
//  QuizApp
//
//  Created by Tope Abayomi on 23/01/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "Utils.h"
#import "Config.h"
#import <DasQuiz-Swift.h>

#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0]

@implementation Utils

+(CGFloat)getLastTestScore:(NSArray*)aggregates{
    
    CGFloat scorePercent = 0.0;
    if(aggregates.count > 0){
        
        ResultAggregate* aggregate = aggregates[aggregates.count - 1];
        scorePercent = aggregate.percent;
    }
    
    return scorePercent;
}

+(NSArray*)getLast:(NSInteger)count percentSolvedFromAggregates:(NSArray*)aggregates{
    
    NSMutableArray* scores = [NSMutableArray array];
    for(ResultAggregate* aggregate in aggregates){
        [scores addObject:@(aggregate.percent)];
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

/**
 Returns a list of all question categories
 */
+(NSArray<NSString*>*)categories {
    
    Questions *questions =  [Config sharedInstance].questions;
    
    NSMutableSet *categories = [NSMutableSet set];
    
    NSString *noCategory;
    
    for (Question *question in questions.listOfQuestions) {
        if (![categories containsObject:question.category]) {
            
            // Dont get empty categories
            if (question.category.length > 0) {
                if ([question.category hasPrefix:@"("]) {
                    // could be '(No category)'
                    noCategory = question.category;
                } else {
                    [categories addObject:question.category];
                }
            }
        }
    }
    return [categories allObjects];
}

#pragma mark Recent Questions
static NSMutableArray *_usedQuestions;

+(void)addAsUsedQuestion:(Question*)question {
    if (!_usedQuestions) {
        _usedQuestions = [NSMutableArray array];
    }
    
    [_usedQuestions addObject:question];
    
    // Remove first question if bucket is full
    if (_usedQuestions.count > 60) {
        [_usedQuestions removeObjectsAtIndexes:[NSIndexSet indexSetWithIndex:0]];
    }
}

+(void)clearAllUsedQuestions {
    if (_usedQuestions) {
        [_usedQuestions removeAllObjects];
    }
}

#pragma mark -
#pragma mark Load Questions

/*
 Sort and return questions
 */
+(void)sortQuestionsByLevel:(Questions*)questions
{
    NSArray <Question*>* shuffeldArray = [questions.listOfQuestions sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
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
    
    questions.listOfQuestions = shuffeldArray;
}

/*
 Shuffle questions and answers
 */
+(void)shuffleQuestions:(Questions*)questions
{
    static BOOL seedRandomGenerator = NO;
    if(!seedRandomGenerator)
    {
        seedRandomGenerator = YES;
        srandom((unsigned int)time(NULL));
    }
    
    questions.listOfQuestions = [self shuffleArray:questions.listOfQuestions];
    for (Question *question in questions.listOfQuestions) {
        question.answers = [self shuffleArray:question.answers];
    }
}

/**
 Shuffles any Array
 */
+(NSArray*) shuffleArray:(NSArray*) array {
    
    NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:array];
    NSUInteger count = array.count;
    for (NSUInteger i = 0; i < count; ++i) {
        NSUInteger nElements = count - i;
        NSUInteger n = (random() % nElements) + i;
        [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return mutableArray;
}

+(Questions*) loadQuestionsWithIncreasingLevel:(Questions *)questions forTotalNumberOfQuestions:(NSInteger)questionCount {
    
    Questions *questionsWithIncreasingLevel = [self loadQuestionsShuffeledFromTopics:questions
                                                           forTotalNumberOfQuestions:questionCount
                                                                            minLevel:0];
    
    [self sortQuestionsByLevel:questionsWithIncreasingLevel];
    return questionsWithIncreasingLevel;
}

+(Questions*) loadQuestionsShuffeledFromTopics:(Questions*)questions
                     forTotalNumberOfQuestions:(NSInteger)questionCount
                                      minLevel:(NSInteger)minLevel{
    
    Questions *allQuestions = [[Questions alloc] init];
    NSMutableArray *questionList = [NSMutableArray array];
    
    for (Question* question in questions.listOfQuestions) {
        if (question.level >= minLevel) {
            [questionList addObject:question];
        }
    }
    allQuestions.listOfQuestions = questionList;
    
    [self shuffleQuestions:allQuestions];
    
    // Reduce total number of questions
    if (questionCount > 0 ) {
        allQuestions.listOfQuestions = [NSMutableArray arrayWithArray:[self getFirst:questionCount elementsFromArray:allQuestions.listOfQuestions]];
    }
    
    // sort by level
    [self sortQuestionsByLevel:allQuestions];
    
    // Remove recently used questions
    if (_usedQuestions) {
        NSMutableArray* mutableArray = [NSMutableArray arrayWithArray: allQuestions.listOfQuestions];
        for (Question *question in _usedQuestions) {
            if ([mutableArray containsObject:question]) {
                [mutableArray removeObject:question];
            }
        }
        allQuestions.listOfQuestions = mutableArray;
    }
    return allQuestions;
}

+(Questions*) getFirst:(Questions*)questions numberOfQuestions:(NSInteger) numberOfQuestions{
    Questions* subQuestions = [[Questions alloc]init];
    subQuestions.listOfQuestions = [Utils getFirst:numberOfQuestions elementsFromArray:questions.listOfQuestions];
    return subQuestions;
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
