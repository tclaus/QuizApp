//
//  ResultAggregate.m
//  QuizApp
//
//  Created by Tope Abayomi on 22/01/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "ResultAggregate.h"

@implementation ResultAggregate

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.date = [aDecoder decodeObjectForKey:@"date"];
    self.percent = [aDecoder decodeFloatForKey:@"percent"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeFloat:self.percent forKey:@"percent"];
}

@end
