//
//  ResultCell.m
//  QuizApp
//
//  Created by Tope Abayomi on 31/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ReviewCell.h"
#import "ADVTheme.h"

@interface ReviewCell ()

@property (nonatomic, strong) UIImage* correctImage;

@property (nonatomic, strong) UIImage* wrongImage;

@end

@implementation ReviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    CGFloat labelSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 20.0f : 14.0f;
    CGFloat countSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 32.0f : 22.0f;
    
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.font = [UIFont fontWithName:[ADVTheme boldFont] size:countSize];
    
    self.questionLabel.textColor = [UIColor whiteColor];
    self.questionLabel.font = [UIFont fontWithName:[ADVTheme mainFont] size:labelSize];
    
    self.correctImage = [[UIImage imageNamed:@"tick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.wrongImage = [[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showCorrectImage:(BOOL)correct{
    if (correct) {
        self.resultImageView.image = self.correctImage;
    }else{
        self.resultImageView.image = self.wrongImage;
    }
}

@end
