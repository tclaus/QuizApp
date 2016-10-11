//
//  ViewController.m
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "TopicCollectionController.h"
#import "QuestionInfoController.h"
#import "TopicCell.h"
#import "TopicTableCell.h"
#import "Topic.h"
#import "Config.h"
#import "ADVTheme.h"
#import "Utils.h"
#import "QuizIAPHelper.h"

@interface TopicCollectionController ()

@property (nonatomic, strong) NSArray* selectedQuestions;

@property (nonatomic, strong) Topic* topicToPurchase;

@end

@implementation TopicCollectionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.topics = [Config sharedInstance].topics;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = NSLocalizedString(@"Select Topics",@"Seelct topics for questions");
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [ADVTheme addGradientBackground:self.view];
    self.view.tintColor = [UIColor whiteColor];
    
    self.layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.layout.minimumInteritemSpacing = 5;
    self.layout.minimumLineSpacing = 5;
    
   // self.layout.itemSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? CGSizeMake(150, 200) : CGSizeMake(175, 236);
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.topics.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    TopicCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopicCell" forIndexPath:indexPath];
    
    Topic* topic = self.topics[indexPath.row];
    
    cell.topicTitle.text = topic.title;
    cell.topicImageView.image = topic.image;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.topics.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TopicTableCell"];
    
    Topic* topic = self.topics[indexPath.row];
    
    cell.topicTitle.text = topic.title;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Topic* topic = self.topics[indexPath.row];
    
    if (![self canViewTopic:topic]){
        
        self.topicToPurchase = topic;
        [self displayInAppPurchaseAlert];
        
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Topic* topic = self.topics[indexPath.row];
    
    if (![self canViewTopic:topic]){
        
        self.topicToPurchase = topic;
        [self displayInAppPurchaseAlert];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)displayInAppPurchaseAlert{
    
    UIAlertController* alert =  [UIAlertController alertControllerWithTitle:[Config sharedInstance].quizIAP.messageTitle message:[Config sharedInstance].quizIAP.messageText preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* buyCurrent = [UIAlertAction actionWithTitle:[Config sharedInstance].topicIAP.messageBuy style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        
        [self buyCurrentTopic];
    }];
    
    UIAlertAction* buyAll = [UIAlertAction actionWithTitle:[Config sharedInstance].topicIAP.messageBuyAll style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        
        [self buyAllTopics];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[Config sharedInstance].quizIAP.messageCancel style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:buyAll];
    [alert addAction:buyCurrent];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)buyCurrentTopic{
    [self buyProduct:self.topicToPurchase.inAppPurchaseIdentifier];
}

-(void)buyAllTopics{
    [self buyProduct:[Config sharedInstance].topicIAP.inAppPurchaseID];
}


-(BOOL)canViewTopic:(Topic*) topic {
    
    if(topic.inAppPurchaseIdentifier && [Config sharedInstance].topicIAP.limitTopics){
        BOOL purchased = [[QuizIAPHelper sharedInstance] productPurchased:topic.inAppPurchaseIdentifier];
        
        BOOL purchasedAll = [[QuizIAPHelper sharedInstance] productPurchased:[Config sharedInstance].quizIAP.inAppPurchaseID];
        
        if(!(purchasedAll || purchased)){
            
            return NO;
        }
    }
    
    return YES;
}

-(void)buyProduct:(NSString*) productIdentifier{
    
    BOOL productFound;
    for (SKProduct* product in [QuizIAPHelper sharedInstance].products) {
        if([product.productIdentifier isEqualToString:productIdentifier]){
            [[QuizIAPHelper sharedInstance] buyProduct:product];
            productFound = YES;
            break;
        }
    }
    
    if(!productFound){
        
        UIAlertController* alert =  [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Product Not Found",@"") message:NSLocalizedString(@"Oops something went wrong",@"") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[Config sharedInstance].quizIAP.messageCancel style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(IBAction)didTapStartButton:(id)sender{
    NSArray* indexPaths = (self.collectionView).indexPathsForSelectedItems;
    if(!indexPaths){
        indexPaths = (self.tableView).indexPathsForSelectedRows;
    }
    
    if(indexPaths.count == 0){
        
         UIAlertController* alert =  [UIAlertController alertControllerWithTitle:NSLocalizedString(@"No Topics Selected",@"") message:NSLocalizedString(@"Please select one or more topics to take the quiz",@"") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[Config sharedInstance].quizIAP.messageCancel style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];

    }else{
        

        NSMutableArray* selectedTopics = [NSMutableArray array];
        for (NSIndexPath* indexPath in indexPaths) {
            [selectedTopics addObject:self.topics[indexPath.row]];
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate didSelectTopics:selectedTopics];
        }];
    }
}

-(IBAction)didTapCancelButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
