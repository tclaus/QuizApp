//
//  AnswerReviewCell.m
//  QuizApp
//
//  Created by Tope Abayomi on 31/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "AnswerReviewCell.h"
#import "ADVTheme.h"

@interface AnswerReviewCell ()

@end

@implementation AnswerReviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.answerLabel.textColor = [UIColor whiteColor];
    self.answerLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:19.0f];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.barImageView.image = [[UIImage imageNamed:@"item-selected-empty"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 20, 20)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showImageForCorrectAnswer:(BOOL)correct AndChosenAnswer:(BOOL)chosen{
    
    self.barImageView.alpha = chosen ? 1.0 : 0.0;
    self.tickImageView.alpha = correct ? 1.0 : 0.0;
    
    if (correct && chosen) {
        self.tickImageView.image = [UIImage imageNamed:@"tick"];
    }
    
    if (!correct && chosen) {
        self.tickImageView.image = [UIImage imageNamed:@"cross"];
    }
    

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.answerLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.answerLabel.frame);
}

@end
