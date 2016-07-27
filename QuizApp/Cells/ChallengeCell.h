//
//  ChallengeCell.h
//  QuizApp
//
//  Created by Tope Abayomi on 17/02/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UserDidTapAcceptButton)(id);

@interface ChallengeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;

@property (nonatomic, weak) IBOutlet UILabel* messageLabel;

@property (nonatomic, weak) IBOutlet UIImageView* avatarImageView;

@property (nonatomic, weak) IBOutlet UIButton* acceptButton;

@property (nonatomic, strong) id challenge;

@property (nonatomic, copy) UserDidTapAcceptButton userDidTapAcceptButtonBlock;

@end
