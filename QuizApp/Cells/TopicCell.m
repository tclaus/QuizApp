//
//  TopicCell.m
//  QuizApp
//
//  Created by Tope Abayomi on 18/12/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "TopicCell.h"
#import "ADVTheme.h"

@implementation TopicCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.topicTitle.font = [UIFont fontWithName:[ADVTheme boldFont] size:16.0f];
    self.topicTitle.textColor = [UIColor whiteColor];
    self.topicTitle.numberOfLines = 0;
    
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    
    self.tickImageView.alpha = 0.0;
}

-(void)setSelected:(BOOL)selected{
    super.selected = selected;
    
    self.tickImageView.alpha = selected ? 1.0 : 0.0;
}


@end
