//
//  QuestionContainerController.h
//  QuizApp
//
//  Created by Tope Abayomi on 23/01/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"
#import "QuestionViewController.h"
#import "ResultsViewController.h"

@interface QuestionContainerController : UIViewController  <QuestionViewControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSArray* questions;

@end
