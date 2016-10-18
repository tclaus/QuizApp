//
//  GameStats.m
//  DasQuiz
//
//  Created by Thorsten Claus on 16.10.16.
//  Copyright © 2016 Claus-Software. All rights reserved.
//

#import "GameStats.h"

#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0]


@implementation GameStats

int maxNumberOfTries = 3;
int maxLevel = 10;


+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance loadData];
    });
    return sharedInstance;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.currentLevel forKey:@"currentLevel"];
    [encoder encodeInteger:self.numberOfSuccessfulTries forKey:@"numberOfSuccessfulTries"];
    [encoder encodeInteger:self.numberOfFailues forKey:@"numberOfFailues"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.currentLevel = [aDecoder decodeIntegerForKey:@"currentLevel"];
    self.numberOfSuccessfulTries = [aDecoder decodeIntegerForKey:@"numberOfSuccessfulTries"];
    self.numberOfFailues = [aDecoder decodeIntegerForKey:@"numberOfFailues"];
    
    if (self.currentLevel == 0) {
        self.currentLevel = 1;
    }
    
    return self;
    
}

-(void)loadData{
    NSString *resultsStoragePath = [DocumentsDirectory stringByAppendingPathComponent:@"gameStats.plist"];
    GameStats *loadedStats = [NSKeyedUnarchiver unarchiveObjectWithFile:resultsStoragePath];

    self.currentLevel = loadedStats.currentLevel;
    self.numberOfFailues = loadedStats.numberOfFailues;
    self.numberOfSuccessfulTries = loadedStats.numberOfSuccessfulTries;
    NSLog(@"GameStats loaded.");
//
}

- (void)saveData {
    NSString *resultsStoragePath = [DocumentsDirectory stringByAppendingPathComponent:@"gameStats.plist"];
    BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:resultsStoragePath];
    NSLog(@"Gamestats saved: success: %hhd",success);
    
//
}


-(BOOL)levelUp{
    if (self.numberOfSuccessfulTries >= maxNumberOfTries) {
        if (self.currentLevel < maxLevel) {
            self.currentLevel = self.currentLevel +1;
            self.numberOfSuccessfulTries = 0;
            self.numberOfFailues = 0;
            [self saveData];
            return YES;
        }
    } else {
        self.numberOfSuccessfulTries = self.numberOfSuccessfulTries + 1;
        self.numberOfFailues = 0;
    }
    
    [self saveData];
    return NO;
}

-(BOOL)levelDown {
    if (self.numberOfFailues >= maxNumberOfTries ) {
        if (self.currentLevel > 1) {
            self.currentLevel = self.currentLevel -1;
            self.numberOfSuccessfulTries = 0;
            self.numberOfFailues = 0;
            [self saveData];
            return YES;
        }
    } else {
        self.numberOfFailues = self.numberOfFailues +1;
        self.numberOfSuccessfulTries = 0;
    }
    [self saveData];
    return NO;
}


@end



