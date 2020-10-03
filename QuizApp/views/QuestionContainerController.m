//
//  QuestionContainerController.m
//  QuizApp
//
#import "QuestionContainerController.h"
#import "QuestionDisplayEngine.h"
#import "Datasource.h"
#import "ADVTheme.h"
#import "Config.h"
#import "QuizIAPHelper.h"
#import "DropAnimationController.h"
#import "ExplanationViewController.h"
#import "SoundSystem.h"
#import "GameModel.h"

#import "Utils.h"
#import <DasQuiz-Swift.h>

@import FirebaseAnalytics;

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
    
    [self setupEnvironment];
    [self showNextQuestion];
    [self startBackgroundSound];
}

-(void) startBackgroundSound {
    if (!heartSoundPlaying) {
        [self.soundSystem playHeartBeatSound];
        [self.soundSystem playThinkingMusic];
        heartSoundPlaying = YES;
    }
}

-(void)setupEnvironment {
    self.navigationItem.hidesBackButton = YES;
    
    self.displayEngine = [[QuestionDisplayEngine alloc] init];
    [self.displayEngine attachDelegate:self];
    
    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"StatusView" owner:nil options:nil];
    UIView* statusView = nibs[0];
    
    self.statusProgress = (UIProgressView*)[statusView viewWithTag:2];
    self.navigationItem.titleView = statusView;
    
    self.statusLabel = (UILabel*)[statusView viewWithTag:1];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:14.0f];
    self.statusProgress.tintColor = [ADVTheme mainColor];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.timerLabel = (UILabel*)[statusView viewWithTag:3];
    self.timerLabel.textColor = [UIColor whiteColor];
    self.timerLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:14.0f];
    self.timerLabel.alpha = 0.0;
    
    self.currentQuestionIndex = -1;
    self.points = 0;
    
    // Set game time. Can be 0 in training mode
    self.totalTimeInterval = [GameModel sharedInstance].gameTime;
    
    if (self.totalTimeInterval > 0){
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
    self.soundSystem = [SoundSystem sharedInstance];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (heartSoundPlaying) {
        [self.soundSystem stopHeartBeatSound];
        [self.soundSystem stopThinkingMusic];
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

/**
 Add points to total point label
 */
-(void)calculatePoints:(Question*) question{
    // Punkte berechnen:
    // Im Quiz - Modus punkte
    // IM Trainingsmodus nur anzahl (%) richtige Fragen
    
    if (question.hasBeenAnsweredCorrectly) {
        
        switch ([GameModel sharedInstance].activeGameMode) {
            case GameModeTimeBasedCompetition:
                self.points = self.points + question.points;
                break;
                
            case GameModeTrainig:
                self.points = 0;
                break;
                
        }
    }
}

-(void)questionHasBeenAnswered:(Question *)question withController:(QuestionViewController *)controller{
    
    
    
    [Utils addAsUsedQuestion:controller.question];
    
    [self calculatePoints:question];
    
    [self showNextQuestion];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Show solved questions
    if([segue.identifier isEqualToString:@"results"]){
        ResultsViewController* controller = segue.destinationViewController;
        
        Questions* solvedQuestions = [[Questions alloc]init];
        solvedQuestions.listOfQuestions = [self.questions.listOfQuestions subarrayWithRange:NSMakeRange(0, self.currentQuestionIndex)];
        controller.questions = solvedQuestions;
        
    } else if([segue.identifier isEqualToString:@"info"]) {
        
        ExplanationViewController* controller = segue.destinationViewController;
        
        Question* question = self.questions.listOfQuestions[self.currentQuestionIndex];
        controller.explanationText = question.explanation;
    }
}

-(IBAction)doneTapped:(id)sender{
    [self.timer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setStatusInfoWithCount:(NSInteger)count{
    
    // Training:
    // Question %ld of %ld
    
    switch ([GameModel sharedInstance].activeGameMode) {
        case GameModeTimeBasedCompetition:
            
            // In Quizmode: Punkte vergeben?
            self.statusLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Points: %d",@"Headline in questionlist for quizmode"), self.points];
            [self.statusProgress setProgress:self.currentTimeInterval/(CGFloat)self.totalTimeInterval animated:YES];
            break;
            
        case GameModeTrainig:
            
            self.statusLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Question %ld of %ld",@"Headline in questionlist for trainingmode"), (long)count+1, (unsigned long)self.questions.count];
            [self.statusProgress setProgress:count/(CGFloat)self.questions.count animated:YES];
            break;
    }
}

-(void)updateTime:(id)sender{
    self.currentTimeInterval++;
    [self updateTimerText];
    
    //Make a Tick-Sound for the last 5 seconds
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
    
    // In quizmode update status bar by time
    if  ([GameModel sharedInstance].activeGameMode == GameModeTimeBasedCompetition) {
        [self.statusProgress setProgress:self.currentTimeInterval/(CGFloat)self.totalTimeInterval animated:YES];
    }
}

-(void) timeUp {
    
    long qc = self.currentQuestionIndex;
    NSLog(@"Questions solved: %ld",qc);
    
    [self.timer invalidate];
    
    Questions *subQuestions = [Utils getFirst:self.questions numberOfQuestions:self.currentQuestionIndex];
    
    NSString *message = [self gameOverAlertMessage:subQuestions secondsNeeded:self.totalTimeInterval];
    
    UIAlertController* alert =  [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Time Up!",@"Title- time is up")
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"See Your Results",@"Title: See results") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self saveResultsAndShowThem];
    }];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 Save training data or quiz data
 */
-(void)saveResultsAndShowThem{
    
    // Subquestion
    Questions *subQuestions = [Utils getFirst:self.questions numberOfQuestions:self.currentQuestionIndex];
    
    switch ([GameModel sharedInstance].activeGameMode) {
        case GameModeTimeBasedCompetition:
            [Datasource saveTimeBasedAggregates:subQuestions forDate:[NSDate date]];
            [self checkLevelProgress:subQuestions secondsNeeded:self.totalTimeInterval];
            break;
            
        case GameModeTrainig:
            [Datasource saveTrainingAggregates:subQuestions forDate:[NSDate date]];
            break;
    }
    
    // Show Level up! (or level down)
    
    [self performSegueWithIdentifier:@"results" sender:self];
}

-(void)checkLevelProgress:(Questions*)resultQuestions secondsNeeded:(int)time{
    // 3.7sec pro Antwort  = 31 Fragen.
    // davon 90% richtig => Level up
    // 120 Punkte? => 1200
    
    // IAP Check
    if ([self IAPCheck] && GameStats.INSTANCE.currentLevel >= 4 &&
        GameStats.INSTANCE.numberOfSuccessfulTries >= 3) {
        NSLog(@"Level 4 reached with 3 tries. But no IAP until now");
        return;
    }
    
    // In unterschiedlichen Levels, die Zeit anziehen lassen: 3Sec Pro Frage ist schon sehr schnell
    // Den ganz lahmen, oder wenn man einfach gar nichts macht, wird aber kein Punkt abgezogen
    
    GameStats.INSTANCE.lastPoints = self.points;
    
}

-(NSString*)gameOverAlertMessage:(Questions*)resultQuestions secondsNeeded:(int)time{
    
    // Number of questions reached?
    if ((time / resultQuestions.count) < 6.0) {
        CGFloat percent = [Utils calculateCorrectPercent:resultQuestions];
        // >= 90 % success?
        if (percent >=0.80) {
            // PossibleLevel up
            BOOL nextLevel = false;
            
            if ([self IAPProductPurchased] ||
                ( GameStats.INSTANCE.currentLevel < [Config sharedInstance].quizIAP.numberOfFreeLevels) ||
                ( GameStats.INSTANCE.currentLevel == [Config sharedInstance].quizIAP.numberOfFreeLevels &&
                 GameStats.INSTANCE.numberOfSuccessfulTries < 3)  ) {
                
                nextLevel= [GameStats.INSTANCE levelUp];
            } else {
                // Not purchased!
                return NSLocalizedString(@"Wenn Du in das nächste Level möchtest, musst du das Spiel freischalten.",@"Wenn Du in das nächste Level möchtest, musst du das Spiel freischalten.");
            }
            
            // If next Level - Show screen
            // If only next Try - show number of tries
            if (nextLevel) {
                return NSLocalizedString(@"Das war SUPER!",@"Das war SUPER!");
            } else {
                return NSLocalizedString(@"Du hast ein Stern verdient!",@"Du hast ein Stern verdient!");
            }
            
        } else if(percent >0.5 && percent <0.80) {
            
            // ab 20 Fragen UND 80% richtig
            NSInteger neededQuestions = (20 - resultQuestions.count);
            if (neededQuestions > 0) {
                return [NSString stringWithFormat:NSLocalizedString(@"Kannst du noch %ld Fragen richtig lösen? Dann winkt ein Stern.",@"Kannst du noch %ld Fragen richtig lösen? Dann winkt ein Stern."),neededQuestions];
            } else {
                // Dann war es wohl zu schlecht
                return @"Üben, üben, üben...";
            }
            
        } else  {
            // Player just tapped, but doesn't care about right answers
            BOOL downLevel = [GameStats.INSTANCE levelDown];
            
            // If level down - Show screen
            
            if (downLevel) {
                return NSLocalizedString(@"Schade. Du wirst herabgestuft.",@"Schade. Du wirst herabgestuft.");
            } else {
                return NSLocalizedString(@"Das war nicht schlecht. Aber nicht einfach drauf los tippen.",@"Das war nicht schlecht. Aber nicht einfach drauf los tippen.");
            }
            
        }
    } else {
        return NSLocalizedString(@"Kannst du mehr Fragen richtig lösen?",@"Kannst du mehr Fragen richtig lösen?");
    }
    
}

/**
 Returns YES if product is upgraded
 */
- (BOOL)IAPCheck {
    
    
    // Check, if number of quiz is limited. (Studid, then you cant play any more)
    return  ![[QuizIAPHelper sharedInstance] productPurchased:[Config sharedInstance].quizIAP.inAppPurchaseID];
    
}

/**
 YES if purchased
 */
- (BOOL)IAPProductPurchased {
    
    return  [[QuizIAPHelper sharedInstance] productPurchased:[Config sharedInstance].quizIAP.inAppPurchaseID];
}

-(IBAction)moreInfoTapped:(id)sender{
    
    Question* question = self.questions.listOfQuestions[self.currentQuestionIndex];
    
    NSURL *url = [NSURL URLWithString:question.explanation];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [FIRAnalytics logEventWithName:@"ViewExplanation"
                            parameters:@{
                                         @"questionID": [NSNumber numberWithInteger: question.questionID]
                                         }];
        [[UIApplication sharedApplication] openURL:url options: @{} completionHandler:nil];
    }
    // Dont open a view, go to wikipedia
    // [self performSegueWithIdentifier:@"info" sender:self];
}

-(void)setInfoButtonStatus{
    
    if(self.currentQuestionIndex < self.questions.count){
        
        Question* question = self.questions.listOfQuestions[self.currentQuestionIndex];
        
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
