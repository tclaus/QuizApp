//
//  GameModel.m
//  DasQuiz
//
//  Created by Thorsten Claus on 07.10.16.
//  Copyright © 2016 Claus-Software. All rights reserved.
//

#import "GameModel.h"
#import "Config.h"

@implementation GameModel {
    GameModes _gameMode;
}

+ (GameModel *)sharedInstance
{
    static dispatch_once_t once;
    static GameModel *sharedInstance;
    dispatch_once(&once, ^{
        
        sharedInstance = [[GameModel alloc] init];
    });
    
    return sharedInstance;
}

-(GameModes)activeGameMode {
    return _gameMode;
}

-(void)setActiveGameMode:(GameModes)mode {
    _gameMode = mode;
    switch (mode) {
        case GameModeTimeBasedCompetition:
            _gameTime = [Config sharedInstance].timeNeededInMinutes * 60;
            _numberOfQuestions = 0;
            _mixedLevels = NO;
            _publishHighScores = NO;
            _suddenDeath = NO;
            break;
            
        case GameModeTrainig:
            _gameTime = 0;
            _numberOfQuestions = [Config sharedInstance].numberOfQuestionsToPractice;
            _mixedLevels = YES;
            _publishHighScores = YES;
            _suddenDeath = NO;
            break;
    }
    
}

@end
