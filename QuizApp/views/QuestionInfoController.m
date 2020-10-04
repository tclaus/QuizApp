//
//  TopicDetailViewController.m
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//


#import "QuestionInfoController.h"
#import "ADVTheme.h"
#import "QuestionContainerController.h"
#import "Config.h"
#import "GameModel.h"
#import <DasQuiz-Swift.h>

@interface QuestionInfoController ()

@property (nonatomic, strong) NSMutableArray* results;

@end

@implementation QuestionInfoController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.results = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    self.view.tintColor = [UIColor whiteColor];
    
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.numberOfLines = 0;
    
    NSString* gameInfoText;
    
    // (Quiz)
    // Placeholder 1: Du musst in X Sekunden so viele Fragen lösen, wie möglich. Die Schwierigkeitsstufe steigt dabei an.
    //                Deine Ergebnisse werden dabei gewertet.
    //
    // (Training)
    // Du musst 50 Fragen lösen. Die Schwierigkeit steigt dabei an. Es gibt keine Zeitbeschränkung.
    //
    
    switch ([GameModel sharedInstance].activeGameMode) {
        case GameModeTimeBasedCompetition:
            gameInfoText = [NSString stringWithFormat:NSLocalizedString(@"GameModeTimeBasedCompetitionDescription", @"Needs a placeholder for maxtime"), [GameModel sharedInstance].gameTime] ;
            self.questionsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%lu Seconds",@""), (unsigned long)[GameModel sharedInstance].gameTime];
            
            break;
            
        case GameModeTrainig:
            gameInfoText = [NSString stringWithFormat:NSLocalizedString(@"GameModeTrainigDescription", @"Needs a placeholder for questioncount"), [GameModel sharedInstance].numberOfQuestions] ;
            self.questionsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%lu Questions",@""), (unsigned long)[GameModel sharedInstance].numberOfQuestions];
            
    }
    
    self.infoLabel.text = gameInfoText;
    
    self.questionsLabel.textColor = [UIColor whiteColor];
    self.questionsLabel.numberOfLines = 0;
    
    UIImage* buttonBackground = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    buttonBackground = [buttonBackground imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.startButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:19.0f];
    [self.startButton addTarget:self action:@selector(showQuestionTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setTitle:NSLocalizedString(@"START",@"") forState:UIControlStateNormal];
    
}

-(IBAction)showQuestionTapped:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        if(self.userPressedStartBlock != nil){
            self.userPressedStartBlock();
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
