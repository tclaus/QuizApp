//
//  TopicDetailViewController.m
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//


#import "QuestionInfoController.h"
#import "ADVTheme.h"
#import "ResultAggregate.h"
#import "Datasource.h"
#import "QuestionContainerController.h"
#import "Config.h"

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
	
    self.questionsLabel.text = [NSString stringWithFormat:@"%lu Questions", (unsigned long)self.questions.count];
    
    self.results = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    self.view.tintColor = [UIColor whiteColor];
    
    self.infoLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:14];
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.numberOfLines = 0;
    
    NSString* configInfo = [Config sharedInstance].quizStartInfo;
    NSInteger passThreshold = [Config sharedInstance].passThreshold;
    configInfo = [NSString stringWithFormat:configInfo, self.questions.count, passThreshold];
    self.infoLabel.text = configInfo;
    
    self.questionsLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:18];
    self.questionsLabel.textColor = [UIColor whiteColor];
    self.questionsLabel.numberOfLines = 0;
    
    UIImage* buttonBackground = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    buttonBackground = [buttonBackground imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.startButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:19.0f];
    [self.startButton addTarget:self action:@selector(showQuestionTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    
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
