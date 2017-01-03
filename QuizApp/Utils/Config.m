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
    
    [self defineQuestionLanguage];
    
    NSDictionary* quizSettings = self.configInfo[@"Quiz Settings"];
    
    self.numberOfQuestionsToAnswer = [quizSettings[@"Number Of Questions To Answer"] integerValue];
    
    self.numberOfQuestionsToPractice = [quizSettings[@"Number of Questions To Practice"] integerValue];
    self.timeNeededInMinutes = [quizSettings[@"Time Needed In Minutes"] floatValue];
    self.passThreshold = [quizSettings[@"Pass Threshold"] integerValue];
    
    NSDictionary* gameCenterSettings = self.configInfo[@"Game Center Settings"];
    self.gameCenterEnabled = [gameCenterSettings[@"Game Center Enabled"] boolValue];

    self.gameCenterLeaderboardID = gameCenterSettings[@"Leaderboard ID"];
    self.gameCenterTimeBasedLeaderboardID = gameCenterSettings[@"Leaderboard ID Time Based"];
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
    self.quizIAP.numberOfFreeLevels = [quizIAPSettings[@"Number of free levels"] integerValue];
    
    // TODO: Hier A/B Test
    
    self.quizIAP.inAppPurchaseID = quizIAPSettings[@"In-App Purchase ID"];
    self.quizIAP.messageTitle = quizIAPSettings[@"IAP Alert Title"];
    self.quizIAP.messageText = quizIAPSettings[@"IAP Alert Message"];
    self.quizIAP.messageCancel = quizIAPSettings[@"IAP Alert Cancel"];
    self.quizIAP.messageBuy = quizIAPSettings[@"IAP Alert Buy"];
    
    
}

/**
 Set question topics in the right language
 */
-(void)defineQuestionLanguage{
    NSArray* topicsData = self.configInfo[@"Questions Data"];
    
    NSMutableArray* topics = [NSMutableArray arrayWithCapacity:topicsData.count];
    for (NSDictionary* topicDic in topicsData) {
        
        Topic* topic = [[Topic alloc] init];
        topic.title = topicDic[@"Topic Title"];
        topic.image = [UIImage imageNamed:topicDic[@"Topic Image"]];
        topic.inAppPurchaseIdentifier = topicDic[@"In App Purchase Identifier"];
        
        // Load questions according to the system Language
        // Then override it with the user preferences
        // question_language
        NSString* languageKey =   [[NSUserDefaults standardUserDefaults] stringForKey:@"question_language"];
        NSString* questionFilename;
        
        if (!languageKey) {
            
            // Store defualt language
            NSString *defaultLanguage = NSLocale.preferredLanguages[0];
            [[NSUserDefaults standardUserDefaults] setObject:defaultLanguage forKey:@"question_language"];
            
            questionFilename = topicDic[@"Questions File"];
        } else {
            questionFilename = [NSString stringWithFormat:@"1000-questions_%@.json",languageKey ];
        }
        
        
        topic.questionJSONObjects = [Datasource questionsFromFile:questionFilename];
        
        [topics addObject:topic];
    }
    
    self.topics = [NSArray arrayWithArray:topics];
}

-(NSArray*)getAllInAppPurchases{
    
    NSMutableArray* iaps = [NSMutableArray array];
    
    if(self.quizIAP.inAppPurchaseID && self.quizIAP.inAppPurchaseID.length > 0){
        [iaps addObject:self.quizIAP.inAppPurchaseID];
    }
    
    for (Topic*  topic in self.topics) {
        if(topic.inAppPurchaseIdentifier){
            [iaps addObject:topic.inAppPurchaseIdentifier];
        }
    }
    
    return iaps;
}

@end
