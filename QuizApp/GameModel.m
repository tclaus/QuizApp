//
//  GameModel.m
//  DasQuiz
//
//  Created by Thorsten Claus on 07.10.16.
//  Copyright © 2016 Claus-Software. All rights reserved.
//

#import "GameModel.h"

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

-(GameModes)gameModes {
    return _gameMode;
}

-(void)setGameMode:(GameModes)mode {
    _gameMode = mode;
    switch (mode) {
        case GameModeTimeBasedCompetition:
            _gameTime = 0;
            _countQuestions = 50;
            _mixedLevels = NO;
            _publishHighScores = NO;
            break;
            
        case GameModeTrainig:
            _gameTime = 5 * 60;
            _countQuestions = 0;
            _mixedLevels = YES;
            _publishHighScores = YES;
    }
    
}

@end
