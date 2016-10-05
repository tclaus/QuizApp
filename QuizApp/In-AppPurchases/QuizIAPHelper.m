//
//  QuizIAPHelper.m
//  QuizApp
//
//  Created by Valentin Filip on 24/05/14.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "QuizIAPHelper.h"
#import "Config.h"

@implementation QuizIAPHelper

+ (QuizIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static QuizIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        
        NSArray* identifers = [Config sharedInstance].allInAppPurchases;
        NSSet * productIdentifiers = [NSSet setWithArray:identifers];

        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
