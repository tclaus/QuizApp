//
//  AnswerReviewCell.h
//  QuizApp
//
//  Created by Tope Abayomi on 31/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerReviewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* answerLabel;

@property (nonatomic, weak) IBOutlet UIImageView* tickImageView;

@property (nonatomic, weak) IBOutlet UIImageView* barImageView;

-(void)showImageForCorrectAnswer:(BOOL)correct AndChosenAnswer:(BOOL)chosen;

@end
