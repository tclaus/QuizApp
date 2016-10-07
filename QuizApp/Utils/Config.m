//
//  Config.m
//  QuizApp
//
//  Created by Tope Abayomi on 03/02/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "Config.h"
#import "Topic.h"
#import "Datasource.h"

@interface Config ()

-(void)loadInfo;

@property (nonatomic, strong) NSDictionary* configInfo;

@end

@implementation Config


+ (Config *)sharedInstance
{
    static dispatch_once_t once;
    static Config *sharedInstance;
    dispatch_once(&once, ^{
        
        sharedInstance = [[Config alloc] init];
        [sharedInstance loadInfo];
    });
    return sharedInstance;
}

-(void)loadInfo{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    
    self.configInfo = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSArray* topicsData = self.configInfo[@"Questions Data"];
    
    NSMutableArray* topics = [NSMutableArray arrayWithCapacity:topicsData.count];
    for (NSDictionary* topicDic in topicsData) {
     
        Topic* topic = [[Topic alloc] init];
        topic.title = topicDic[@"Topic Title"];
        topic.image = [UIImage imageNamed:topicDic[@"Topic Image"]];
        topic.inAppPurchaseIdentifier = topicDic[@"In App Purchase Identifier"];
        topic.questionJSONObjects = [Datasource questionsFromFile:topicDic[@"Questions File"]];
        [topics addObject:topic];
    }
    
    self.topics = [NSArray arrayWithArray:topics];
    
    NSDictionary* quizSettings = self.configInfo[@"Quiz Settings"];
    
    self.numberOfQuestionsToAnswer = [quizSettings[@"Number Of Questions To Answer"] integerValue];
    
    self.numberOfQuestionsToPractice = [quizSettings[@"Number of Questions To Practice"] integerValue];
    self.isTimedQuiz = [quizSettings[@"Is Timed Quiz"] boolValue];
    self.timeNeededInMinutes = [quizSettings[@"Time Needed In Minutes"] floatValue];
    self.passThreshold = [quizSettings[@"Pass Threshold"] integerValue];
    
    NSDictionary* gameCenterSettings = self.configInfo[@"Game Center Settings"];
    self.gameCenterEnabled = [gameCenterSettings[@"Game Center Enabled"] boolValue];

    self.gameCenterLeaderboardID = gameCenterSettings[@"Leaderboard ID"];
    self.gameCenterAchievements = gameCenterSettings[@"Achievements"];
    
    NSDictionary* interfaceSettings = self.configInfo[@"Interface Settings"];
    self.mainFont = interfaceSettings[@"Main Font"];
    self.boldFont = interfaceSettings[@"Bold Font"];
    self.mainBackground = interfaceSettings[@"Main Background"];
    self.startPageTitle = interfaceSettings[@"Start Page Title"];
    self.startPageDescription = interfaceSettings[@"Start Page Description"];
    self.startPageSubDescription = interfaceSettings[@"Start Page Sub Description"];
    self.startPageImage = interfaceSettings[@"Start Page Image"];
    self.showTopicsinGrid = [interfaceSettings[@"Show Topics in Grid"] boolValue];
    
    
    
    NSDictionary* quizIAPSettings = self.configInfo[@"In App Purchase Settings"];
    
    self.quizIAP = [[QuizInAppPurchaseData alloc] init];
    
    self.quizIAP.limitQuestions = [quizIAPSettings[@"Limit Number of Questions"] boolValue];
    self.quizIAP.numberofFreeQuestions = [quizIAPSettings[@"Number of Free Questions"] integerValue];
    self.quizIAP.numberofFreeQuizzes = [quizIAPSettings[@"Number of Free Quizzes"] integerValue];
    self.quizIAP.inAppPurchaseID = quizIAPSettings[@"In-App Purchase ID"];
    self.quizIAP.messageTitle = quizIAPSettings[@"IAP Alert Title"];
    self.quizIAP.messageText = quizIAPSettings[@"IAP Alert Message"];
    self.quizIAP.messageCancel = quizIAPSettings[@"IAP Alert Cancel"];
    self.quizIAP.messageBuy = quizIAPSettings[@"IAP Alert Buy"];
    
    
    NSDictionary* topicIAPSettings = self.configInfo[@"Topic Purchase Settings"];
    
    self.topicIAP = [[TopicInAppPurchaseData alloc] init];
    
    self.topicIAP.limitTopics = [topicIAPSettings[@"Limit Topics"] boolValue];
    self.topicIAP.inAppPurchaseID = topicIAPSettings[@"In-App Purchase ID"];
    self.topicIAP.messageTitle = topicIAPSettings[@"IAP Alert Title"];
    self.topicIAP.messageText = topicIAPSettings[@"IAP Alert Message"];
    self.topicIAP.messageCancel = topicIAPSettings[@"IAP Alert Cancel"];
    self.topicIAP.messageBuy = topicIAPSettings[@"IAP Alert Buy"];
    self.topicIAP.messageBuyAll = topicIAPSettings[@"IAP Alert Buy All"];

}

-(NSArray*)getAllInAppPurchases{
    
    NSMutableArray* iaps = [NSMutableArray array];
    
    if(self.quizIAP.inAppPurchaseID && self.quizIAP.inAppPurchaseID.length > 0){
        [iaps addObject:self.quizIAP.inAppPurchaseID];
    }
    
    if(self.topicIAP.inAppPurchaseID && self.topicIAP.inAppPurchaseID.length > 0){
        [iaps addObject:self.topicIAP.inAppPurchaseID];
    }
    
    for (Topic*  topic in self.topics) {
        if(topic.inAppPurchaseIdentifier){
            [iaps addObject:topic.inAppPurchaseIdentifier];
        }
    }
    
    return iaps;
}

@end
