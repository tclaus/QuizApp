//
//  Utils.h
//  QuizApp
//
//  Created by Tope Abayomi on 23/01/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Questions;
@class Question;
@interface Utils : NSObject

+(CGFloat) calculateAverageTestScores:(NSArray*)aggregates;

+(CGFloat) getLastTestScore:(NSArray*)aggregates;

+(NSArray*) getLast:(NSInteger)count scoresFromAggregates:(NSArray*)aggregates;

+(NSArray*) getLast:(NSInteger)count labelsForAggregates:(NSArray*)aggregates;

+(Questions*) getFirst:(Questions*)questions numberOfQuestions:(NSInteger) numberOfQuestions;

/**
  Calculates the correct pecent from numberoftotal solced questions
 @param numberOfQuestions Number ob actually proceeded questions
 */
+(CGFloat) calculateCorrectPercent:(Questions*) questions;
+(NSInteger) calculateCorrectScore:(Questions*) questions;

+(NSInteger) calculateNumberOfCorrectAnswers:(Questions*)questions;

/**
 Returns a list of all question categories
 */
+(NSArray <NSString*>*) categories;

/**
 Add question as used question - will not be shown again until list is cleared
 */
+(void)addAsUsedQuestion:(Question*)question;

/**
 Clear recently used list
 */
+(void) clearAllUsedQuestions;

/**
 Loads topics and shuffels the questions to generate a list of newly shuffled questions. If questioncount is 0, then every possible question will beloaded.
 Sorted then by question levels
 */
+(Questions*) loadQuestionsWithIncreasingLevel:(Questions *)questions
                     forTotalNumberOfQuestions:(NSInteger)questionCount;

/**
 Loads topics and shuffels the questions to generate a list of newly shuffled questions. If questioncount is 0, then every possible question will beloaded.
 */
+(Questions*) loadQuestionsShuffeledFromTopics:(Questions*)questions
                     forTotalNumberOfQuestions:(NSInteger)questionCount
                                      minLevel:(NSInteger)minLevel;

+(void)addConstraintsToSuperView:(UIView*)mainView
                      andSubView:(UIView*)subView
                     withPadding:(CGFloat)padding;


@end
