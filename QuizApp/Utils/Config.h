//
//  Config.h
//  QuizApp
//
//  Created by Tope Abayomi on 03/02/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizInAppPurchaseData.h"
#import "TopicInAppPurchaseData.h"

@interface Config : NSObject

+ (Config *)sharedInstance;

@property (nonatomic, strong) NSArray* topics;

/**
 In a game model for fixed count of questions- this is the number of total questions to solve
 */
@property (nonatomic, assign) NSInteger numberOfQuestionsToAnswer;
/**
 In Training mode this is the number of question to train
 */
@property (nonatomic, assign) NSInteger numberOfQuestionsToPractice;
/**
 In a game mode- this can be the number of total question that needs to pass to win a game.
 Number must be smaller than 'numberOfQuestionsToAnswer'
 */
@property (nonatomic, assign) NSInteger passThreshold;

@property (nonatomic, strong) NSArray * gameCenterAchievements;
@property (nonatomic, strong) NSString* gameCenterLeaderboardID;
@property (nonatomic, strong) NSString* gameCenterTimeBasedLeaderboardID;
@property (nonatomic, strong) NSString* startPageTitle;
@property (nonatomic, strong) NSString* startPageDescription;
@property (nonatomic, strong) NSString* startPageSubDescription;
@property (nonatomic, strong) NSString* startPageImage;
@property (nonatomic, strong) NSString* mainFont;
@property (nonatomic, strong) NSString* boldFont;
@property (nonatomic, strong) NSString* mainBackground;

@property (nonatomic, strong) QuizInAppPurchaseData* quizIAP;
@property (nonatomic, strong) TopicInAppPurchaseData* topicIAP;

@property (nonatomic, assign) CGFloat timeNeededInMinutes;


@property (nonatomic, assign) BOOL gameCenterEnabled;
@property (nonatomic, assign) BOOL showTopicsinGrid;

@property (NS_NONATOMIC_IOSONLY, getter=getAllInAppPurchases, readonly, copy) NSArray *allInAppPurchases;

@end
