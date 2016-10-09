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

+(CGFloat)calculateCorrectPercent:(NSArray*)questions;
+(CGFloat)calculateCorrectScore:(NSArray*)questions;

+(NSInteger)calculateNumberOfCorrectAnswers:(NSArray*)questions;

/**
 Loads topics and shuffels the questions to generate a list of newly shuffled questions
 */
+(NSArray*)loadQuestionsFromTopics:(NSArray*)selectedTopics forTotalNumberOfQuestions:(NSInteger)questionCount;

+(void)addConstraintsToSuperView:(UIView*)mainView andSubView:(UIView*)subView withPadding:(CGFloat)padding;


@end
