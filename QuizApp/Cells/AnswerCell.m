//
//  AnswerCell.m
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "AnswerCell.h"
#import "ADVTheme.h"

@implementation AnswerCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    
    CGFloat textFontSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 19.0f : 15.0f;
    CGFloat indexFontSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 25.0f : 18.0f;
    
    self.answerLabel.textColor = [UIColor whiteColor];
    self.answerLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:textFontSize];
    self.answerLabel.numberOfLines = 0;

    
    self.indexLabel.textColor = [UIColor whiteColor];
    self.indexLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:indexFontSize];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.barImageView.image = [[UIImage imageNamed:@"item-selected-empty"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 20, 20)];
    
    self.answerImageView.clipsToBounds = YES;
    self.answerImageView.contentMode = UIViewContentModeScaleAspectFit;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (self.isForReview) {
        return;
    }
    self.barImageView.alpha = selected ? 1.0 : 0.0;
    self.tickImageView.alpha = selected ? 1.0 : 0.0;

    if (self.answerTapped) {
        self.contentView.alpha = 0.1;
        if (self.isCorrect) {
            self.contentView.alpha = 1.0;
            self.barImageView.alpha = 1.0;
        }
    }
}

-(void)showImageForCorrectAnswer:(BOOL)correct AndChosenAnswer:(BOOL)chosen{

    self.barImageView.alpha = chosen ? 1.0 : 0.0;
    self.tickImageView.alpha = correct ? 1.0 : 0.0;
    
}

-(void)showCorrectAnswerWithAnimation{
    [UIView animateWithDuration:1.0 animations:^{
        self.barImageView.alpha = 1.0;
        // Show green color for right answer
        // self.barImageView
         self.barImageView.image = [ self.barImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [ self.barImageView setTintColor:[UIColor greenColor]];
    }];
}

-(void)showWrongAnswerWithAnimation{
    [UIView animateWithDuration:1.0 animations:^{
        self.contentView.alpha = 0.1;
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat constraintsTotal = self.indexTrailing.constant + self.indexWidth.constant + self.indexAnswerSpacing.constant + self.answerTickSpacing.constant + self.tickWidth.constant + self.tickTrailing.constant + 10;
    
    self.answerLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - constraintsTotal;
    
}

@end

