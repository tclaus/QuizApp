//
//  StartViewController.m
//  QuizApp
//
//  Created by Tope Abayomi on 05/03/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "StartViewController.h"

#import "ADVTheme.h"
#import "Config.h"
#import "GameModel.h"

@import FirebaseAnalytics;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface StartViewController ()

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, weak) IBOutlet UILabel* subtitleLabel;

@property (nonatomic, weak) IBOutlet UIImageView* mainImageView;

@property (weak, nonatomic) IBOutlet UIButton *gameModeButton1;
@property (weak, nonatomic) IBOutlet UIButton *gameModeButton2;
@property (weak, nonatomic) IBOutlet UIButton *mailSendButton;

@end

@implementation StartViewController

static NSString * const reviewURLTemplate                   = @"itms-apps://itunes.apple.com/app/id1136679552";
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
    
    self.title = [Config sharedInstance].startPageTitle;
    
    [ADVTheme addGradientBackground:self.view];
    
    self.view.tintColor = [UIColor whiteColor];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.text = [Config sharedInstance].startPageDescription;
    
    
    self.subtitleLabel.textColor = [UIColor whiteColor];
    self.subtitleLabel.numberOfLines = 0;
    self.subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.subtitleLabel.text = [Config sharedInstance].startPageSubDescription;
    
    NSString* mainImage = [Config sharedInstance].startPageImage;
    self.mainImageView.image = [UIImage imageNamed:mainImage];
    
    UIImage* buttonBackground = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    buttonBackground = [buttonBackground imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.gameModeButton1 setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [self.gameModeButton2 setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    
    //self.startButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:15.0f];
    
    
    NSString *mode1Text = [NSString stringWithFormat:NSLocalizedString(@"GameModeTimeBased",@""), (CGFloat)[Config sharedInstance].timeNeededInMinutes];
    
    [self.gameModeButton1 setTitle:mode1Text forState:UIControlStateNormal];
    [self.gameModeButton2 setTitle:NSLocalizedString(@"GameModeTrainingBased",@"") forState:UIControlStateNormal];

    self.mailSendButton.enabled = [MFMailComposeViewController canSendMail];
    
}

-(IBAction)startTapped:(id)sender{
    
    // Set Game ModeØ
    
    UIButton *button = (UIButton*)sender;
    if (button.tag == 0) {
        
        [FIRAnalytics logEventWithName:kFIREventViewItem parameters:@{
                                                                      kFIRParameterItemName:@"Time Based Game",
                                                                      kFIRParameterItemID:@"TimeBasedGame"
                                                                      }];
        
        [GameModel sharedInstance].activeGameMode = GameModeTimeBasedCompetition;
    }
    
    if (button.tag == 1) {
        
        [FIRAnalytics logEventWithName:kFIREventViewItem parameters:@{
                                                                      kFIRParameterItemName:@"Training Game",
                                                                      kFIRParameterItemID:@"TrainingGame"
                                                                      }];
        
        [GameModel sharedInstance].activeGameMode = GameModeTrainig;
    }
    
    [self performSegueWithIdentifier:@"start" sender:self];
}

#pragma mark -

- (IBAction)addQuestionButtonTouched:(id)sender {
    
    [FIRAnalytics logEventWithName:kFIREventViewItem parameters:@{
                                                                  kFIRParameterItemName:@"Open AddQuestion View",
                                                                  kFIRParameterItemID:@"OpenAddQuestion"
                                                                  }];
}

- (IBAction)settingsButton:(id)sender {
}

- (IBAction)openSendMail:(id)sender {
    // Email Subject
    NSString *emailTitle = NSLocalizedString(@"THE!Quiz on iOS",@"THE!Quiz on iOS");
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"info@claus-software.de"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}

- (IBAction)openAppStore:(id)sender {
    // reviewURLTemplate
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURLTemplate] options:@{} completionHandler:nil];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
