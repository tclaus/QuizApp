//
//  TopicCell.h
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel* topicTitle;

@property (nonatomic, weak) IBOutlet UIImageView* topicImageView;

@property (nonatomic, weak) IBOutlet UIView* overlayView;

@property (nonatomic, weak) IBOutlet UIImageView* tickImageView;


@end
