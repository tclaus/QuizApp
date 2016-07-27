//
//  TopicTableCell.h
//  QuizApp
//
//  Created by Tope Abayomi on 13/03/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* topicTitle;

@property (nonatomic, weak) IBOutlet UIImageView* selectionImageView;

@end
