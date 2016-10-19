//
//  StatsViewController.m
//  QuizApp
//
//  Created by Tope Abayomi on 03/01/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "StatsViewController.h"
#import "ADVRoundProgressChart.h"
#import "PNScrollLineChart.h"
#import "PNScrollBarChart.h"
#import "QuestionInfoController.h"
#import "TopicCollectionController.h"
#import "DropAnimationController.h"
#import "QuestionContainerController.h"
#import "AvailableChallengesController.h"
#import "ADVTheme.h"
#import "Datasource.h"
#import "Utils.h"
#import "Config.h"
#import "GameKitManager.h"
#import "QuizIAPHelper.h"
#import "GameModel.h"
#import "GameStats.h"

@interface StatsViewController () <TopicCollectionControllerDelegate, QuestionInfoControllerDelegate, GameKitManagerProtocol, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet ADVRoundProgressChart* scoresProgress;

@property (nonatomic, strong) PNScrollBarChart* scoresBarChart;
@property (weak, nonatomic) IBOutlet UILabel *gameModeLabel;

@property (nonatomic, weak) IBOutlet UIView* scoresBarChartContainer;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* scoresBarChartHeightConstraint;

@property (nonatomic, weak) IBOutlet UILabel* levelNumber;

@property (nonatomic, weak) IBOutlet UILabel* levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

@property (nonatomic, weak) IBOutlet UILabel* scoresLabel;

@property (nonatomic, weak) IBOutlet UIButton* startButton;

@property (nonatomic, weak) IBOutlet UIButton* challengesButton;

@property (weak, nonatomic) IBOutlet UIButton *highScoreButton;

@property (nonatomic, weak) IBOutlet UIButton* chooseTopicsButton;

@property (nonatomic, strong) IBOutlet UIBarButtonItem* restorePurchase;

@property (nonatomic, strong) NSArray* selectedQuestions;

@property (nonatomic, strong) NSArray* gamecenterChallenges;
@property (nonatomic, strong) NSArray* gamecenterChallengeInfos;

@property (nonatomic, strong) DropAnimationController* animationController;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSDictionary *pendingQuiz;

@property (nonatomic, weak) IBOutlet UIView* topStatsContainer;
@property (nonatomic, weak) IBOutlet UIView* buttonContainer;
@property (nonatomic, weak) IBOutlet UIView* spacerView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* topStatsContainerHeight;

// Stars for level progress


@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;

@property (weak, nonatomic) IBOutlet UIView *levelUpView;
@property (strong,nonatomic) UIVisualEffect* effect;
@property (strong, nonatomic) UIVisualEffectView *effectView;

@end

