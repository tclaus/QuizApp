//
//  GameModel.h
//  DasQuiz
//
//  Created by Thorsten Claus on 07.10.16.
//  Copyright © 2016 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject


typedef NS_ENUM(NSUInteger, GameModes) {
    GameModeTimeBasedCompetition,
    GameModeTrainig
};

+ (GameModel *)sharedInstance;

/**
 Sets or gets the active Gamemode
 */
@property (nonatomic) GameModes activeGameMode;

/**
 Time in seconds to Play 0..x, Maximale Zielzeit. 0 ohne Beschränkung
 */
@property (readonly, nonatomic) int gameTime;

/**
  Anzahl Fragen 0= Unbegrenzt. GameTime UND CounTQustions dürfen nicht beide 0 sein.
 */
@property (readonly, nonatomic) NSInteger numberOfQuestions;

// MixedLevels YES/NO, Gemischte Schwierigkeit (YES) oder Aufsteigend
@property (readonly, nonatomic) BOOL mixedLevels;

// PublishHighScores
@property (readonly, nonatomic) BOOL publishHighScores;



@end
