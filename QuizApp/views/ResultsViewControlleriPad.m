//
//  ResultsViewControlleriPad.m
//  QuizApp
//
//  Created by Tope Abayomi on 07/03/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "ResultsViewControlleriPad.h"
#import "ADVRoundProgressChart.h"
#import "Utils.h"
#import "ADVTheme.h"
#import "Config.h"
#import "GameKitManager.h"
#import "GameChallengeController.h"
#import "ReviewCell.h"
#import "Question.h"
#import "QuestionViewController.h"
#import "ReviewViewController.h"

@interface ResultsViewControlleriPad ()

@property (nonatomic, weak) IBOutlet ADVRoundProgressChart* resultsChart;

@property (nonatomic, weak) IBOutlet UIButton* challengeFriendsButton;

@property (nonatomic, weak) IBOutlet UIButton* reviewButton;

@property (nonatomic, weak) IBOutlet UILabel* infoLabel;

@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, weak) IBOutlet UIView* chartView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* chartConstraintTop;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* chartConstraintLeft;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* tableConstraintTop;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* tableConstraintRight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* tableConstraintBottom;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* tableConstraintCenterX;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* chartConstraintCenterX;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* tableConstraintTopPortrait;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* tableConstraintBottomPortrait;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* chartConstraintTopPortrait;

@property (nonatomic, strong)  NSArray* landscapeConstraints;
@property (nonatomic, strong)  NSArray* portraitConstraints;

@end

@implementation ResultsViewControlleriPad

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
    
	CGFloat fractionCorrect = [Utils calculateCorrectScore:self.questions];
    NSInteger correctCount = [Utils calculateNumberOfCorrectAnswers:self.questions];
    
    [self reportAchievementToGameCenter:fractionCorrect*100];
    
    self.resultsChart.chartBorderWidth = 4.0f;
    self.resultsChart.chartBorderColor = [UIColor whiteColor];
    self.resultsChart.fontName = [ADVTheme mainFont];
    self.resultsChart.progress = fractionCorrect;
    self.resultsChart.backgroundColor = [UIColor clearColor];
    
    self.resultsChart.detailText =[NSString stringWithFormat:NSLocalizedString(@"%lu of %lu answers",@""), (long)correctCount, (unsigned long)self.questions.count];
    
    self.title = NSLocalizedString(@"Results",@"");
    
    UIImage* buttonBackground = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    buttonBackground = [buttonBackground imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    

    if([Config sharedInstance].gameCenterEnabled){
        
        [self.challengeFriendsButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
        self.challengeFriendsButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:16.0f];
        [self.challengeFriendsButton setTitle:NSLocalizedString(@"CHALLENGE FRIENDS",@"") forState:UIControlStateNormal];
    }else{
        self.challengeFriendsButton.hidden = YES;
    }
    
    [self.reviewButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    self.reviewButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:16.0f];
    [self.reviewButton setTitle:NSLocalizedString(@"REVIEW TEST",@"") forState:UIControlStateNormal];
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()){
        self.reviewButton.hidden = YES;
    }
    
    
    self.infoLabel.text = NSLocalizedString(@"Here are your results",@"");
    self.infoLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:16.0f];
    self.infoLabel.textColor = [ADVTheme foregroundColor];
    
    
    [ADVTheme addGradientBackground:self.view];
    self.view.tintColor = [UIColor whiteColor];
    
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped:)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


-(void)reportAchievementToGameCenter:(CGFloat)percentScore{
    if([Config sharedInstance].gameCenterEnabled){
        NSString* leaderboardID = [Config sharedInstance].gameCenterLeaderboardID;
        [[GameKitManager sharedInstance] submitTestResult:percentScore forLeaderboard:leaderboardID];
        [[GameKitManager sharedInstance] reportAchievementsTestResult:percentScore];
    }
}

-(IBAction)challengeFriendsTapped:(id)sender{
    
    [self performSegueWithIdentifier:@"challenge" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"reviewDetail"]){
        
        NSIndexPath* indexPath = (self.tableView).indexPathForSelectedRow;
        Question* question = self.questions[indexPath.row];
        
        QuestionViewController* controller = segue.destinationViewController;
        controller.question = question;
        controller.isForReview = YES;
    }else if([segue.identifier isEqualToString:@"review"]){
        
        ReviewViewController* controller = segue.destinationViewController;
        controller.questions = self.questions;
    }
}

-(IBAction)doneTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)reviewButtonTapped:(id)sender{
    [self performSegueWithIdentifier:@"review" sender:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questions.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReviewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
    
    Question* question = self.questions[indexPath.row];
    
    cell.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)indexPath.row + 1];
    cell.questionLabel.text = question.text;
    [cell showCorrectImage:question.hasBeenAnsweredCorrectly];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"reviewDetail" sender:self];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    //[self loadConstraintsForOrientation:toInterfaceOrientation];
}

-(void)loadConstraintsForOrientation:(UIInterfaceOrientation)orientation{
    
    [self removeAllConstraints];
    
    if(UIInterfaceOrientationIsLandscape(orientation)){
        
        [self.view addConstraints:self.landscapeConstraints];
    }else{
        
        [self.view addConstraints:self.portraitConstraints];
    }
}

- (void)initializeConstraints{
    
    
    self.chartConstraintTop = [NSLayoutConstraint constraintWithItem:self.chartView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeCenterY multiplier:1
                                                          constant:0];
    
    self.chartConstraintLeft = [NSLayoutConstraint constraintWithItem:self.chartView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft multiplier:1
                                                           constant:26];
    
    self.tableConstraintTop = [NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop multiplier:1
                                                           constant:11];
    
    self.tableConstraintRight = [NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing multiplier:1
                                                           constant:-20];
    
    self.tableConstraintBottom = [NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom multiplier:1
                                                           constant:0];
   
    self.landscapeConstraints = @[self.tableConstraintBottom, self.tableConstraintRight, self.tableConstraintTop, self.chartConstraintLeft, self.chartConstraintTop];
    
    
    self.chartConstraintTopPortrait = [NSLayoutConstraint constraintWithItem:self.chartView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeTop multiplier:1
                                                            constant:50];
    
    self.tableConstraintTopPortrait = [NSLayoutConstraint constraintWithItem:self.tableView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeTop multiplier:1
                                                            constant:500];

    self.tableConstraintBottomPortrait = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeBottom
                                                                     multiplier:1
                                                                    constant:0];


    
    self.chartConstraintCenterX = [NSLayoutConstraint constraintWithItem:self.chartView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1 constant:0];
    
    
    self.tableConstraintCenterX = [NSLayoutConstraint constraintWithItem:self.tableView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1 constant:0];
    
    self.portraitConstraints = @[self.tableConstraintTopPortrait, self.tableConstraintBottomPortrait, self.chartConstraintTopPortrait, self.tableConstraintCenterX, self.chartConstraintCenterX];
    
}

-(void)removeAllConstraints{
    NSArray* constraints = self.view.constraints;
    
    for (NSLayoutConstraint* constraint in constraints) {
        [self.view removeConstraint:constraint];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
