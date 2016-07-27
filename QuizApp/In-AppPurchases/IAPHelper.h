//
//  IAPHelper.h
//  QuizApp
//
//  Created by Valentin Filip on 24/05/14.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);




@interface IAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

- (instancetype)initWithProductIdentifiers:(NSSet *)productIdentifiers NS_DESIGNATED_INITIALIZER;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;
- (void)restorePurchases;

@property (nonatomic, strong) NSArray* products;

@end
