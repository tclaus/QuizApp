//
//  ViewController.h
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopicCollectionControllerDelegate;

@interface TopicCollectionController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;

@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSArray* topics;

@property (nonatomic, assign) id<TopicCollectionControllerDelegate> delegate;

@end

@protocol TopicCollectionControllerDelegate <NSObject>

-(void)didSelectTopics:(NSArray*)topics;

@end
