//
//  Topic.h
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Topic : NSObject

@property (nonatomic, strong) NSString* title;

@property (nonatomic, strong) UIImage* image;

@property (nonatomic, strong) NSArray* questionJSONObjects;

@property (nonatomic, strong) NSString* inAppPurchaseIdentifier;

@end
