//
//  QuestionViewController.m
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "QuestionViewController.h"
#import "AnswerCell.h"
#import "ADVTheme.h"
#import "SoundSystem.h"
#import <AVFoundation/AVFoundation.h>
#import <DasQuiz-Swift.h>

@interface QuestionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *questionCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLevelLabel;

@property (nonatomic, weak) IBOutlet UILabel* questionLabel;

@property (nonatomic, weak) IBOutlet UITableView* answerTableView;

@property (nonatomic, weak) IBOutlet UIView* footerView;

@property (nonatomic, assign) BOOL correctAnswerShown;

@property (nonatomic, assign) BOOL answerTapped;

@property (nonatomic, strong) NSArray* alphabets;

@property (nonatomic, strong) SoundSystem* soundSystem;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (strong, nonatomic) IBOutlet UIView *reportViewController;
@property (weak, nonatomic) IBOutlet UIStackView *reportTypesStackView;

@property (nonatomic) UIVisualEffectView* effectView;
@property (nonatomic) UIVisualEffect* effect;
@property (weak, nonatomic) IBOutlet UIButton *sendReportButton;


// Send successful View
@property (strong, nonatomic) IBOutlet UIView *reportSent;
@property (weak, nonatomic) IBOutlet UILabel *sentStatusLabel;

-(void)showCorrectAnswer;

@end

@implementation QuestionViewController

SendReport *sendReport;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(CGRect)screenBounds {
    return [[UIScreen mainScreen] bounds];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sendReport = [[SendReport alloc] init];
    
    self.answerTableView.delegate = self;
    self.answerTableView.dataSource = self;
    
    self.answerTableView.estimatedRowHeight = 70.0; // Ovcerwritten by iPhone 4
    self.answerTableView.rowHeight = 70.0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // get size, will only check if iphone 4S: 480, 5: 568, 6/7 : 667
        if ([self screenBounds].size.height == 480) {
            self.stackView.spacing = 10;
            self.questionLabel.font = [UIFont fontWithName:self.questionLabel.font.fontName size:16.0f];;
            self.answerTableView.estimatedRowHeight = 30.0;
            self.answerTableView.rowHeight = 30.0;
        }
        if (self.view.bounds.size.height == 568) {
            self.stackView.spacing = 15;
        }
        if (self.view.bounds.size.height > 568) {
            self.stackView.spacing = 25;
        }
    }
    
    UIColor *defaultColor = self.view.tintColor;
    
    self.view.tintColor = [UIColor whiteColor];
    
    self.reportViewController.tintColor = defaultColor;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    [ADVTheme addGradientBackground:self.view];
    
    self.answerTableView.backgroundColor = [UIColor clearColor];
    self.answerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

    self.footerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    toolbar.barStyle = UIBarStyleBlack;
    self.footerView.hidden = self.isForReview;
    
    
    // The Question Label
    self.questionLabel.textColor = [UIColor whiteColor];
    
    self.questionCategoryLabel.textColor = [UIColor whiteColor];
    self.questionLevelLabel.textColor = [UIColor whiteColor];
    
    self.alphabets = @[@"A)", @"B)", @"C)", @"D)", @"E)", @"F)", @"G)", @"H)", @"I)", @"J)", @"K)", @"L)", @"M)", @"N)", @"O)", @"P)", @"Q)", @"R)", @"S)", @"T)", @"U)", @"V)", @"W)", @"X)", @"Y)", @"Z)"];
    self.soundSystem = [SoundSystem sharedInstance];
    
    //self.topMarginConstraint.constant = self.isForReview ? 10 : 70;
    //self.bottomMarginConstraint.constant = self.isForReview ? 0 : 60;
    
    
    // Effects for Reports View
    self.effectView = [[UIVisualEffectView alloc] initWithFrame:self.view.bounds];
    self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effect = self.effectView.effect;
    
    self.effectView.effect = nil;
    
    [self loadData];
    [self showAnswersForReview];
    if (self.isForReview) {
        self.answerTableView.userInteractionEnabled = NO;
    }
}


-(void)loadData{
    
    self.questionLabel.text = self.question.text;
    self.questionCategoryLabel.text = self.question.category;
    self.questionLevelLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Level %ld", @"Level headline for question"), self.question.level];;
    self.correctAnswerShown = NO;
    self.answerTapped = NO;

    [self.answerTableView reloadData];
}

/**
    Show answers in review
 */
-(void)showAnswersForReview {
    if (self.isForReview){
        
        for (int rowID = 0; rowID < self.question.answers.count ;rowID++) {
            
            BOOL isChosenAnswer = [self.question indexIsChosenAnswerWithAnswerIndex:rowID];
            BOOL isCorrectAnswer = [self.question indexIsCorrectAnswerWithAnswerIndex:rowID];
            
            AnswerCell* cell = [self.answerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowID inSection:0]];
            
            if (isChosenAnswer || isCorrectAnswer) {
                [cell showImageForCorrectAnswer:isCorrectAnswer AndChosenAnswer:isChosenAnswer];
                
                if (isCorrectAnswer) {
                    [cell showCorrectAnswerWithAnimation];
                } else {
                    [cell showWrongAnswerWithAnimation];
                }
            }
        }
        
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.question.answers.count;
}

