//
//  ReviewViewController.m
//  QuizApp
//
//  Created by Tope Abayomi on 20/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ResultsViewController.h"
#import "ReviewViewController.h"
#import "ADVTheme.h"
#import "Utils.h"
#import "GameKitManager.h"
#import "Config.h"
#import "GameChallengeController.h"
#import "DropAnimationController.h"
#import "GameModel.h"
#import "GameStats.h"


@interface ResultsViewController ()

@property (strong, nonatomic) IBOutlet UIView *nextLevelView;

@property (nonatomic, weak) IBOutlet ADVRoundProgressChart* resultsChart;

@property (nonatomic, weak) IBOutlet UIButton* reviewButton;

@property (nonatomic, weak) IBOutlet UIButton* challengeFriendsButton;

@property (nonatomic, weak) IBOutlet UILabel* infoLabel;

@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

@property (nonatomic, strong) id<ADVAnimationController> animationController;

@end

@implementation ResultsViewController

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
    
    NSInteger gamePoints = [Utils calculateCorrectScore:self.questions];
    CGFloat correctFraction = [Utils calculateCorrectPercent:self.questions];
    NSInteger correctCount = [Utils calculateNumberOfCorrectAnswers:self.questions];
    
    if ([GameModel sharedInstance].activeGameMode == GameModeTimeBasedCompetition) {
        [self reportAchievementToGameCenter:correctFraction points:gamePoints];
    }
    
    self.resultsChart.chartBorderWidth = 8.0f;
    self.resultsChart.chartBorderColor = [UIColor whiteColor];
    self.resultsChart.fontName = [ADVTheme mainFont];
    self.resultsChart.progress = correctFraction;
    self.resultsChart.backgroundColor = [UIColor clearColor];
    
    self.pointsLabel.text = [NSString stringWithFormat:@"%ld Points",(long)gamePoints];
    
    self.resultsChart.detailText =[NSString stringWithFormat:NSLocalizedString(@"%lu of %lu answers",@""), (long)correctCount, (unsigned long)self.questions.count];
    
    self.title = NSLocalizedString(@"Results",@"");
    
    UIImage* buttonBackground = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    buttonBackground = [buttonBackground imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.reviewButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];

    [self.reviewButton setTitle:NSLocalizedString(@"REVIEW TEST",@"") forState:UIControlStateNormal];
    
    if([Config sharedInstance].gameCenterEnabled){
    
        [self.challengeFriendsButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];

        [self.challengeFriendsButton setTitle:NSLocalizedString(@"CHALLENGE FRIENDS",@"") forState:UIControlStateNormal];
    }else{
        self.challengeFriendsButton.alpha = 0.0;
    }
    
    self.challengeFriendsButton.hidden = YES;
    
    self.infoLabel.text = NSLocalizedString(@"Here are your results",@"");

    self.infoLabel.textColor = [ADVTheme foregroundColor];
    self.pointsLabel.textColor = [ADVTheme foregroundColor];
    
    [ADVTheme addGradientBackground:self.view];
    
    self.view.tintColor = [UIColor whiteColor];
    
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped:)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    self.animationController = [[DropAnimationController alloc] init];
    
}


-(void)reportAchievementToGameCenter:(CGFloat)percentScore points:(NSInteger)points{
    if([Config sharedInstance].gameCenterEnabled){
        
        NSString* leaderboardID;
       
        if ([GameModel sharedInstance].activeGameMode == GameModeTimeBasedCompetition) {
          
            leaderboardID = [Config sharedInstance].gameCenterTimeBasedLeaderboardID;
            
            [[GameKitManager sharedInstance] submitTestResult:points forLeaderboard:leaderboardID];
            
            [[GameKitManager sharedInstance] reportAchievementsTestResult:percentScore];
            
            
            NSInteger time =  [Config sharedInstance].timeNeededInMinutes * 60;
            NSInteger questionsSolved = self.questions.count;
            
            CGFloat ratio = time / questionsSolved;
            
            [[GameKitManager sharedInstance] reportSpeedyAchievement:percentScore secondsPerQuestion:ratio];
            
        } else {
            // TODO: Endles game leaderboard
        }
        
       
    }
}


-(IBAction)reviewButtonTapped:(id)sender{
    [self performSegueWithIdentifier:@"review" sender:self];
}

-(IBAction)challengeFriendsTapped:(id)sender{
    
    [self performSegueWithIdentifier:@"challenge" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"review"]){
        
        ReviewViewController* controller = segue.destinationViewController;
        
        controller.questions = self.questions;
    }else if([segue.identifier isEqualToString:@"challenge"]){
        
        GameChallengeController* controller = segue.destinationViewController;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            controller.transitioningDelegate = self;
            controller.modalPresentationStyle = UIModalPresentationCustom;
        }
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


-(IBAction)doneTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
