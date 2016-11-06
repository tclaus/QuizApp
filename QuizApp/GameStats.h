//
//  GameStats.h
//  DasQuiz
//
//  Created by Thorsten Claus on 16.10.16.
//  Copyright © 2016 Claus-Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Current Level and number of tries in this Level
 */
@interface GameStats : NSObject <NSCoding>

/**
 Returns the singelton for this class
 */
+ (instancetype)sharedInstance;


/**
 Current Level. Starts with 1 - maxlevel is 10
 */
@property (nonatomic) NSInteger currentLevel;

/**
 Number of successful tries in a row. After 3.try level Up!
 */
@property (nonatomic) NSInteger numberOfSuccessfulTries;

- (void)saveData;

/**
 Sets or gets last number of scores
 */
@property (nonatomic) NSInteger lastPoints;

/**
 Level up. If min number of tries succeed, then increase level. 
 @returns YES if next level was reached. No if player needs more succesful tries
 */
-(BOOL)levelUp;

/**
 Level Down. If failed number (= number tries) is >min number of tries. Then level down
 @returns YES if player looses a level.
 */
-(BOOL)levelDown;


@end
