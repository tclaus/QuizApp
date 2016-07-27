//
//  FriendCell.h
//  QuizApp
//
//  Created by Tope Abayomi on 17/02/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;

@property (nonatomic, weak) IBOutlet UILabel* scoreLabel;

@property (nonatomic, weak) IBOutlet UIImageView* avatarImageView;

@property (nonatomic, weak) IBOutlet UIImageView* tickImageView;

@end
