//
//  Question.m
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "Question.h"
#import "Answer.h"

@implementation Question

-(instancetype)initWithDictionary:(NSDictionary*)dictionary{

    self = [super init];
    if(self){
        self.text = dictionary[@"text"];
        self.image = dictionary[@"image"];
        self.explanation = dictionary[@"explanation"];
        self.category = dictionary[@"category"];
        
        NSArray* answerArray = dictionary[@"answers"];
        NSMutableArray* answersTmpArray = [NSMutableArray array];
        
        for (NSDictionary* answerDictionary in answerArray) {
            Answer* answer = [[Answer alloc] initWithDictionary:answerDictionary];
            [answersTmpArray addObject:answer];
        }
        
        self.answers = [NSArray arrayWithArray:answersTmpArray];
    }
    return self;
}

-(NSInteger)numberOfCorrectAnswers{
    
    NSInteger correctCount = 0;
    
    for (Answer* answer in self.answers) {
        if(answer.correct){
            correctCount++;
        }
    }
    return correctCount;
}

-(BOOL)indexIsCorrectAnswer:(NSInteger)answerIndex{
    
    if(answerIndex < self.answers.count){
        Answer* answer = self.answers[answerIndex];
        return answer.correct;
    }
    
    return NO;
}

-(BOOL)indexIsChosenAnswer:(NSInteger)answerIndex{
    
    if(answerIndex < self.answers.count){
        Answer* answer = self.answers[answerIndex];
        return answer.chosen;
    }
    
    return NO;
}

-(BOOL)hasBeenAnsweredCorrectly{
    
    int correctAnswersFound = 0;
    for (Answer* answer in self.answers) {
        if(answer.correct && answer.chosen){
            correctAnswersFound++;
        }
    }
    
    return correctAnswersFound == self.numberOfCorrectAnswers;
}

@end
