//
//  Answer.m
//  QuizApp
//
//  Created by Tope Abayomi on 28/01/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "Answer.h"

@implementation Answer

-(id)initWithDictionary:(NSDictionary*)dictionary{
    
    self = [super init];
    if(self){
        self.text = dictionary[@"text"];
        self.image = dictionary[@"image"];
        NSNumber* correct = dictionary[@"correct"];
        self.correct = [correct intValue] == 1 ? YES : NO;
        
        NSNumber* chosen = dictionary[@"chosen"];
        self.chosen = [chosen intValue] == 1 ? YES : NO;
    }
    return self;
}

@end
