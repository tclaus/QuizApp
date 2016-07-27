//
//  ResultCell.h
//  QuizApp
//
//  Created by Tope Abayomi on 31/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel* countLabel;

@property (nonatomic, strong) IBOutlet UILabel* questionLabel;

@property (nonatomic, strong) IBOutlet UIImageView* resultImageView;

@property (nonatomic, strong) IBOutlet UIImageView* bottomBorderImageView;

-(void)showCorrectImage:(BOOL)correct;

@end
