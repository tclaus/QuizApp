//
//  ReviewViewController.h
//  QuizApp
//
//  Created by Tope Abayomi on 20/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADVRoundProgressChart.h"

@class Questions;
@interface ResultsViewController : UIViewController <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) Questions* questions;
@end

