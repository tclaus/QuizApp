//
//  Question.h
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic, strong) NSString* text;

@property (nonatomic, strong) NSString* image;

@property (nonatomic, strong) NSArray* answers;

@property (nonatomic, strong) NSString* explanation;

@property (nonatomic, strong) NSString* category;

@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger numberOfCorrectAnswers;

-(BOOL)indexIsCorrectAnswer:(NSInteger)answerIndex;

-(BOOL)indexIsChosenAnswer:(NSInteger)answerIndex;

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL hasBeenAnsweredCorrectly;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
