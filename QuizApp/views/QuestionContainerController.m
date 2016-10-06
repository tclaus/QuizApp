//
//  QuestionContainerController.m
//  QuizApp
//
//  Created by Tope Abayomi on 23/01/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "QuestionContainerController.h"
#import "QuestionDisplayEngine.h"
#import "Datasource.h"
#import "ADVTheme.h"
#import "Config.h"
#import "DropAnimationController.h"
#import "ExplanationViewController.h"
#import "SoundSystem.h"

@interface QuestionContainerController ()

@property (nonatomic, strong) QuestionDisplayEngine* displayEngine;

@property (nonatomic, strong) UILabel* statusLabel;

@property (nonatomic, strong) UIProgressView* statusProgress;

@property (nonatomic, strong) UILabel* timerLabel;

@property (nonatomic, assign) NSInteger currentQuestionIndex;

@property (nonatomic, strong) NSTimer* timer;

@property (nonatomic, assign) CGFloat currentTimeInterval;

@property (nonatomic, assign) NSTimeInterval totalTimeInterval;

@property (nonatomic, strong) DropAnimationController* animationController;

@property (nonatomic, strong) UIBarButtonItem* infoBarButton;

@property (nonatomic, strong) SoundSystem* soundSystem;
@end

@implementation QuestionContainerController

static BOOL heartSoundPlaying;

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
    
    self.navigationItem.hidesBackButton = YES;
    
    self.displayEngine = [[QuestionDisplayEngine alloc] init];
    [self.displayEngine attachDelegate:self];
    
    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"StatusView" owner:nil options:nil];
    UIView* statusView = nibs[0];
    
    self.statusLabel = (UILabel*)[statusView viewWithTag:1];
    self.statusProgress = (UIProgressView*)[statusView viewWithTag:2];
    self.navigationItem.titleView = statusView;
    
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:14.0f];
    self.statusProgress.tintColor = [ADVTheme mainColor];
    
    self.currentQuestionIndex = -1;
    
    self.view.backgroundColor = [UIColor blackColor];

    self.timerLabel = (UILabel*)[statusView viewWithTag:3];
    self.timerLabel.textColor = [UIColor whiteColor];
    self.timerLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:14.0f];
    self.timerLabel.alpha = 0.0;
    
    BOOL isTimedQuiz = [Config sharedInstance].isTimedQuiz;
    
    self.totalTimeInterval = isTimedQuiz ? floor([Config sharedInstance].timeNeededInMinutes * 60) : 0;
    
    if(self.totalTimeInterval > 0){
        self.timerLabel.alpha = 1.0;
        self.currentTimeInterval = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
        [self updateTimerText];
    }
    
    self.animationController = [[DropAnimationController alloc] init];
    
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Stop",@"") style:UIBarButtonItemStylePlain target:self action:@selector(doneTapped:)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(moreInfoTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.infoBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.leftBarButtonItem = self.infoBarButton;
    self.soundSystem = [[SoundSystem alloc]init];
    
    [self showNextQuestion];
    
    if (!heartSoundPlaying) {
        [self.soundSystem playHeadBeatSound];
        heartSoundPlaying = YES;
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (heartSoundPlaying) {
        [self.soundSystem stopHeardBeatSound];
        heartSoundPlaying = NO;
    }
}

-(void)showNextQuestion{
    
    self.currentQuestionIndex++;
    [self setStatusInfoWithCount:self.currentQuestionIndex];
    [self setInfoButtonStatus];
    BOOL canShowNextQuestion = [self.displayEngine showNextQuestion:self.questions inMainView:self.view];
    if(!canShowNextQuestion){
        
        [self.timer invalidate];
        [self saveResultsAndShowThem];
    }
}

-(void)questionHasBeenAnswered:(Question *)question withController:(QuestionViewController *)controller{
    
    [self showNextQuestion];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"results"]){
        ResultsViewController* controller = segue.destinationViewController;
        controller.questions = self.questions;
    }else if([segue.identifier isEqualToString:@"info"]){
        
        ExplanationViewController* controller = segue.destinationViewController;
        
        Question* question = self.questions[self.currentQuestionIndex];
        controller.explanationText = question.explanation;
    }
}

-(IBAction)doneTapped:(id)sender{
    [self.timer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setStatusInfoWithCount:(NSInteger)count{
    
    self.statusLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Question %ld of %ld",@"Headline in questionlist"), (long)count+1, (unsigned long)self.questions.count];
    
    [self.statusProgress setProgress:count/(CGFloat)self.questions.count animated:YES];
    
}

-(void)updateTime:(id)sender{
    self.currentTimeInterval++;
    [self updateTimerText];
   
    //Make a Tick-Sound?
    // last 5 seconds?
    if(self.currentTimeInterval > (self.totalTimeInterval - 5) ){
        [self.soundSystem playTickSound];
    }
    
   // Time is up
    if(self.currentTimeInterval == self.totalTimeInterval){
        [self.soundSystem playTimeOutSound];
        [self timeUp];
    }
    
}

-(void)updateTimerText{
    
    NSInteger secondsLeft = self.totalTimeInterval - self.currentTimeInterval;
    NSInteger minutes = floor(secondsLeft / 60);
    NSInteger seconds = round(secondsLeft - minutes * 60);
    
    if (seconds<10) {
        self.timerLabel.text = [NSString stringWithFormat:@"%ld:0%ld", (long)minutes, (long)seconds];
    } else {
        self.timerLabel.text = [NSString stringWithFormat:@"%ld:%ld", (long)minutes, (long)seconds];
    }
    
    
    
}

-(void)timeUp{
    
    
    [self.timer invalidate];
   
    UIAlertController* alert =  [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Time Up!",@"Title- time is up")  message:NSLocalizedString(@"Your Time is Up",@"Messgage: Time is up") preferredStyle:UIAlertControllerStyleAlert];
  
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"See Your Results",@"Title: See results") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self saveResultsAndShowThem];
    }];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)saveResultsAndShowThem{

    [Datasource saveAggregates:self.questions forDate:[NSDate date]];
    [self performSegueWithIdentifier:@"results" sender:self];
}

-(IBAction)moreInfoTapped:(id)sender{
    [self performSegueWithIdentifier:@"info" sender:self];
}

-(void)setInfoButtonStatus{
    
    if(self.currentQuestionIndex < self.questions.count){
        
        Question* question = self.questions[self.currentQuestionIndex];
        
        BOOL hasExplanation = question.explanation != nil && question.explanation.length > 0;
        self.infoBarButton.enabled = hasExplanation;
    }else{
        self.infoBarButton.enabled = NO;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    
    self.animationController.isPresenting = YES;
    return self.animationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    self.animationController.isPresenting = NO;
    return self.animationController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
