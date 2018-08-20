//
//  AppPayManager.m
//  TTTTttttt
//
//  Created by oahgnehzoul on 2018/8/20.
//  Copyright © 2018年 oahgnehzoul. All rights reserved.
//

#import "AppPayManager.h"

@interface AppPayManager()
@property (nonatomic, strong) NSString *productsId;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, strong) NSString *currencyCode;

@end
@implementation AppPayManager

- (void)launch {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self requestProductList];
}

- (void)requestProductList {
    NSLog(@"requestProductList");
}

- (void)terminate {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)buyProductsWithId:(NSString *)productsId andQuantity:(NSInteger)quantity {
    self.productsId = productsId;
    self.quantity = quantity;
    if ([SKPaymentQueue canMakePayments]) {
        [self RequestProductData:@[self.productsId]];
    } else {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"您的手机没有打开程序内付费购买" message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alerView show];
    }
}


- (void)RequestProductData:(NSArray *)productsIdArr {
    //请求对应的产品信息
    NSSet *nsset = [NSSet setWithArray:productsIdArr];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    //收到产品反馈信息
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int) [myProduct count]);
    // populate UI
    for (SKProduct *product in myProduct) {
        //        NSLog(@"product info");
        //        NSLog(@"  基本描述: %@", [product description]);
        //        NSLog(@"  IAP的id: %@", product.productIdentifier);
        //        NSLog(@"  地区编码: %@", product.priceLocale.localeIdentifier);
        //        NSLog(@"  本地价格: %@", product.price);
        //        NSLog(@"  语言代码: %@", [product.priceLocale objectForKey:NSLocaleLanguageCode]);
        //        NSLog(@"  国家代码: %@", [product.priceLocale objectForKey:NSLocaleCountryCode]);
        //        NSLog(@"  货币代码: %@", [product.priceLocale objectForKey:NSLocaleCurrencyCode]);
        //        NSLog(@"  货币符号: %@", [product.priceLocale objectForKey:NSLocaleCurgegrencySymbol]);
        //        NSLog(@"  本地标题: %@", product.localizedTitle);
        //        NSLog(@"  本地描述: %@", product.localizedDescription);
        [self updateProductPriceWithId:product.productIdentifier andPrice:product.price];
        if ([[product.priceLocale objectForKey:NSLocaleCurrencyCode] isEqualToString:@"CNY"]) {
            self.currencyCode = @"￥";
        } else {
            self.currencyCode = [product.priceLocale objectForKey:NSLocaleCurrencySymbol];
        }
    }
    //发送购买请求
    for (SKProduct *prct in myProduct) {
        if ([self.productsId isEqualToString:prct.productIdentifier]) {
            SKMutablePayment *payment = nil;
            payment = [SKMutablePayment paymentWithProduct:prct];
            payment.quantity = self.quantity;
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
    }
}

- (void)updateProductPriceWithId:(NSString *)productIdentifier andPrice:(NSDecimalNumber *)price{
    NSLog(@"productIdentifier == %@",productIdentifier);
    NSLog(@"price == %@",price);
}

#pragma mark - SKPaymentTransactionObserver
//----监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    //交易结果
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased: {
                //交易完成
                [self completeTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateFailed: {
                //交易失败
                [self failedTransaction:transaction];
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"交易失败" message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
                [alerView show];
            }
                break;
            case SKPaymentTransactionStateRestored: {
                //已经购买过该商品
                [self restoreTransaction:transaction];
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"已经购买过该商品" message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
                [alerView show];
            }
                break;
            case SKPaymentTransactionStatePurchasing: {
                //商品添加进列表
                NSLog(@"商品添加进列表");
            }
                break;
            case SKPaymentTransactionStateDeferred: {
                NSLog(@"SKPayment Transaction State Deferred");
            }
                break;
            default:
                break;
        }
    }
}
- (void)failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled) { }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易恢复处理");
}


- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"-----completeTransaction--------");
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];}
    }
}


//记录交易
- (void)recordTransaction:(NSString *)product{
    NSLog(@"记录交易--product == %@",product);
}

//处理下载内容
- (void)provideContent:(NSString *)product{
    NSLog(@"处理下载内容--product == %@",product);
}
@end
