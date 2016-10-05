//
//  QuestionViewController.m
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "QuestionViewController.h"
#import "AnswerCell.h"
#import "Answer.h"
#import "ADVTheme.h"
#import "SoundSystem.h"
#import <AVFoundation/AVFoundation.h>

@interface QuestionViewController ()

@property (nonatomic, weak) IBOutlet UIImageView* questionImageView;

@property (nonatomic, weak) IBOutlet UIView* headerView;

@property (nonatomic, weak) IBOutlet UILabel* questionLabel;

@property (nonatomic, weak) IBOutlet UITableView* answerTableView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topMarginConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomMarginConstraint;

@property (nonatomic, weak) IBOutlet UIButton* answerButton;

@property (nonatomic, weak) IBOutlet UIView* footerView;

@property (nonatomic, assign) BOOL correctAnswerShown;

@property (nonatomic, assign) BOOL answerTapped;

@property (nonatomic, strong) NSArray* alphabets;

@property (nonatomic, strong) SoundSystem* soundSystem;

-(void)showCorrectAnswer;

@end

@implementation QuestionViewController

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
    
    self.answerTableView.delegate = self;
    self.answerTableView.dataSource = self;
    self.answerTableView.estimatedRowHeight = 90.0;
    self.answerTableView.rowHeight = UITableViewAutomaticDimension;

  
    self.view.tintColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    [ADVTheme addGradientBackground:self.view];
    
    self.answerTableView.backgroundColor = [UIColor clearColor];
    self.answerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImage* buttonBackground = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    buttonBackground = [buttonBackground imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage* buttonDisabledBackground = [[UIImage imageNamed:@"button-disabled"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    buttonDisabledBackground = [buttonDisabledBackground imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.answerButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [self.answerButton setBackgroundImage:buttonDisabledBackground forState:UIControlStateDisabled];
    self.answerButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:19.0f];
    [self.answerButton addTarget:self action:@selector(answerTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.answerButton setTitle:NSLocalizedString(@"NEXT QUESTION",@"") forState:UIControlStateNormal];
    self.answerButton.enabled = NO;
    self.answerButton.hidden = self.isForReview;

    self.footerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    toolbar.barStyle = UIBarStyleBlack;
    [self.footerView insertSubview:toolbar belowSubview:self.answerButton];
    self.footerView.hidden = self.isForReview;
    
    
    self.headerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    
    // The Question Label
    CGFloat fontSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 25 : 21;
    self.questionLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:fontSize];
    self.questionLabel.textColor = [UIColor whiteColor];
    self.questionLabel.numberOfLines = 0;
    
    self.questionImageView.contentMode = UIViewContentModeScaleAspectFit;
     
    self.alphabets = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    self.soundSystem = [[SoundSystem alloc] init];
    
    self.topMarginConstraint.constant = self.isForReview ? 10 : 70;
    self.bottomMarginConstraint.constant = self.isForReview ? 0 : 60;
    
    [self loadData];
}



-(void)loadData{
    
    self.answerTableView.allowsMultipleSelection = (self.question).numberOfCorrectAnswers > 1;
    self.answerButton.enabled = NO;
    self.questionLabel.text = self.question.text;
    self.correctAnswerShown = NO;
    self.answerTapped = NO;

    if(self.question.image){

        self.imageViewConstraint.constant = 135;
        
        UIImage* image = [UIImage imageNamed:self.question.image];
        self.questionImageView.image = image;
  
    }else{
        self.imageViewConstraint.constant = 0;
        self.questionImageView.image = nil;
    }
    
    [self.answerTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.question.answers.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AnswerCell* cell = nil;
    Answer* answer = self.question.answers[indexPath.row];
    
    // If the answer contains an image - show the image instead of text
    if(answer.image){
        cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCellImage"];
        cell.answerImageView.image = [UIImage imageNamed:answer.image];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCell"];
        cell.answerLabel.text = answer.text;
    }
    cell.answerTapped = self.answerTapped;
    cell.indexLabel.text = [self getAlphabetFromIndex:indexPath.row];
    cell.isForReview = self.isForReview;
    cell.backgroundColor = [UIColor clearColor];
    
    cell.indexLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:19.0f];
    
    if(self.isForReview || self.answerTapped){
        BOOL isChosenAnswer = [self.question indexIsChosenAnswer:indexPath.row];
        BOOL isCorrectAnswer = [self.question indexIsCorrectAnswer:indexPath.row];
        
        [cell showImageForCorrectAnswer:isCorrectAnswer AndChosenAnswer:isChosenAnswer];
        cell.isCorrect = isCorrectAnswer;
    }

    /*[cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    
    //cell.answerLabel.preferredMaxLayoutWidth = CGRectGetWidth(cell.answerLabel.frame);
    [cell.contentView layoutIfNeeded];
     */
    
    cell.contentView.alpha = 1.0f;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    [self doAnswerButtonState];
    
}

/*
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self doAnswerButtonState];
}
*/


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

   
    Answer* answer = self.question.answers[indexPath.row];
    
    if(answer.image){
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 170 : 90;
    }else{
         AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCell"];
        
        cell.answerLabel.text = answer.text;
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        //// for separator
        height += 1.0f;
       // NSLog(@"%f",height);
        return height;
    }
    
}

-(void)goToNextQuestion {
    [self.delegate questionHasBeenAnswered:self.question withController:self];
}



-(void)doAnswerButtonState{
    
    NSIndexPath* indexPath = self.answerTableView.indexPathForSelectedRow;
    Answer* answer = self.question.answers[indexPath.row];
    answer.chosen = YES;
    

    [self showCorrectAnswer];
    

    // Tap on right answer => Play happy sound => Mark as right => next
    // Tap on flase answer => Play sad sound / Vibrate => Mark as false => next
    
    
}

-(void)showCorrectAnswer{
    
    self.correctAnswerShown = YES;
    
    BOOL answeredCorrect;
    
    if((self.question).hasBeenAnsweredCorrectly){
        answeredCorrect = YES;
        [self.soundSystem playHappySound];
        
    }else{
        answeredCorrect = NO;
        [self.soundSystem vibrate];
    }
    
    
        for (NSInteger i = 0; i < self.question.answers.count; i++) {

            AnswerCell* cell = (AnswerCell*)[self.answerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            Answer* answer = self.question.answers[i];
            
            if (answer.correct){
                
                [cell showCorrectAnswerWithAnimation:^{
                    [self goToNextQuestion];
                }];
                
            }else if (!answeredCorrect) {
                [cell showWrongAnswerWithAnimation];
            }
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)getAlphabetFromIndex:(NSInteger)index{
    
    return self.alphabets[index % self.alphabets.count];
}

@end
