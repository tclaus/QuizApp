
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
    
    // Reset all controls
    if (!selected) {
        self.tickImageView.image = nil;
        self.tickImageView.alpha = 0.0;
        self.barImageView.tintColor = [UIColor whiteColor];
        self.barImageView.alpha = 0.5;
    } else {
        return;
    }
    
    return;
    
}

-(void)showImageForCorrectAnswer:(BOOL)correct AndChosenAnswer:(BOOL)chosen{
    
    
    if (correct) {
        self.tickImageView.image = [UIImage imageNamed:@"tick"];
        return;
    }
    
    if (!correct && chosen ) {
        self.tickImageView.image = [UIImage imageNamed:@"cross"];
        return;
    }
    
    self.tickImageView.image = nil;
    
}

-(void)showCorrectAnswerWithAnimation{
    [self showCorrectAnswerWithAnimation:nil];
}

-(void)showCorrectAnswerWithAnimation:(void (^)())complete{
   
    NSTimeInterval duration;
    if (self.selected) {
        duration = 0.5;
    } else {
        duration = 1.0;
    }
    
    [UIView animateWithDuration:duration animations:^{
        
        // Show green color for right answer
        self.barImageView.image = [ self.barImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.barImageView.alpha = 1.0;
        self.barImageView.tintColor = [UIColor greenColor];
        self.tickImageView.alpha = 1.0;
        
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
   
    NSTimeInterval duration;
    if (self.selected) {
        duration = 0.5;
    } else {
        duration = 1.0;
    }
    
    [UIView animateWithDuration:duration animations:^{
        
        // show Red color
        self.barImageView.image = [ self.barImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.barImageView.alpha = 1.0;
        self.barImageView.tintColor = [UIColor redColor];
        self.tickImageView.alpha = 1.0;
        
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

