//
//  QuestionViewController.h
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuestionViewControllerDelegate;

@class Question;
@interface QuestionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Question* question;

@property (nonatomic, assign) id<QuestionViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isForReview;

-(void)loadData;

@end


@protocol QuestionViewControllerDelegate <NSObject>

-(void)questionHasBeenAnswered:(Question*)question withController:(QuestionViewController*)controller;

@end
