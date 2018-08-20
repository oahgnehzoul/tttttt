//
//  AppPayManager.h
//  TTTTttttt
//
//  Created by oahgnehzoul on 2018/8/20.
//  Copyright © 2018年 oahgnehzoul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface AppPayManager : NSObject

+ (AppPayManager *)manager;

- (void)buyProductsWithId:(NSString *)productsId andQuantity:(NSInteger)quantity;

@end
