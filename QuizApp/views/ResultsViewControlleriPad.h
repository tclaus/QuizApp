//
//  ResultsViewControlleriPad.h
//  QuizApp
//
//  Created by Tope Abayomi on 07/03/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewControlleriPad : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray* questions;

@end