-(NSString*)getAlphabetFromIndex:(NSInteger)index{
    
    return self.alphabets[index % self.alphabets.count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AnswerCell* cell = nil;
    Answer* answer = self.question.answers[indexPath.row];
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCell"];
        cell.answerLabel.text = answer.text;
    cell.answerTapped = self.answerTapped;
    cell.indexLabel.text = [self getAlphabetFromIndex:indexPath.row];
    cell.isForReview = self.isForReview;
    cell.backgroundColor = [UIColor clearColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // get size, will only check if iphone 4S: 480, 5: 568, 6/7 : 667
        
        if ([self screenBounds].size.height == 480) {
            cell.indexLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:14.0f];
            cell.answerLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:16.0f];
            
        } else {
            cell.indexLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:19.0f];
            cell.answerLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:22.0f];
        }
        /*
        if (self.view.bounds.size.height == 568) {
            
        }
        if (self.view.bounds.size.height > 568) {
            
        }
         */
    }
    
    cell.contentView.alpha = 1.0f;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        [self doAnswerButtonState];
        self.answerTableView.userInteractionEnabled = NO;
}



-(CGFloat)heightOfCellWithIngredientLine:(NSString *)ingredientLine
                       withSuperviewWidth:(CGFloat)superviewWidth
{
    CGFloat labelWidth                  = superviewWidth - 30.0f;
    //    use the known label width with a maximum height of 100 points
    CGSize labelContraints              = CGSizeMake(labelWidth, 100.0f);
    
    NSStringDrawingContext *context     = [[NSStringDrawingContext alloc] init];
    
    CGRect labelRect                    = [ingredientLine boundingRectWithSize:labelContraints
                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:nil
                                                                       context:context];
    
    //    return the calculated required height of the cell considering the label
    return labelRect.size.height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    Answer* answer = self.question.answers[indexPath.row];
    
         AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCell"];
        
        cell.answerLabel.text = answer.text;
        
        
        CGFloat labelWidth                  = cell.answerLabel.frame.size.width;
        //    use the known label width with a maximum height of 100 points
        CGSize labelContraints              = CGSizeMake(labelWidth, MAXFLOAT);
        
        NSStringDrawingContext *context     = [[NSStringDrawingContext alloc] init];
        
        CGRect labelRect                    = [cell.answerLabel.text boundingRectWithSize:labelContraints
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                               attributes:@{
                                                                                            NSFontAttributeName : cell.answerLabel.font
                                                                                            }
                                                                           context:context];

        cell.answerLabel.frame = labelRect;
        
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        //// for separator
        // height += 1.0f;
        return height;
    
}


-(void)goToNextQuestion {
    [self.delegate questionHasBeenAnswered:self.question withController:self];
}



-(void)doAnswerButtonState{
    
    NSIndexPath* indexPath = self.answerTableView.indexPathForSelectedRow;
    Answer* answer = self.question.answers[indexPath.row];
    answer.chosen = YES;
    

    [self showCorrectAnswer];
    

}

-(void)showCorrectAnswer{
    
    self.correctAnswerShown = YES;
    
    
        if((self.question).hasBeenAnsweredCorrectly){
            [self.soundSystem playHappySound];
            
        }else{
            [self.soundSystem playFailureSound];
            [self.soundSystem vibrate];
        }
    
        for (NSInteger i = 0; i < self.question.answers.count; i++) {

            AnswerCell* cell = (AnswerCell*)[self.answerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            Answer* answer = self.question.answers[i];
            
            [cell showImageForCorrectAnswer:answer.correct AndChosenAnswer:answer.chosen];
            
            if (answer.correct){
                
                [cell showCorrectAnswerWithAnimation:^{
                         self.answerTableView.userInteractionEnabled = YES;
                         [self goToNextQuestion];
                    
                }];
                
            }else if (!answer.correct && answer.chosen ) {
                [cell showWrongAnswerWithAnimation];
            }
        
    }
}
- (IBAction)reportQuestion:(id)sender {
    
    
    [self.view addSubview:self.effectView];
    
    [self.effectView addSubview:self.reportViewController];
    
    self.reportViewController.center = self.effectView.center;
    self.reportViewController.alpha = 0;
    
    // reset selected Buttons
    for (UIButton *button in self.reportTypesStackView.subviews) {
        button.selected = NO;
    }
    
    self.sendReportButton.enabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.effectView.effect = self.effect;
        self.reportViewController.alpha = 1;
    }];
    
    
}


- (IBAction)dismissReportVC:(id)sender {
    // AKA Send..
    [self animateReportOut];
    
    // Get Type
    int reportType = 0;
    for (UIButton *button in self.reportTypesStackView.subviews) {
        if (button.selected) {
          reportType =  (int)button.tag;
            break;
        }
    }
    
    // Send question
    [sendReport sendReportWithQuestionID:self.question.questionID reason:reportType];
    
}
- (IBAction)cancelReportVC:(id)sender {
    [self animateReportOut];
}

-(void)animateReportOut{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.reportViewController.alpha = 0;
        
        self.effectView.effect = nil;
        
    } completion:^(BOOL finished) {
        [self.reportViewController removeFromSuperview];
        [self.effectView removeFromSuperview];
        
    }];
    
}


- (IBAction)reportTypeChecked:(id)sender {
    UIButton *tappedButton =  (UIButton*)sender;
    tappedButton.selected = YES;
    
    self.sendReportButton.enabled = YES; // Enable sending after first selection
    
    // unselect others
    for (UIButton *button in self.reportTypesStackView.subviews) {
        if (![button isEqual:tappedButton]) {
            button.selected = NO;
        }
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
