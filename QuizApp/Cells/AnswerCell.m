
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

    self.indexLabel.textColor = [UIColor whiteColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.barImageView.image = [[UIImage imageNamed:@"item-selected-empty"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 20, 20)];
    
    self.answerImageView.clipsToBounds = YES;
    self.answerImageView.contentMode = UIViewContentModeScaleAspectFit;

    self.tickImageView.image = nil;
     self.barImageView.tintColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (self.isForReview) {
        return;
    }
    self.barImageView.alpha = selected ? 1.0 : 0.0;

    if (self.answerTapped) {
        self.contentView.alpha = 0.1;
        if (self.isCorrect) {
            self.contentView.alpha = 1.0;
            self.barImageView.image = [UIImage imageNamed:@"cross"];
        } else {
            self.barImageView.image = [UIImage imageNamed:@"tick"];
        }
    } else {
        self.tickImageView.image = nil;
    }
}

-(void)showImageForCorrectAnswer:(BOOL)correct AndChosenAnswer:(BOOL)chosen{

    self.barImageView.alpha = chosen ? 1.0 : 0.0;
    
    if (correct && chosen) {
        self.tickImageView.image = [UIImage imageNamed:@"tick"];
    }
    
    if (!correct && chosen) {
        self.tickImageView.image = [UIImage imageNamed:@"cross"];
    }
    
}

-(void)showCorrectAnswerWithAnimation{
    [self showCorrectAnswerWithAnimation:nil];
}

-(void)showCorrectAnswerWithAnimation:(void (^)())complete{
    [UIView animateWithDuration:1.0 animations:^{
        self.barImageView.alpha = 1.0;
        // Show green color for right answer
        self.barImageView.image = [ self.barImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        (self.barImageView).tintColor = [UIColor greenColor];
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }
     ];
}

-(void)showWrongAnswerWithAnimation{
    [self showWrongAnswerWithAnimation:nil];
}

-(void)showWrongAnswerWithAnimation:(void (^)())complete{
    [UIView animateWithDuration:1.0 animations:^{
        self.barImageView.image = [ self.barImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.contentView.alpha = 1.0;
        (self.barImageView).tintColor = [UIColor redColor];
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }
];
    
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat constraintsTotal = self.indexTrailing.constant + self.indexWidth.constant + self.indexAnswerSpacing.constant + self.answerTickSpacing.constant + self.tickWidth.constant + self.tickTrailing.constant + 10;
    
    self.answerLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - constraintsTotal;
    
}

@end

