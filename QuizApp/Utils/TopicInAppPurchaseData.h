//
//  TopicInAppPurchaseData.h
//  QuizApp
//
//  Created by Tope Abayomi on 31/07/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicInAppPurchaseData : NSObject

@property (nonatomic, assign) BOOL limitTopics;
@property (nonatomic, strong) NSString* inAppPurchaseID;
@property (nonatomic, strong) NSString* messageTitle;
@property (nonatomic, strong) NSString* messageText;
@property (nonatomic, strong) NSString* messageBuy;
@property (nonatomic, strong) NSString* messageBuyAll;
@property (nonatomic, strong) NSString* messageCancel;


@end
