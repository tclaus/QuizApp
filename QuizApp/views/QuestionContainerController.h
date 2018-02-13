//
//  QuestionContainerController.h
//  QuizApp
//
#import <UIKit/UIKit.h>
#import "QuestionViewController.h"
#import "ResultsViewController.h"

@class Questions;
@interface QuestionContainerController : UIViewController  <QuestionViewControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic) Questions* questions;

/**
 Total points for questions so far 
 */
@property (nonatomic) int points;
@end
