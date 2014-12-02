//
//  SHQNetworkingUtility.m
//  ShaqAttack
//
//  Created by Rachel Hyman on 11/28/14.
//  Copyright (c) 2014 Rachel Hyman. All rights reserved.
//

#import "SHQNetworkingUtility.h"

static NSString *loginURLString = @"http://localhost:4567/login";
static NSString *shaqEndpointURLString = @"http://localhost:4567/shaqendpoint";
static NSString *makeShaqFragmentURLString = @"?basketballs=";

@interface SHQNetworkingUtility ()

@property (nonatomic, strong) NSString *storedAuthString;

@end

@implementation SHQNetworkingUtility

+ (SHQNetworkingUtility *)sharedInstance
{
    static SHQNetworkingUtility *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SHQNetworkingUtility new];
    });
    return instance;
}

+ (NSURLSession *)urlSessionWithAuthString:(NSString *)authString
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{@"Authorization": authString};
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    return session;
}

+ (NSString *)storedAuthString
{
    return [self sharedInstance].storedAuthString;
}

+ (void)getRequestToUrl:(NSString *)urlString withCompletionHandler:(SHQNetworkingBlock)handler
{
    NSURLSessionDataTask *dataTask = [[self urlSessionWithAuthString:[self storedAuthString]] dataTaskWithURL:[NSURL URLWithString:urlString]
                                                                                        completionHandler:handler];
    
    [dataTask resume];
}

+ (void)postRequestToUrl:(NSString *)urlString withCompletionHandler:(SHQNetworkingBlock)handler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *dataTask = [[self urlSessionWithAuthString:[self storedAuthString]] dataTaskWithRequest:request completionHandler:handler];
    
    [dataTask resume];
}

+ (void)deleteRequestToUrl:(NSString *)urlString withCompletionHander:(SHQNetworkingBlock)handler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"DELETE";
    
    NSURLSessionDataTask *dataTask = [[self urlSessionWithAuthString:[self storedAuthString]] dataTaskWithRequest:request completionHandler:handler];
    
    [dataTask resume];
}

+ (void)logInWithAuthString:(NSString *)authString completionHandler:(SHQNetworkingBlock)handler
{
    [self sharedInstance].storedAuthString = authString;
    NSAssert([self sharedInstance].storedAuthString, @"no auth string stored");
    [self getRequestToUrl:loginURLString withCompletionHandler:handler];
}

+ (void)makeShaqWithBasketballs:(NSString *)basketballs completionHandler:(SHQNetworkingBlock)handler
{
    NSString *makeShaqURL = [[shaqEndpointURLString stringByAppendingString:makeShaqFragmentURLString] stringByAppendingString:basketballs];
    [self postRequestToUrl:makeShaqURL withCompletionHandler:handler];
}

+ (void)checkShaqTotalsWithCompletionHandler:(SHQNetworkingBlock)handler
{
    [self getRequestToUrl:shaqEndpointURLString withCompletionHandler:handler];
}

+ (void)deleteShaqWithCompletionHandler:(SHQNetworkingBlock)handler;
{
    [self deleteRequestToUrl:shaqEndpointURLString withCompletionHander:handler];
}

@end
