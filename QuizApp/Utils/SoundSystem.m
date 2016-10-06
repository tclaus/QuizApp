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
    Sound *_heardBeatSound;
    ///
    Sound *_timeOutSound;
    
}

-(instancetype)init{
    self = [super init];
    if(self){
    
        _heardBeatSound = [Sound soundNamed:@"heartbeat.mp3"];
        _heardBeatSound.baseVolume = 0.2f;
        
        _tickSound = [Sound soundNamed:@"tick.mp3"];
        _happySound = [Sound soundNamed:@"rightquestion.mp3"];
        _timeOutSound = [Sound soundNamed:@"timeout.mp3"];
        _failureSound = [Sound soundNamed:@"wrong.m4a"];
    }
    
    return self;
}

-(void)playHappySound{
    [_happySound play];
}

-(void)playFailureSound{
    [_failureSound play];
}

-(void)playTickSound{
    [_tickSound play];
}

-(void)playHeadBeatSound{
    // 30 Sec loop
    [[SoundManager sharedManager] playSound:_heardBeatSound looping:YES];
}

-(void)stopHeardBeatSound{
    [[SoundManager sharedManager] stopSound:_heardBeatSound];
}

-(void)playTimeOutSound{
    [_timeOutSound play];
}


-(void)vibrate{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

- (void) dealloc {
    
}


@end
