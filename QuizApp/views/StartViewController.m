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

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface StartViewController ()

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, weak) IBOutlet UILabel* subtitleLabel;

@property (nonatomic, weak) IBOutlet UIImageView* mainImageView;

@property (weak, nonatomic) IBOutlet UIButton *gameModeButton1;
@property (weak, nonatomic) IBOutlet UIButton *gameModeButton2;

@end

@implementation StartViewController

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
    
    CGFloat titleFontSize = 13;
    CGFloat subtitleFontSize = 9;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        if(self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
            titleFontSize = 19;
            subtitleFontSize = 16;
        }
    }
    
    //self.titleLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:titleFontSize];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.text = [Config sharedInstance].startPageDescription;
    
    //self.subtitleLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:subtitleFontSize];
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
//    [self.startButton addTarget:self action:@selector(startTapped:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)startTapped:(id)sender{
    
    // Set Game ModeØ
    
    UIButton *button = (UIButton*)sender;
    if (button.tag == 0) {
        [GameModel sharedInstance].activeGameMode = GameModeTimeBasedCompetition;
    }
    
    if (button.tag == 1) {
        [GameModel sharedInstance].activeGameMode = GameModeTrainig;
    }
    
    [self performSegueWithIdentifier:@"start" sender:self];
}

#pragma mark -
- (IBAction)openFacebook:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/DasQuiz-1225048260850398/"]];
    
}
- (IBAction)openSendMail:(id)sender {
    // Email Subject
    NSString *emailTitle = @"DAS!Quiz auf iOS";
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://appstore.com/dasquiz"]];
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
