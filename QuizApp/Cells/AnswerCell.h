//
//  AnswerCell.h
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* answerLabel;

@property (nonatomic, weak) IBOutlet UILabel* indexLabel;

@property (nonatomic, weak) IBOutlet UIImageView* answerImageView;

@property (nonatomic, weak) IBOutlet UIImageView* tickImageView;

@property (nonatomic, weak) IBOutlet UIImageView* barImageView;

@property (nonatomic, assign) BOOL isForReview;

@property (nonatomic, assign) BOOL answerTapped;

@property (nonatomic, assign) BOOL isCorrect;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* indexTrailing;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* indexWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* indexAnswerSpacing;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* answerTickSpacing;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* tickWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* tickTrailing;


-(void)showImageForCorrectAnswer:(BOOL)correct AndChosenAnswer:(BOOL)chosen;

-(void)showCorrectAnswerWithAnimation;

-(void)showWrongAnswerWithAnimation;

@end
