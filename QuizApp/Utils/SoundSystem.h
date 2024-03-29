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

+ (instancetype)sharedInstance;

-(void)playHappySound;
-(void)playFailureSound;
-(void)playLevelUpSound;
-(void)playTickSound;
-(void)playHeartBeatSound;
-(void)stopHeartBeatSound;

-(void)playThinkingMusic;
-(void)stopThinkingMusic;

-(void)playTimeOutSound;

-(void)vibrate;

@end