@implementation StatsViewController {
    NSInteger lastLevel;
}



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self displayCharts];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (lastLevel < [GameStats sharedInstance].currentLevel) {
        [self animateIn];
        lastLevel = [GameStats sharedInstance].currentLevel;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gamecenterChallenges = @[];
    
    if([Config sharedInstance].gameCenterEnabled){
        GameKitManager *gameKitManager = [GameKitManager sharedInstance];
        gameKitManager.delegate = self;
        [gameKitManager authenticateLocalPlayer];
    }
    
    [ADVTheme addGradientBackground:self.view];
    self.view.tintColor = [UIColor whiteColor];
    
    self.animationController = [[DropAnimationController alloc] init];
    
    self.levelLabel.textColor = [UIColor whiteColor];
    
    self.levelLabel.text = NSLocalizedString(@"Level","Tests taken so far");
    
    self.levelNumber.font = [UIFont fontWithName:[ADVTheme mainFont] size:72];
    self.levelNumber.textColor = [UIColor whiteColor];
    self.pointsLabel.textColor = [UIColor whiteColor];
    
    
    self.restorePurchase = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Restore purchases",@"")
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(onRetorePurchases:)];
    self.navigationItem.rightBarButtonItem = self.restorePurchase;
    
    self.scoresLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:16];
    self.scoresLabel.textColor = [UIColor whiteColor];
    self.scoresLabel.adjustsFontSizeToFitWidth = YES;
    self.scoresLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.scoresLabel.text = NSLocalizedString(@"LAST SCORE",@"Last Score");
    
    self.scoresProgress.chartBorderWidth = 8.0f;
    self.scoresProgress.chartBorderColor = [UIColor whiteColor];
    self.scoresProgress.fontName = [ADVTheme mainFont];
    
    UIImage* buttonBackground = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    buttonBackground = [buttonBackground imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.startButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:15.0f];
    
    // Start Training
    // Start Quiz
    NSString *startGameTitle;
    NSString *gameModeHeadline;
    
    switch ([GameModel sharedInstance].activeGameMode) {
        case GameModeTimeBasedCompetition:
            startGameTitle = NSLocalizedString(@"Start Quiz", @"Button Title: Game Mode Competition");
            gameModeHeadline = [NSString stringWithFormat:NSLocalizedString(@"GameModeTimeBased",@""),(CGFloat)[GameModel sharedInstance].gameTime / 60];
            break;
            
        case GameModeTrainig:
            startGameTitle = NSLocalizedString(@"Start Training", @"Button Title: Game Mode Training");
            gameModeHeadline = NSLocalizedString(@"GameModeTrainingBased",@"");
            break;
    }
    
    [self.startButton setTitle:startGameTitle forState:UIControlStateNormal];
    self.gameModeLabel.text = gameModeHeadline;
    self.gameModeLabel.textColor = [UIColor whiteColor];
    
    [self.chooseTopicsButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    self.chooseTopicsButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:15.0f];
    [self.chooseTopicsButton setTitle:NSLocalizedString(@"TOPICS",@"") forState:UIControlStateNormal];

    [self.challengesButton setHidden:YES];
    [self.challengesButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    self.challengesButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:15.0f];
    [self.challengesButton addTarget:self action:@selector(showChallengesTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.challengesButton setTitle:NSLocalizedString(@"SEE CHALLENGES",@"") forState:UIControlStateNormal];
    
    // See highscores
    [self.highScoreButton setHidden:NO];
    [self.highScoreButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    self.highScoreButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:15.0f];
    [self.highScoreButton addTarget:self action:@selector(showHighscores:) forControlEvents:UIControlEventTouchUpInside];
    [self.highScoreButton setTitle:NSLocalizedString(@"HIGHSCORES",@"") forState:UIControlStateNormal];
    
    [self.startButton addTarget:self action:@selector(startTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseTopicsButton addTarget:self action:@selector(chooseTopicsTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [[QuizIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
        }
        [self.refreshControl endRefreshing];
    }];
    
    BOOL isIPhone4 = [UIScreen mainScreen].bounds.size.height < 568;
    self.scoresBarChartHeightConstraint.constant = isIPhone4 ? 0 : 120;
    
    self.topStatsContainer.backgroundColor = [UIColor clearColor];
    self.buttonContainer.backgroundColor = [UIColor clearColor];
    self.scoresBarChartContainer.backgroundColor = [UIColor clearColor];
    self.spacerView.backgroundColor = [UIColor clearColor];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        self.topStatsContainerHeight.constant = 230;
    }
    
    // Save Effect
    lastLevel = [GameStats sharedInstance].currentLevel;
    
    self.effectView = [[UIVisualEffectView alloc] initWithFrame:self.view.bounds];
    self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effect = self.effectView.effect;
    
    self.effectView.effect = nil;
    
    self.levelUpView.layer.cornerRadius = 5;
    
}


-(void)displayCharts{
    NSArray* aggregates;
    
    switch ([GameModel sharedInstance].activeGameMode) {
        case GameModeTimeBasedCompetition:
            aggregates= [Datasource loadTimeBasedAggregates];
            break;
            
        case GameModeTrainig:
            aggregates= [Datasource loadTrainingAggregates];
            break;
    }
    
    CGFloat lastScore = [Utils getLastTestScore:aggregates];
    [self displayLevelAndStars];
    
    self.scoresProgress.progress = lastScore/100.0;
    
    NSInteger numberOfScoresToShow = 15;
    NSArray* scores = [Utils getLast:numberOfScoresToShow scoresFromAggregates:aggregates];
    NSArray* labels = [Utils getLast:numberOfScoresToShow labelsForAggregates:aggregates];
    
    NSDictionary* dataPoints = @{@"titles" : labels, @"values" : scores};
    
    if(self.scoresBarChart){
        [self.scoresBarChart removeFromSuperview];
        self.scoresBarChart = nil;
    }
    
    self.scoresBarChart = [[PNScrollBarChart alloc] initWithFrame:CGRectZero];
    self.scoresBarChart.translatesAutoresizingMaskIntoConstraints = false;
    self.scoresBarChart.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scoresBarChartContainer addSubview:self.scoresBarChart];
    
    [Utils addConstraintsToSuperView:self.scoresBarChartContainer andSubView:self.scoresBarChart withPadding:0];
    
    UIView* graphView = self.scoresBarChart.graphView;
    graphView.translatesAutoresizingMaskIntoConstraints = NO;
    [Utils addConstraintsToSuperView:self.scoresBarChartContainer  andSubView:graphView withPadding:0];
    
    (self.scoresBarChart).strokeColor = [UIColor whiteColor];
    (self.scoresBarChart).backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    [self.scoresBarChart setXLabels:dataPoints[@"titles"]];
    [self.scoresBarChart setYValues:dataPoints[@"values"]];
    [self.scoresBarChart setLegend:[NSString stringWithFormat:NSLocalizedString(@"Your Last %ld Scores",@"Headline in Reviewslist"), (long)numberOfScoresToShow]];
    [self.scoresBarChart strokeChart];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    [self animateOut];
    return YES;
}

