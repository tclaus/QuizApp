//
//  SoundSystem.h
//  QuizApp
//
//  Created by Tope Abayomi on 27/02/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SoundSystem : NSObject

@property (readwrite)   CFURLRef        soundFileURLRef;
@property (readonly)    SystemSoundID   soundFileObject;

-(void)playHappySound;
-(void)vibrate;

@end
