//
//  DropAnimationController.m
//  Notes
//
//  Created by Tope Abayomi on 25/07/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "DropAnimationController.h"
#import "UIImage+ImageEffects.h"

@implementation DropAnimationController

-(instancetype)init{
    self = [super init];
    
    if(self){
        
        self.presentationDuration = 0.6;
        self.dismissalDuration = 0.6;
    }
    
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    return self.isPresenting ? self.presentationDuration : self.dismissalDuration;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    if(self.isPresenting){
        [self executePresentationAnimation:transitionContext];
    }
    else{
        [self executeDismissalAnimation:transitionContext];
    }
    
}

-(void)executePresentationAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIView* inView = transitionContext.containerView;
    
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView* blurredView = [self getBlurredImage:fromViewController.view];
    blurredView.alpha = 0.0;
    [inView addSubview:blurredView];
    
    [inView addSubview:toViewController.view];
    
    CGPoint centerOffScreen = inView.center;
    
    centerOffScreen.y = (-1)*inView.frame.size.height;
    toViewController.view.center = centerOffScreen;
    
    [UIView animateWithDuration:self.presentationDuration delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:6.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        toViewController.view.center = inView.center;
        fromViewController.view.alpha = 0.6;
        blurredView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
    }];
}

-(void)executeDismissalAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIView* inView = transitionContext.containerView;
    
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView* blurredView = [self getBlurredImage:toViewController.view];
    blurredView.alpha = 1.0;
    [inView addSubview:blurredView];
    
    [inView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    CGPoint centerOffScreen = inView.center;
    centerOffScreen.y = (-1)*inView.frame.size.height;
    
    [UIView animateKeyframesWithDuration:self.dismissalDuration delay:0.0f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            
            CGPoint center = fromViewController.view.center;
            center.y += 50;
            fromViewController.view.center = center;
            blurredView.alpha = 0.0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            
            fromViewController.view.center = centerOffScreen;
            toViewController.view.alpha = 1.0;
            
        }];

        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

-(UIView*)getBlurredImage:(UIView*)view{
    UIGraphicsBeginImageContext(view.frame.size);
    [view drawViewHierarchyInRect:view.frame afterScreenUpdates:YES];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage* blurredImage = [image applyBlurWithRadius:2.0 tintColor:[UIColor colorWithWhite:0.0 alpha:0.4f] saturationDeltaFactor:1 maskImage:nil];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:view.frame];
    imageView.image = blurredImage;
    
    return imageView;
    
}
@end
