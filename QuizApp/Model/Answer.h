//
//  Answer.h
//  QuizApp
//
//  Created by Tope Abayomi on 28/01/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answer : NSObject

@property (nonatomic, strong) NSString* text;

@property (nonatomic, strong) NSString* image;

@property (nonatomic, assign) BOOL correct;

@property (nonatomic, assign) BOOL chosen;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary NS_DESIGNATED_INITIALIZER;
@end
