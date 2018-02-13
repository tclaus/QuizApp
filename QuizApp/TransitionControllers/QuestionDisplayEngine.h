//
//  QuestionDisplayEngine.h
//  QuizApp
//
//  Created by Tope Abayomi on 01/01/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionViewController.h"

@class Questions;
@interface QuestionDisplayEngine : NSObject

-(void)attachDelegate:(id<QuestionViewControllerDelegate>)delegate;

-(BOOL)showNextQuestion:(Questions*)questions inMainView:(UIView*)mainView;

@end
