//
//  ReviewViewController.h
//  QuizApp
//
//  Created by Tope Abayomi on 31/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Questions;
@interface ReviewViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, strong) Questions* questions;

@end
