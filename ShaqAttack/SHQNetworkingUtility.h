//
//  SHQNetworkingUtility.h
//  ShaqAttack
//
//  Created by Rachel Hyman on 11/28/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SHQNetworkingBlock)(NSData *data, NSURLResponse *response, NSError *error);

@interface SHQNetworkingUtility : NSObject

+ (void)logInWithAuthString:(NSString *)authString completionHandler:(SHQNetworkingBlock)handler;
+ (void)makeShaqWithBasketballs:(NSString *)basketballs completionHandler:(SHQNetworkingBlock)handler;
+ (void)checkShaqTotalsWithCompletionHandler:(SHQNetworkingBlock)handler;
+ (void)deleteShaqWithCompletionHandler:(SHQNetworkingBlock)handler;

@end
