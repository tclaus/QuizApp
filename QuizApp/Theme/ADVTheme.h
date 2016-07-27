//
//  ADVTheme.h
//  MovieBeam
//
//  Created by Tope Abayomi on 07/11/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADVTheme : NSObject

+ (NSString*)boldFont;
+ (NSString*)mainFont;
+ (UIColor*)mainColor;
+ (UIColor*)foregroundColor;
+ (UIColor*)viewBackgroundColor:(UIView*)view;
+ (void)addGradientBackground:(UIView*)view;

+(void)customizeTheme;
+(void)customizeTabBar:(UITabBar*)tabBar;

@end
