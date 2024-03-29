//
//  GameKitHelper.m
//  QuizApp
//
//  Created by Tope Abayomi on 11/02/2014.
//
//

#import "GameKitManager.h"
#import "Config.h"

@interface GameKitManager () <GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate>

@property (nonatomic, assign) BOOL localPlayerAuthenticated;

@end

@implementation GameKitManager

+(id) sharedInstance {
    static GameKitManager *sharedGameKitManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitManager = [[GameKitManager alloc] init];
        sharedGameKitManager.includeLocalPlayerScore = NO;
    });
    return sharedGameKitManager;
}

-(void) authenticateLocalPlayer {
    
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    __weak GKLocalPlayer *blockLocalPlayer = localPlayer;
    localPlayer.authenticateHandler = ^(UIViewController *viewController,
                                        NSError *error) {
        [self setLastError:error];
        
        if (blockLocalPlayer.authenticated) {
            self->_localPlayerAuthenticated = YES;
            [self loadChallenges];
        } else if(viewController) {
            [self presentViewController:viewController];
        } else {
            self->_localPlayerAuthenticated = NO;
        }
    };
}

-(void)setLastError:(NSError*)error {

    if (error) {
        _lastError = [error copy];
        // TODO Send error
        NSLog(@"GameKitManager: Error: %@", _lastError.userInfo.description);
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    
    [self dismissModalViewController];
}

-(UIViewController*) getRootViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc {
    
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES completion:nil];
}


-(void)dismissModalViewController {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

-(GKGameCenterViewController*)createGameCenterViewController{
    
    GKGameCenterViewController *gameCenterViewController = [[GKGameCenterViewController alloc] init];
    gameCenterViewController.gameCenterDelegate = self;
    gameCenterViewController.viewState = GKGameCenterViewControllerStateDefault;
    
    return gameCenterViewController;
}

-(void)submitTestResult:(NSInteger)score forLeaderboard:(NSString*)leaderboardIdentifier {
    
    if (!_localPlayerAuthenticated) {
        NSLog(@"Player not authenticated");
        return;
    }
    
    if (leaderboardIdentifier) {
    int64_t intScore = (int64_t)score;
    
    GKScore* gkScore = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardIdentifier];
    gkScore.value = intScore;
    
    [GKScore reportScores:@[gkScore] withCompletionHandler:^(NSError *error) {
        [self setLastError:error];
        BOOL success = (error == nil);
        
        if([self->_delegate respondsToSelector:@selector(didSubmitScores:)])
            [self->_delegate didSubmitScores:success];
    }];
    } else {
        NSLog(@"leaderboardIdentifier was null or empty casnt not sumbit highscores to gamecenter");
    }
}

-(void) loadAchievements {
    
    if (!_localPlayerAuthenticated) {
        NSLog(@"Player not authenticated"); return;
    }
    
    [GKAchievement loadAchievementsWithCompletionHandler:
     ^(NSArray* loadedAchievements, NSError* error) {
         
         [self setLastError:error];
        if (self->_achievements == nil) {
            self->_achievements = [[NSMutableDictionary alloc] init];
         } else {
             [self->_achievements removeAllObjects];
         }
         
         for (GKAchievement* achievement in loadedAchievements) {
             achievement.showsCompletionBanner = YES;
             self->_achievements[achievement.identifier] = achievement;
         }
        
        if([self->_delegate respondsToSelector:@selector(didLoadAchievements:)])
            [self->_delegate didLoadAchievements:self->_achievements];
     }];
}

-(void)loadChallenges{
 
    if (!_localPlayerAuthenticated) {
        NSLog(@"Player not authenticated");
        return;
    }
    
    [GKChallenge loadReceivedChallengesWithCompletionHandler:^(NSArray *challenges, NSError *error) {
        if (challenges){
            
            if([self->_delegate respondsToSelector:@selector(didLoadChallenges:)])
                [self->_delegate didLoadChallenges:challenges];
        }
    }];
}

// SpeedyQuiz
/**
 Quiz was solved in a record time
 */
-(void)reportSpeedAchievement{
    
    if (!_localPlayerAuthenticated){
        NSLog(@"Player not authenticated");
        return;
    }
    
    GKAchievement* achievement = [self getAchievementByID:@"SpeedyQuiz"];
    achievement.percentComplete = 100;
    
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            [self setLastError:error];
            
            if([self->_delegate respondsToSelector:@selector(didReportAchievement:)])
                [self->_delegate didReportAchievement:achievement];
        }];
}

-(void)reportAchievementWithID:(NSString*)identifier percentComplete:(float)percent{
    
    if (!_localPlayerAuthenticated){
        NSLog(@"Player not authenticated");
        return;
    }
    
    GKAchievement* achievement = [self getAchievementByID:identifier];
    
    if (achievement.percentComplete < percent) {
        
        achievement.percentComplete = percent;
        
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            [self setLastError:error];
            
            if([self->_delegate respondsToSelector:@selector(didReportAchievement:)])
                [self->_delegate didReportAchievement:achievement];
        }];
    }
}

-(GKAchievement*)getAchievementByID: (NSString*)identifier {
    
    GKAchievement* achievement = _achievements[identifier];
    
    if (achievement == nil) {
        
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        achievement.showsCompletionBanner = YES;
        _achievements[achievement.identifier] = achievement;
    }
    
    return achievement;
}