-(void)animateIn{
    
    
    [self.view addSubview:self.effectView];
    
    [self.effectView.contentView addSubview:self.levelUpView];
    self.levelUpView.center = self.view.center;
    self.levelUpView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.levelUpView.alpha = 0;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.effectView.effect = self.effect;
        self.levelUpView.alpha = 1;
        self.levelUpView.transform = CGAffineTransformIdentity;
        
    }];
    
}

-(void)animateOut{
    [UIView animateWithDuration:0.3 animations:^{
        self.levelUpView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.levelUpView.alpha = 0;
        
        self.effectView.effect = nil;
        
    } completion:^(BOOL finished) {
        [self.levelUpView removeFromSuperview];
        [self.effectView removeFromSuperview];
    }];
}

/**
 Show current user level
 */
-(void)displayLevelAndStars {
    
    self.levelNumber.text = [NSString stringWithFormat:@"%ld", [GameStats sharedInstance].currentLevel];
    self.pointsLabel.text = [NSString stringWithFormat:@"%ld", [GameStats sharedInstance].lastPoints];
    self.star1.alpha = 0;
    self.star2.alpha = 0;
    self.star3.alpha = 0;
    
    if ([GameStats sharedInstance].numberOfSuccessfulTries >= 1) {
        
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            self.star1.alpha = 1.0;
        } completion:nil];
    }
    
    if ([GameStats sharedInstance].numberOfSuccessfulTries >= 2) {
        
        [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.star2.alpha = 1.0;
        } completion:nil];
    }
    
    if ([GameStats sharedInstance].numberOfSuccessfulTries >= 3) {
        
        [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
            self.star3.alpha = 1.0;
        } completion:nil];
    }
}

- (IBAction)onRetorePurchases:(id)sender {
    [[QuizIAPHelper sharedInstance] restorePurchases];
}

-(IBAction)startTapped:(id)sender{
    
    NSArray* topics = [Config sharedInstance].topics;
    
    NSMutableArray* availableTopics = [NSMutableArray array];
    for (Topic* topic in topics) {
        if([self canViewTopic:topic]){
            [availableTopics addObject:topic];
        }
    }
    
    [self startQuizFromTopics:availableTopics];
}

