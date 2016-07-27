//
//  GameChallengeController.h
//  QuizApp
//
//  Created by Tope Abayomi on 17/02/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameKitManager.h"

typedef void (^FriendsPickerCancelButtonPressed)();
typedef void (^FriendsPickerChallengeButtonPressed)();

@interface GameChallengeController : UIViewController <UITableViewDataSource,
UITableViewDelegate, UITextFieldDelegate, GameKitManagerProtocol>

@property (nonatomic, copy) FriendsPickerCancelButtonPressed cancelButtonPressedBlock;

@property (nonatomic, copy) FriendsPickerChallengeButtonPressed challengeButtonPressedBlock;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIButton *closeButton;

@property (nonatomic, weak) IBOutlet UIButton *challengeButton;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSMutableDictionary *dataSource;

@end
