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

@property (nonatomic, strong) NSArray*  answers;

@property (nonatomic, strong) NSString* explanation;

@property (nonatomic, strong) NSString* category;

@property (nonatomic) NSInteger level;

@property (nonatomic) NSInteger questionID;

/**
 Number of points for a correct question
 */
@property (NS_NONATOMIC_IOSONLY, readonly) CGFloat points;

-(BOOL)indexIsCorrectAnswer:(NSInteger)answerIndex;

-(BOOL)indexIsChosenAnswer:(NSInteger)answerIndex;

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL hasBeenAnsweredCorrectly;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary NS_DESIGNATED_INITIALIZER;

@end
