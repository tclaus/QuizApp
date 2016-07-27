//
//  AvailableChallengesController.m
//  QuizApp
//
//  Created by Tope Abayomi on 17/02/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import "AvailableChallengesController.h"
#import "ADVTheme.h"
#import "ChallengeCell.h"
#import "GameKitManager.h"

@interface AvailableChallengesController ()

@end

@implementation AvailableChallengesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    self.view.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor blackColor];
    self.tableView.backgroundColor = [UIColor blackColor];
    
    UIImage* buttonBackground = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    buttonBackground = [buttonBackground imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.titleLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:15.0f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = @"Here are your available challenges. Please choose one";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChallengeCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChallengeCell"];
    
    NSDictionary* challengeInfo = self.challenges[indexPath.row];
    GKPlayer* player = challengeInfo[@"player"];
    GKChallenge* challenge = challengeInfo[@"challenge"];
    
    cell.nameLabel.text = player.displayName;
    cell.messageLabel.text = challenge.message;
    cell.challenge = challenge;
    
    cell.userDidTapAcceptButtonBlock = ^(id challenge) {
        [self acceptChallenge:(GKChallenge*)challenge];
    };

    
    [player loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error) {
        if (!error) {
            cell.avatarImageView.image = photo;
        } else {
            NSLog(@"Error loading image");
        }
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)acceptChallenge:(GKChallenge*)challenge{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.userDidAcceptChallengeBlock != nil) {
            self.userDidAcceptChallengeBlock(challenge);
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.challenges.count;
}

-(IBAction)cancelButtonTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
