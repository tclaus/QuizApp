//
//  SoundSystem.m
//  QuizApp
//
//  Created by Tope Abayomi on 27/02/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

//Ths Tick sound used below is used under the Attribution 3.0 license.
//Credit goes to DeepFrozenApps http://soundbible.com/2044-Tick.html
//
// Other sounds are buyed from http://Audiojungle.net

#import "SoundSystem.h"
#import "SoundManager.h"

@implementation SoundSystem {
    
    
    /// Plays for a correct question
    Sound *_happySound;
    /// Plays for incorrect question
    Sound *_failureSound;
    /// A tick for the last seconds
    Sound *_tickSound;
    
    /// Heardbeat - during time based play
    Sound *_heartBeatSound;
    ///
    Sound *_timeOutSound;
 
    Sound *_thinkingMusic;
    
    Sound *_levelUpSound;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
    self = [super init];
    if(self){
    
        _heartBeatSound = [Sound soundNamed:@"heartbeat.mp3"];
        _heartBeatSound.baseVolume = 0.2f;
        
        _tickSound = [Sound soundNamed:@"tick.mp3"];
        _happySound = [Sound soundNamed:@"rightquestion.mp3"];
        _timeOutSound = [Sound soundNamed:@"timeout.mp3"];
        _failureSound = [Sound soundNamed:@"wrong.m4a"];
        _thinkingMusic = [Sound soundNamed:@"thinking.mp3"];
        _levelUpSound = [Sound soundNamed:@"levelup.m4a"];
        
    }
    
    return self;
}

-(void)playHappySound{
    [_happySound play];
}

-(void)playFailureSound{
    [_failureSound play];
}

-(void)playLevelUpSound{
    [_levelUpSound play];
}

-(void)playTickSound{
    [_tickSound play];
}

-(void)playHeartBeatSound{
    // 30 Sec loop
    [[SoundManager sharedManager] playSound:_heartBeatSound looping:YES];
}

-(void)stopHeartBeatSound{
    [[SoundManager sharedManager] stopSound:_heartBeatSound];
}

-(void)playTimeOutSound{
    [_timeOutSound play];
}

-(void)playThinkingMusic{
    [[SoundManager sharedManager] playMusic:_thinkingMusic looping:YES];
}

-(void)stopThinkingMusic {
    [[SoundManager sharedManager] stopMusic];
}

-(void)vibrate{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

- (void) dealloc {
    
}


@end
