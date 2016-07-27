//
//  SoundSystem.m
//  QuizApp
//
//  Created by Tope Abayomi on 27/02/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

//Ths Tick sound used below is used under the Attribution 3.0 license.
//Credit goes to DeepFrozenApps http://soundbible.com/2044-Tick.html


#import "SoundSystem.h"

@implementation SoundSystem

-(id)init{
    self = [super init];
    if(self){
        
        NSURL *sound   = [[NSBundle mainBundle] URLForResource: @"tick" withExtension: @"mp3"];
        self.soundFileURLRef = (__bridge CFURLRef)sound;
        AudioServicesCreateSystemSoundID (self.soundFileURLRef, &_soundFileObject);
    }
    
    return self;
}

-(void)playHappySound{
    AudioServicesPlaySystemSound (self.soundFileObject);
}

-(void)vibrate{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

- (void) dealloc {
    AudioServicesDisposeSystemSoundID (self.soundFileObject);
}


@end
