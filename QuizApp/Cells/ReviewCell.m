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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    
    self.countLabel.textColor = [UIColor whiteColor];
    
    self.questionLabel.textColor = [UIColor whiteColor];
    
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
        self.tintColor = [UIColor greenColor];
    }else{
        self.resultImageView.image = self.wrongImage;
        self.tintColor = [UIColor redColor];
    }
}

@end
