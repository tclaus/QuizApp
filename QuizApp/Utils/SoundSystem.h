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


-(void)playHappySound;
-(void)playFailureSound;
-(void)playTickSound;
-(void)playHeadBeatSound;
-(void)stopHeardBeatSound;
-(void)playTimeOutSound;

-(void)vibrate;

@end
