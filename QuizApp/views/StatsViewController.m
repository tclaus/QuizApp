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

@interface StatsViewController () <TopicCollectionControllerDelegate, QuestionInfoControllerDelegate, GameKitManagerProtocol, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet ADVRoundProgressChart* scoresProgress;

@property (nonatomic, strong) PNScrollBarChart* scoresBarChart;

@property (nonatomic, weak) IBOutlet UIView* scoresBarChartContainer;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* scoresBarChartHeightConstraint;

@property (nonatomic, weak) IBOutlet UILabel* testsTakenCount;

@property (nonatomic, weak) IBOutlet UILabel* testsTakenLabel;

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

@end

@implementation StatsViewController

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
    
    self.testsTakenLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:16];
    self.testsTakenLabel.textColor = [UIColor whiteColor];
    self.testsTakenLabel.adjustsFontSizeToFitWidth = YES;
    self.testsTakenLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.testsTakenLabel.text = @"TESTS TAKEN";
    
    self.testsTakenCount.font = [UIFont fontWithName:[ADVTheme mainFont] size:72];
    self.testsTakenCount.textColor = [UIColor whiteColor];
    self.testsTakenLabel.adjustsFontSizeToFitWidth = YES;
    self.testsTakenCount.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    self.restorePurchase = [[UIBarButtonItem alloc] initWithTitle:@"Restore purchases"
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(onRetorePurchases:)];
    self.navigationItem.rightBarButtonItem = self.restorePurchase;
    
    self.scoresLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:16];
    self.scoresLabel.textColor = [UIColor whiteColor];
    self.scoresLabel.adjustsFontSizeToFitWidth = YES;
    self.scoresLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.scoresLabel.text = @"LAST SCORE";
    
    self.scoresProgress.chartBorderWidth = 4.0f;
    self.scoresProgress.chartBorderColor = [UIColor whiteColor];
    self.scoresProgress.fontName = [ADVTheme mainFont];
    
    UIImage* buttonBackground = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    buttonBackground = [buttonBackground imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.startButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:15.0f];
    [self.startButton setTitle:@"START TEST" forState:UIControlStateNormal];
    
    [self.chooseTopicsButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    self.chooseTopicsButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:15.0f];
    [self.chooseTopicsButton setTitle:@"TOPICS" forState:UIControlStateNormal];

    [self.challengesButton setHidden:NO];
    [self.challengesButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    self.challengesButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:15.0f];
    [self.challengesButton addTarget:self action:@selector(showChallengesTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.challengesButton setTitle:@"SEE CHALLENGES" forState:UIControlStateNormal];
    
    // See highscores
    [self.highScoreButton setHidden:NO];
    self.highScoreButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:15.0f];
    [self.highScoreButton addTarget:self action:@selector(showHighscores:) forControlEvents:UIControlEventTouchUpInside];
    [self.highScoreButton setTitle:@"HIGHSCORES" forState:UIControlStateNormal];
    
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
}

-(void)displayCharts{
    NSArray* aggregates = [Datasource loadAggregates];
    CGFloat lastScore = [Utils getLastTestScore:aggregates];
    
    self.scoresProgress.progress = lastScore/100.0;
    self.testsTakenCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)aggregates.count];
    
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
    [self.scoresBarChart setLegend:[NSString stringWithFormat:@"Your Last %ld Scores", (long)numberOfScoresToShow]];
    [self.scoresBarChart strokeChart];
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
        NSInteger questionCount = [Config sharedInstance].numberOfQuestionsToPractice;

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
    NSInteger questionCount = [Config sharedInstance].numberOfQuestionsToAnswer;

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
    
    self.selectedQuestions = [Utils loadQuestionsFromTopics:topics forTotalNumberOfQuestions:questionCount];
    
    [self performSegueWithIdentifier:@"showInfo" sender:self];

}


- (BOOL)IAPCheck {

    return [Config sharedInstance].quizIAP.limitQuestions
    && ([Datasource loadAggregates].count >= [Config sharedInstance].quizIAP.numberofFreeQuizzes
        && ![[QuizIAPHelper sharedInstance] productPurchased:[Config sharedInstance].quizIAP.inAppPurchaseID]);
}

-(void)buyProduct{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
            if ([product.productIdentifier isEqualToString:[Config sharedInstance].quizIAP.inAppPurchaseID]) {
                [[QuizIAPHelper sharedInstance] buyProduct:product];
                
                *stop = YES;
            }
        }];
        
        return;
    }
    
    [self startDirectQuizWithNumberOfQuestions:[Config sharedInstance].quizIAP.numberofFreeQuestions
                                    fromTopics:_pendingQuiz[@"topics"]];
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
    self.selectedQuestions = [Utils loadQuestionsFromTopics:topics forTotalNumberOfQuestions:numberOfQuestions];
    
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
    self.challengesButton.hidden = (self.gamecenterChallengeInfos.count == 0);
}

-(IBAction)showChallengesTapped:(id)sender{
    [self performSegueWithIdentifier:@"challenges" sender:self];
}

-(IBAction)showHighscores:(id)sender {
    GameKitManager *gkManager = [GameKitManager sharedInstance];
    [gkManager showLeaderboard:@"TopScoresLeaderboard"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