-(BOOL)canViewTopic:(Topic*) topic {
    
    if(topic.inAppPurchaseIdentifier && [Config sharedInstance].topicIAP.limitTopics){
        BOOL purchased = [[QuizIAPHelper sharedInstance] productPurchased:topic.inAppPurchaseIdentifier];
        
        BOOL purchasedAll = [[QuizIAPHelper sharedInstance] productPurchased:[Config sharedInstance].quizIAP.inAppPurchaseID];
        
        if(!(purchasedAll || purchased)){
            
            return NO;
        }
    }
    
    return YES;
}

-(IBAction)chooseTopicsTapped:(id)sender{
    
    NSString* segueIdentifier = [Config sharedInstance].showTopicsinGrid ? @"topics" : @"topics-tableView";
    [self performSegueWithIdentifier:segueIdentifier sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showInfo"]){
        
        QuestionInfoController* controller = segue.destinationViewController;
        controller.questions = self.selectedQuestions;
       
        
        controller.userPressedStartBlock = ^(){
            [self userDidStartQuiz];
        };
        
    }else if([segue.identifier isEqualToString:@"startTest"]){
        UINavigationController* controller = segue.destinationViewController;
        QuestionContainerController* c = (QuestionContainerController*)controller.topViewController;
        c.questions = self.selectedQuestions;

    } else if([segue.identifier isEqualToString:@"topics"] || [segue.identifier isEqualToString:@"topics-tableView"]){
        
        UINavigationController* nav = segue.destinationViewController;
        TopicCollectionController* controller = (TopicCollectionController*)nav.topViewController;
        controller.delegate = self;
    }else if ([segue.identifier isEqualToString:@"challenges"]){
        
        UINavigationController* nav = segue.destinationViewController;
        AvailableChallengesController* controller = (AvailableChallengesController*)nav.topViewController;
        controller.challenges = self.gamecenterChallengeInfos;
        /*if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            controller.transitioningDelegate = self;
            controller.modalPresentationStyle = UIModalPresentationCustom;
        }*/
        controller.userDidAcceptChallengeBlock = ^(GKChallenge* challenge) {
            NSArray* topics = [Config sharedInstance].topics;
            NSInteger questionCount = [Config sharedInstance].numberOfQuestionsToAnswer;
            [self startDirectQuizWithNumberOfQuestions:questionCount fromTopics:topics];
        };

    }
}



-(void)userDidStartQuiz{
    [self performSegueWithIdentifier:@"startTest" sender:self];
}

-(void)didSelectTopics:(NSArray *)topics{
    
    if(topics.count > 0){
        NSInteger questionCount = [GameModel sharedInstance].numberOfQuestions;

        if ([self IAPCheck]) {
            _pendingQuiz = @{@"topics": topics, @"numberOfQuestions": @(questionCount)};
            
            UIAlertController* alert =  [UIAlertController alertControllerWithTitle:[Config sharedInstance].quizIAP.messageTitle message:[Config sharedInstance].quizIAP.messageText preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* buyAction = [UIAlertAction actionWithTitle:[Config sharedInstance].quizIAP.messageBuy style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
                
                    [self buyProduct];
            }];
            
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[Config sharedInstance].quizIAP.messageCancel style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:buyAction];
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            return;
        }
        
        [self startDirectQuizWithNumberOfQuestions:questionCount fromTopics:topics];
    }
}

