//
//  GameChallengeController.m
//  QuizApp
//
//  Created by Tope Abayomi on 17/02/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#define kPlayerKey @"player"
#define kScoreKey @"score"
#define kIsChallengedKey @"isChallenged"

#import "GameChallengeController.h"
#import "FriendCell.h"
#import "ADVTheme.h"

@interface GameChallengeController ()

@property (nonatomic, assign) int64_t score;

@end

@implementation GameChallengeController

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
    
    _dataSource = [NSMutableDictionary dictionary];
    
    GameKitManager *gameKitHelper = [GameKitManager sharedInstance];
    gameKitHelper.delegate = self;
    [gameKitHelper findMyFriends];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    self.view.tintColor = [UIColor whiteColor];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIImage* buttonBackground = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    buttonBackground = [buttonBackground imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.challengeButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    self.challengeButton.titleLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:16.0f];
    [self.challengeButton setTitle:NSLocalizedString(@"SEND CHALLENGE",@"") forState:UIControlStateNormal];
    
    [self.closeButton setTitle:NSLocalizedString(@"Close",@"") forState:UIControlStateNormal];
    (self.closeButton).tintColor = [UIColor blueColor];
    
    
    self.titleLabel.text = NSLocalizedString(@"CHALLENGE FRIENDS",@"");
    self.titleLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:15.0f];
    self.titleLabel.textColor = [UIColor whiteColor];
    
    [self.challengeButton addTarget:self action:@selector(challengeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.closeButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancelButtonPressed:(id) sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.cancelButtonPressedBlock != nil) {
        self.cancelButtonPressedBlock();
    }
}

- (void)challengeButtonPressed:(id) sender {
   
    NSMutableArray *playerIds = [NSMutableArray array];
    NSArray *allValues = _dataSource.allValues;
    
    for (NSDictionary *dict in allValues) {
        if ([dict[kIsChallengedKey] boolValue] == YES) {
            
            GKPlayer *player = dict[kPlayerKey];
            [playerIds addObject:player.playerID];
        }
    }
    
    if (playerIds.count > 0) {
        
        NSString* message = @"You have been challenged to a duel! Try beating my score";
        UIViewController* controller = [[GameKitManager sharedInstance] challengePlayers:playerIds withScore:_score andMessage:
         message];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
}

-(void)didIssueChallengeWithController:(UIViewController *)controller{
    
    [controller dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)didLoadScoresToChallenge:(NSArray*) scores {
    if(scores.count == 0){
        GameKitManager *gameKitHelper = [GameKitManager sharedInstance];
        gameKitHelper.delegate = self;
        [gameKitHelper findMyFriends];
        return;
    }
    NSMutableArray *playerIds = [NSMutableArray array];

    for (GKScore* score in scores) {
        
        if(_dataSource[score.player.playerID] == nil) {
            _dataSource[score.player.playerID] = [NSMutableDictionary dictionary];
            [playerIds addObject:score.player.playerID];
        }
        
        if (score.value < _score) {
            NSMutableDictionary* playerScore = _dataSource[score.player.playerID];
            playerScore[kIsChallengedKey] = @YES;
        }
        
        _dataSource[score.player.playerID][kScoreKey] = score;
    }
    
    [[GameKitManager sharedInstance] getPlayerInfo:playerIds];
    [self.tableView reloadData];
}

-(void)didReceiveFriendsList:(NSArray*)players{
    
    for (GKPlayer* player in players) {
        
        if(_dataSource[player.playerID] == nil){
            _dataSource[player.playerID] = [NSMutableDictionary dictionary];
        }
        
        NSMutableDictionary* playerScore = _dataSource[player.playerID];
        playerScore[kIsChallengedKey] = @NO;
        
        GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"Leaderboard"];
        score.value = 3;;
        _dataSource[player.playerID][kScoreKey] = score;
    }
    
    NSMutableArray *playerIds = [NSMutableArray array];
    for (GKPlayer* player in players) {
        [playerIds addObject:player.playerID];
    }
    
    [[GameKitManager sharedInstance] getPlayerInfo:playerIds];
    [self.tableView reloadData];
}

-(void)didReceivePlayerInfo:(NSArray*)players {
    
    [players enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        GKPlayer *player = (GKPlayer*)obj;
        if (_dataSource[player.playerID] == nil) {
            _dataSource[player.playerID] = [NSMutableDictionary dictionary];
            
        }
        _dataSource[player.playerID][kPlayerKey] = player;
        [self.tableView reloadData];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    
    NSDictionary *dict = _dataSource.allValues[indexPath.row];

    GKPlayer *player = dict[kPlayerKey];
    
    [player loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error) {
        if (!error) {
            cell.avatarImageView.image = photo;
        } else {
            NSLog(@"Error loading image");
        }
    }];
    
    cell.nameLabel.text = player.displayName;
    cell.scoreLabel.text = @"";
    cell.backgroundColor = [UIColor clearColor];
    
    BOOL isChallenged = [dict[kIsChallengedKey] boolValue];
    cell.tickImageView.hidden = !isChallenged;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendCell *cell = (FriendCell*)[tableView cellForRowAtIndexPath:indexPath];
    UIImageView *tickMark = cell.tickImageView;
    
    tickMark.hidden = !tickMark.hidden;
    
    NSArray *array = _dataSource.allValues;
    NSMutableDictionary *dict = array[indexPath.row];
    
    dict[kIsChallengedKey] = [NSNumber numberWithBool:!tickMark.hidden];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
