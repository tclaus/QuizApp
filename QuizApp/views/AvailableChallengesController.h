//
//  AvailableChallengesController.h
//  QuizApp
//
//  Created by Tope Abayomi on 17/02/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

typedef void (^UserDidAcceptChallenge)(GKChallenge*);

@interface AvailableChallengesController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray* challenges;

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, copy) UserDidAcceptChallenge userDidAcceptChallengeBlock;

@end
