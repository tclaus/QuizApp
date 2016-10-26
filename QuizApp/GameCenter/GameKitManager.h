//
//  GameKitHelper.h
//  QuizApp
//
//  Created by Tope Abayomi on 11/02/2014.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GameKitManagerProtocol;

@interface GameKitManager : NSObject

@property (nonatomic, assign) id<GameKitManagerProtocol> delegate;

@property (nonatomic, readonly) NSError* lastError;

@property (nonatomic, readonly) NSMutableDictionary* achievements;

@property (nonatomic, readwrite) BOOL includeLocalPlayerScore;



+(id)sharedInstance;

-(void)authenticateLocalPlayer;

@property (NS_NONATOMIC_IOSONLY, readonly, strong) GKGameCenterViewController *createGameCenterViewController;

-(void)submitTestResult:(NSInteger)score forLeaderboard:(NSString*)leaderboardIdentifier;

/*
 Report fast question solver
 */
-(void)reportSpeedyAchievement:(CGFloat)percentScore secondsPerQuestion:(CGFloat)secondsPerQuestion;

/*
 Report quote of corect answers
 @param percentScore: float 0..1 that represents the percernt value
 */
-(void)reportAchievementsTestResult:(CGFloat)percentScore;

-(void)shareTestResult:(CGFloat)score forLeaderboard:(NSString*)leaderboardIdentifier;

-(void)showLeaderboard: (NSString*) leaderboardID;

/**
 Start hosting a match
 */
- (void)hostMatch;

-(void)loadScoresToChallenge;

-(void)findMyFriends;

-(void)getPlayerInfo:(NSArray*)playerList;

-(UIViewController*)challengePlayers: (NSArray*)players withScore:(int64_t)score andMessage:(NSString*)message;

@end

@protocol GameKitManagerProtocol <NSObject>

@optional

-(void)didLoadAchievements:(NSDictionary*)achievements;

-(void)didSubmitScores:(bool)success;

-(void)didReportAchievement:(GKAchievement*)achievement;

-(void)didLoadScoresToChallenge:(NSArray*) scores;

-(void)didReceiveFriendsList: (NSArray*) playerIDS;

-(void)didReceivePlayerInfo: (NSArray*)players;

-(void)didIssueChallengeWithController:(UIViewController*)controller;

-(void)didLoadChallenges:(NSArray*)challenges;

@end