-(void)reportSpeedyAchievement:(CGFloat)percentScore secondsPerQuestion:(CGFloat)secondsPerQuestion {
    
    if (percentScore >= 0.9) {
        if (secondsPerQuestion <= 4) { // es soll ja hart sein..
            [self reportSpeedAchievement];
        }
    }
}

-(void)reportAchievementsTestResult:(CGFloat)percentScore {

    NSArray* achievements = [Config sharedInstance].gameCenterAchievements;
    
    for (NSDictionary *achievement in achievements) {
        NSString *achievementId = achievement[@"Achievement ID"];
        NSNumber *percentNeeded = achievement[@"Percent Score Needed"];
        float percentComplete = (percentScore * 100 / percentNeeded.intValue) * 100;
        
        if(percentComplete > 100){
            percentComplete = 100;
        }
        
        [self reportAchievementWithID:achievementId percentComplete:percentComplete];
        
    }
}

-(void)shareTestResult:(CGFloat)score forLeaderboard:(NSString*)leaderboardIdentifier{

    GKScore* gkScore = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardIdentifier];
    gkScore.value = (int64_t)score;

    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                               initWithActivityItems:@[gkScore] applicationActivities:nil];
    
    activityViewController.completionWithItemsHandler = ^(NSString * activityType, BOOL completed, NSArray * returnedItems, NSError * activityError){
        
        if (completed)
            [self dismissModalViewController];
        
    };

    [self presentViewController: activityViewController];
}

- (void) showLeaderboard: (NSString*) leaderboardID
{
    GKGameCenterViewController *gameCenterController = self.createGameCenterViewController;
    
    if (gameCenterController != nil)
    {
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeAllTime;
        gameCenterController.leaderboardIdentifier = leaderboardID;
        [self presentViewController:gameCenterController];
    }
}

- (void)hostMatch
{
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    
    [self presentViewController:mmvc];
}

-(void)loadScoresToChallenge {
    
    GKLeaderboard* leaderboard = [[GKLeaderboard alloc] init];
    leaderboard.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
    leaderboard.range = NSMakeRange(1, 100);
    leaderboard.identifier = [Config sharedInstance].gameCenterLeaderboardID;
    
    [leaderboard loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
        
        [self setLastError:error];
        BOOL success = (error == nil);
        if (success) {
            if (!self->_includeLocalPlayerScore) {
                
                NSMutableArray *friendsScores = [NSMutableArray array];
                for (GKScore *score in scores) {
                    if (![score.player.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
                        [friendsScores addObject:score]; }
                }
                scores = friendsScores;
            }

            if([self->_delegate respondsToSelector:@selector(didLoadScoresToChallenge:)])
                [self->_delegate didLoadScoresToChallenge:scores];
        }
    }];
}

- (void)findMyFriends
{
    GKLocalPlayer *lp = [GKLocalPlayer localPlayer];
    if (lp.authenticated){
        
        
        [lp loadChallengableFriendsWithCompletionHandler:^(NSArray<GKPlayer *> * _Nullable challengableFriends, NSError * _Nullable error) {
            [self setLastError:error];
            if (challengableFriends != nil){
                
                if([self->_delegate respondsToSelector:@selector(didReceiveFriendsList:)])
                    [self->_delegate didReceiveFriendsList:challengableFriends];
            }
        }];
    
    }
}

-(void)getPlayerInfo:(NSArray*)playerList {
    
    if(!_localPlayerAuthenticated || playerList.count == 0){
        return;
    }
    
    [GKPlayer loadPlayersForIdentifiers:playerList withCompletionHandler:^(NSArray* players, NSError* error) {
        [self setLastError:error];
        
        if([self->_delegate respondsToSelector:@selector(didReceivePlayerInfo:)])
            [self->_delegate didReceivePlayerInfo:players];
    }];
}

-(UIViewController*)challengePlayers: (NSArray*)players withScore:(int64_t)score andMessage:(NSString*)message {
    
    GKScore *gkScore =[[GKScore alloc] initWithLeaderboardIdentifier:[Config sharedInstance].gameCenterLeaderboardID];
    
    gkScore.value = score;
   /* UIViewController* controller = [gkScore challengeComposeControllerWithPlayers:players message:message completionHandler:^(UIViewController *composeController, BOOL didIssueChallenge, NSArray *sentPlayerIDs) {
        NSLog(@"challenge issues %d", didIssueChallenge);
        
        if([_delegate respondsToSelector:@selector(didIssueChallengeWithController:)])
            [_delegate didIssueChallengeWithController:composeController];
    }];*/
    
    
    UIViewController* controller = [gkScore challengeComposeControllerWithMessage:message players:players completionHandler:^(UIViewController * _Nonnull composeController, BOOL didIssueChallenge, NSArray<NSString *> * _Nullable sentPlayerIDs) {
       
        NSLog(@"challenge issues %d", didIssueChallenge);
        
        if([self->_delegate respondsToSelector:@selector(didIssueChallengeWithController:)])
            [self->_delegate didIssueChallengeWithController:composeController];
        
    }];
    
    return controller;

}


- (void)matchmakerViewController:(nonnull GKMatchmakerViewController *)viewController didFailWithError:(nonnull NSError *)error {
    NSLog(@"Match Maker did fail with error: %@", error);
}

- (void)matchmakerViewControllerWasCancelled:(nonnull GKMatchmakerViewController *)viewController {
    NSLog(@"matchmaker was canceled");
}

@end
