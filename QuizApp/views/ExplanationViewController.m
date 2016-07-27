//
//  ExplanationViewController.m
//  QuizApp
//
//  Created by Tope Abayomi on 05/03/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "ExplanationViewController.h"
#import "ADVTheme.h"

@interface ExplanationViewController ()

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, weak) IBOutlet UILabel* explanationLabel;

@property (nonatomic, weak) IBOutlet UIButton* doneButton;

@end

@implementation ExplanationViewController

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
	
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    self.view.tintColor = [UIColor whiteColor];
    
    self.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:15];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.text = @"Knowledge and Understanding";
    
    self.explanationLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:14];
    self.explanationLabel.textColor = [UIColor whiteColor];
    self.explanationLabel.numberOfLines = 0;
    self.explanationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.explanationLabel.text = self.explanationText;
    [self.explanationLabel sizeToFit];
    
    UIImage* buttonBackground = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    buttonBackground = [buttonBackground imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.doneButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    self.doneButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:19.0f];
    [self.doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.doneButton setTitle:@"OK" forState:UIControlStateNormal];
}

-(IBAction)doneButtonTapped:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
