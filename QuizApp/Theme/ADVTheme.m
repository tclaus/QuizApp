//
//  ADVTheme.m
//  MovieBeam
//
//  Created by Tope Abayomi on 07/11/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ADVTheme.h"
#import "UIImageAverageColorAddition.h"
#import "Config.h"
#import "Utils.h"

@implementation ADVTheme

+ (NSString*)boldFont{
    NSString* boldFont = [Config sharedInstance].boldFont;
    return boldFont;
}

+ (NSString*)mainFont{
    
    NSString* mainFont = [Config sharedInstance].mainFont;
    return mainFont;
}

+ (UIColor*)mainColor{
    NSString* backgroundImage = [Config sharedInstance].mainBackground;
    UIImage* image = [UIImage imageNamed:backgroundImage];
    
    return [image averageColor];
}

+ (UIColor*)foregroundColor{
    return [UIColor whiteColor];
}

+ (UIColor*)viewBackgroundColor:(UIView*)view{
    
    NSString* backgroundImage = [Config sharedInstance].mainBackground;
    
    UIImage * targetImage = [UIImage imageNamed:backgroundImage];
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
    [targetImage drawInRect:CGRectMake(0.f, 0.f, view.frame.size.width*2, view.frame.size.height*5)];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:resultImage];
}

+ (void)addGradientBackground:(UIView*)view{
    
    NSString* backgroundImage = [Config sharedInstance].mainBackground;
    UIImage* bgImage = [UIImage imageNamed:backgroundImage];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    imageView.image = bgImage;
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    [view insertSubview:imageView atIndex:0];
    
    [Utils addConstraintsToSuperView:view andSubView:imageView withPadding:0];
    
}

+(void)customizeTheme{
    
    NSString* backgroundImage = [Config sharedInstance].mainBackground;
    UIImage* image = [UIImage imageNamed:backgroundImage];
    UIColor* navigationColor = [image averageColor];
    
    [UINavigationBar appearance].tintColor = [self foregroundColor];
    [UINavigationBar appearance].barTintColor = navigationColor;
    NSMutableDictionary* navbarAttributes = [NSMutableDictionary dictionary];
    navbarAttributes[NSFontAttributeName] = [UIFont fontWithName:[self boldFont] size:19.0f];
    navbarAttributes[NSForegroundColorAttributeName] = [self foregroundColor];
    [UINavigationBar appearance].titleTextAttributes = navbarAttributes;

    NSMutableDictionary* barButtonAttributes = [NSMutableDictionary dictionary];
    barButtonAttributes[NSFontAttributeName] = [UIFont fontWithName:[self boldFont] size:14.0f];
    barButtonAttributes[NSForegroundColorAttributeName] = [self foregroundColor];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAttributes forState:UIControlStateNormal];
}

+(void)customizeTabBar:(UITabBar*)tabBar{
    
    int index = 1;
    for (UITabBarItem* tabItem in tabBar.items) {
        NSString* imageName = [NSString stringWithFormat:@"tab%d", index++];
        tabItem.image =[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(5.0, 0.0, -5.0, 0.0);
        tabItem.imageInsets = insets;
    }
}

@end
