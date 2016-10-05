//
//  ChallengeCell.m
//  QuizApp
//
//  Created by Tope Abayomi on 17/02/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "ChallengeCell.h"
#import "ADVTheme.h"

@implementation ChallengeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor blackColor];
    
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:15.0f];
    
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:13.0f];
    
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImage* buttonBackground = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    buttonBackground = [buttonBackground imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.acceptButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    self.acceptButton.titleLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:13.0f];
    [self.acceptButton setTitle:NSLocalizedString(@"ACCEPT",@"") forState:UIControlStateNormal];
    
    [self.acceptButton addTarget:self action:@selector(acceptButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)acceptButtonTapped:(id)sender{
    if (self.userDidTapAcceptButtonBlock != nil) {
        self.userDidTapAcceptButtonBlock(self.challenge);
    }
}


@end
