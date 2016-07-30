//
//  FriendCell.m
//  QuizApp
//
//  Created by Tope Abayomi on 17/02/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "FriendCell.h"
#import "ADVTheme.h"

@implementation FriendCell

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
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:16.0f];
    
    self.scoreLabel.textColor = [UIColor whiteColor];
    self.scoreLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:16.0f];
    
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    
}
@end
