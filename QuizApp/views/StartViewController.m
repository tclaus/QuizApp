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

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface StartViewController ()

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, weak) IBOutlet UILabel* subtitleLabel;

@property (nonatomic, weak) IBOutlet UIImageView* mainImageView;

@property (nonatomic, weak) IBOutlet UIButton* startButton;

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
    
    [self.startButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:15.0f];
    [self.startButton setTitle:NSLocalizedString(@"START",@"") forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(startTapped:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)startTapped:(id)sender{
    
    [self performSegueWithIdentifier:@"start" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
