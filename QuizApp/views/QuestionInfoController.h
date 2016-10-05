//
//  TopicDetailViewController.h
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//
// This view is shown right before the questions start
#import <UIKit/UIKit.h>
#import "Topic.h"
#import "QuestionViewController.h"

typedef void (^UserPressedStart)();

@protocol QuestionInfoControllerDelegate;

@interface QuestionInfoController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel* infoLabel;

@property (nonatomic, weak) IBOutlet UILabel* questionsLabel;

@property (nonatomic, weak) IBOutlet UIButton* startButton;

@property (nonatomic, strong) NSArray* questions;

@property (nonatomic, copy) UserPressedStart userPressedStartBlock;

@end

@protocol QuestionInfoControllerDelegate <NSObject>

-(void)userDidStartQuiz;

@end
