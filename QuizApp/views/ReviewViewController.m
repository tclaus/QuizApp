//
//  ReviewViewController.m
//  QuizApp
//
//  Created by Tope Abayomi on 31/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ReviewViewController.h"
#import "QuestionViewController.h"
#import "ReviewCell.h"
#import "ADVTheme.h"
#import <DasQuiz-Swift.h>

@import Firebase;

@interface ReviewViewController ()

@end

@implementation ReviewViewController


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

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [ADVTheme addGradientBackground:self.view];
    self.view.tintColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = NSLocalizedString(@"Review",@"");
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questions.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReviewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell"];
    
    Question* question = self.questions.listOfQuestions[indexPath.row];
    
    cell.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)indexPath.row + 1];
    cell.questionLabel.text = question.text;
    [cell showCorrectImage:question.hasBeenAnsweredCorrectly];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    Question* question = self.questions.listOfQuestions[indexPath.row];
    NSURL *explanatioinURL = [NSURL URLWithString:question.explanation];
    
    if ([[UIApplication sharedApplication] canOpenURL:explanatioinURL]) {
        return YES;
    } else {
        return NO;
    }
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    UITableViewRowAction *info = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                    title:@"Info"
                                                                  handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                      Question* question = self.questions.listOfQuestions[indexPath.row];
                                                                      NSURL *explanatioinURL = [NSURL URLWithString:question.explanation];
                                                                      
                                                                          [FIRAnalytics logEventWithName:@"ViewExplanation"
                                                                                              parameters:@{
                                                                                                           @"questionID": [NSNumber numberWithInteger: question.questionID]
                                                                                                           }];
                                                                          
                                                                          [[UIApplication sharedApplication] openURL:explanatioinURL];
                                                                      
                                                                  }];
    return @[info];
        
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"reviewDetail" sender:self];
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    ReviewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell"];
    
    Question* question = self.questions.listOfQuestions[indexPath.row];
    
    CGSize labelSize = CGSizeMake(cell.questionLabel.frame.size.width, MAXFLOAT);
    CGRect labelRect;
    if (question.text.length > 0)
        labelRect = [question.text boundingRectWithSize:labelSize
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:  @{NSFontAttributeName:[UIFont systemFontOfSize:22],
                                                            NSParagraphStyleAttributeName: paragraphStyle.copy}
                                                context:nil];
  
   
    return 24.0 + labelRect.size.height;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath* indexPath = (self.tableView).indexPathForSelectedRow;
    Question* question = self.questions.listOfQuestions[indexPath.row];
    
    QuestionViewController* controller = segue.destinationViewController;
    controller.question = question;
    controller.isForReview = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
