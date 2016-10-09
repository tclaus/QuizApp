//
//  Utils.h
//  QuizApp
//
//  Created by Tope Abayomi on 23/01/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(CGFloat)calculateAverageTestScores:(NSArray*)aggregates;

+(CGFloat)getLastTestScore:(NSArray*)aggregates;

+(NSArray*)getLast:(NSInteger)count scoresFromAggregates:(NSArray*)aggregates;

+(NSArray*)getLast:(NSInteger)count labelsForAggregates:(NSArray*)aggregates;

/**
  Calculates the correct pecent from numberoftotal solced questions
 @param numberOfQuestions Number ob actually proceeded questions
 */
+(CGFloat)calculateCorrectPercent:(NSArray*)questions;
+(NSInteger)calculateCorrectScore:(NSArray*)questions;

+(NSInteger)calculateNumberOfCorrectAnswers:(NSArray*)questions;

/**
 Loads topics and shuffels the questions to generate a list of newly shuffled questions. If questioncount is 0, then every possible question will beloaded.
 Sorted then by question levels
 */
+(NSArray*)loadQuestionsWithIncreasingLevelFromTopics:(NSArray *)selectedTopics forTotalNumberOfQuestions:(NSInteger)questionCount;

/**
 Loads topics and shuffels the questions to generate a list of newly shuffled questions. If questioncount is 0, then every possible question will beloaded.
 */
+(NSArray*)loadQuestionsFromTopics:(NSArray*)selectedTopics forTotalNumberOfQuestions:(NSInteger)questionCount;

+(void)addConstraintsToSuperView:(UIView*)mainView andSubView:(UIView*)subView withPadding:(CGFloat)padding;


@end
