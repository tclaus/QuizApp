//
//  QuestionDisplayEngine.m
//  QuizApp
//
//  Created by Tope Abayomi on 01/01/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "QuestionDisplayEngine.h"
#import "ConstraintsPackage.h"
#import <DasQuiz-Swift.h>
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface QuestionDisplayEngine ()

@property (nonatomic, assign) NSInteger nextIndex;

@property (nonatomic, strong) QuestionViewController* questionController1;

@property (nonatomic, strong) QuestionViewController* questionController2;

@property (nonatomic, strong) NSArray* constraintPackages;

@end

@implementation QuestionDisplayEngine

-(instancetype)init{
    
    self = [super init];
    if(self){
        
        self.nextIndex = 0;
        
        NSString* storybardName = @"Main_iPad";
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storybardName bundle:nil];
        
        // switch to next question controller
        self.questionController1 = [storyboard instantiateViewControllerWithIdentifier:@"QuestionViewController"];
        self.questionController2 = [storyboard instantiateViewControllerWithIdentifier:@"QuestionViewController"];
        
    }
    return self;
}

-(void)attachDelegate:(id<QuestionViewControllerDelegate>)delegate{
    self.questionController1.delegate = delegate;
    self.questionController2.delegate = delegate;
}

-(BOOL)showNextQuestion:(Questions*)questions inMainView:(UIView*)mainView{
    
    if (self.nextIndex < questions.count){
        
        QuestionViewController* controller = self.nextIndex % 2 == 0 ? self.questionController1 : self.questionController2;
        QuestionViewController* currentController = self.nextIndex % 2 == 1 ? self.questionController1 : self.questionController2;
      
        controller.question = questions.listOfQuestions[self.nextIndex];
        
        if (self.nextIndex == 0){
    
            [controller.view setTranslatesAutoresizingMaskIntoConstraints:NO];
            [mainView addSubview:controller.view];
            ConstraintsPackage* controllerPackage = [self addConstraintsToSuperview:mainView subview:controller.view];
            controller.view.tag = 0;
            
            
            [currentController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
            [mainView addSubview:currentController.view];
            ConstraintsPackage* currentControllerPackage = [self addConstraintsToSuperview:mainView subview:currentController.view];
            currentController.view.tag = 1;
            
            self.constraintPackages = @[controllerPackage, currentControllerPackage];
        }
        
        [controller loadData];
        [self removeController:currentController andShowController:controller inMainView:mainView];
        

        self.nextIndex++;
        return YES;
    } else {
        
        [self.questionController1.view removeFromSuperview];
        [self.questionController2.view removeFromSuperview];
        return NO;
    }
}

-(void)removeController:(UIViewController*)fromViewController andShowController:(UIViewController*)toViewController inMainView:(UIView*)mainView{
    
    NSTimeInterval duration = 0.3;
    
    ConstraintsPackage* fromPackage = (ConstraintsPackage*)self.constraintPackages[fromViewController.view.tag];
    ConstraintsPackage* toPackage = (ConstraintsPackage*)self.constraintPackages[toViewController.view.tag];
    
    CGFloat toValue =  0;
    CGFloat fromValue = mainView.frame.size.width;
    // [mainView layoutIfNeeded];
    
     [UIView animateWithDuration:duration animations:^{
     
     fromPackage.centerXConstraint.constant = -fromValue;
     toPackage.centerXConstraint.constant = toValue;
     [mainView layoutIfNeeded];
     
     } completion:^(BOOL finished) {
     
     fromPackage.centerXConstraint.constant = 2 * mainView.frame.size.width;
     }];
     
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        [fromViewController viewDidAppear:YES];
        [toViewController viewDidAppear:YES];
    }
}

- (ConstraintsPackage*)addConstraintsToSuperview:(UIView *)superview subview:(UIView*)subview{
    
    NSLayoutConstraint* xConstraint = [NSLayoutConstraint constraintWithItem:subview
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:superview
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1
                                                                   constant:0];
    
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:subview
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:superview
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:32];
    
    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:subview
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:superview
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1
                                                                      constant:0];
    
    NSLayoutConstraint* widthConstraint = [NSLayoutConstraint constraintWithItem:subview
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:superview
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1
                                  constant:0];
    
    
    [superview addConstraints:@[xConstraint, widthConstraint, topConstraint, bottomConstraint]];
    
    ConstraintsPackage* package = [[ConstraintsPackage alloc] init];
    package.centerXConstraint = xConstraint;
    
    return package;
}


@end