-(void)startQuizFromTopics:(NSArray*)topics {
    
    NSInteger questionCount = [GameModel sharedInstance].numberOfQuestions;
    
    // For training: fixed number from all topics
    // For Time based: unlimited Number. (countQuestions is 0) 
    

    _pendingQuiz = @{@"topics": topics, @"numberOfQuestions": @(questionCount)};
    
    if ([self IAPCheck] && [GameStats sharedInstance].currentLevel >= 4 &&  [GameStats sharedInstance].numberOfSuccessfulTries >= 3) {
        
        UIAlertController* alert =  [UIAlertController alertControllerWithTitle:[Config sharedInstance].quizIAP.messageTitle
                                                                        message:[NSString stringWithFormat:[Config sharedInstance].quizIAP.messageText,[Config sharedInstance].quizIAP.numberofFreeQuestions]
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* buyAction = [UIAlertAction actionWithTitle:[Config sharedInstance].quizIAP.messageBuy style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
            
            [self buyProduct];
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[Config sharedInstance].quizIAP.messageCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
             [self startQuiz];
        }];
        
        [alert addAction:buyAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    [self startQuiz];
}

-(void)startQuiz{
    
    if ([GameModel sharedInstance].activeGameMode == GameModeTrainig ) {
    
        self.selectedQuestions = [Utils loadQuestionsWithIncreasingLevelFromTopics:_pendingQuiz[@"topics"] forTotalNumberOfQuestions:((NSNumber*)_pendingQuiz[@"numberOfQuestions"]).integerValue];
    
    } else {
        
       self.selectedQuestions = [Utils loadQuestionsFromTopics:_pendingQuiz[@"topics"] forTotalNumberOfQuestions:((NSNumber*)_pendingQuiz[@"numberOfQuestions"]).integerValue minLevel:[GameStats sharedInstance].currentLevel] ;
    }
    
    [self performSegueWithIdentifier:@"showInfo" sender:self];
}

/**
 Returns YES if product is upgraded
 */
- (BOOL)IAPCheck {

    // the App comes with 100 free questions, User should buy for the last 900.
    
    // Check, if number of quiz is limited. (Studid, then you cant play any more)
        return  ![[QuizIAPHelper sharedInstance] productPurchased:[Config sharedInstance].quizIAP.inAppPurchaseID];
    
}

-(void)buyProduct{
    
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:[Config sharedInstance].quizIAP.inAppPurchaseID]) {
            [[QuizIAPHelper sharedInstance] buyProduct:product];
            
            *stop = YES;
        }
    }];
    
//    
//    [self startDirectQuizWithNumberOfQuestions:[Config sharedInstance].quizIAP.numberofFreeQuestions
//                                    fromTopics:_pendingQuiz[@"topics"]];
//    
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            
            [self startDirectQuizWithNumberOfQuestions:[_pendingQuiz[@"numberOfQuestions"] integerValue]
                                            fromTopics:_pendingQuiz[@"topics"]];
            *stop = YES;
        }
    }];
    
}

-(void)startDirectQuizWithNumberOfQuestions:(NSInteger)numberOfQuestions fromTopics:(NSArray*)topics{
    self.selectedQuestions = [Utils loadQuestionsFromTopics:topics forTotalNumberOfQuestions:numberOfQuestions minLevel:[GameStats sharedInstance].currentLevel];
    
    [self performSegueWithIdentifier:@"startTest" sender:self];
    
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


-(void)didLoadChallenges:(NSArray *)challenges{
    
    NSMutableArray* playerIDs = [NSMutableArray array];
    
    for (GKChallenge* challenge in challenges) {
        [playerIDs addObject:challenge.issuingPlayer.playerID];
    }
    
    [[GameKitManager sharedInstance] getPlayerInfo:playerIDs];

    self.gamecenterChallenges = challenges;
}

-(void)didReceivePlayerInfo:(NSArray *)players{
    
    NSMutableArray* infos = [NSMutableArray array];
    
    for (GKChallenge* challenge in self.gamecenterChallenges) {
        for (GKPlayer* player in players) {
            if([player.playerID isEqualToString:challenge.issuingPlayer.playerID]){
                NSDictionary* challengeInfo =  @{@"player" : player, @"challenge" : challenge};
                [infos addObject:challengeInfo];
            }
        }
    }
    self.gamecenterChallengeInfos = infos;
    //self.challengesButton.hidden = (self.gamecenterChallengeInfos.count == 0);
    
    // TODO: Challenges is hidden in Storyboard, until re-implemented
    
}

-(IBAction)showChallengesTapped:(id)sender{
    [self performSegueWithIdentifier:@"challenges" sender:self];
}

-(IBAction)showHighscores:(id)sender {
    GameKitManager *gkManager = [GameKitManager sharedInstance];
    [gkManager showLeaderboard:[Config sharedInstance].gameCenterTimeBasedLeaderboardID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
