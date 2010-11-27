//
//  ChimpKit.m
//  ChimpKit2
//
//  Created by Amro Mousa on 11/19/10.
//  Copyright 2010 return7, LLC. All rights reserved.
//

#import "ChimpKit.h"

@interface ChimpKit()

@end


@implementation ChimpKit

@synthesize apiUrl, apiKey, delegate, onSuccess, onFailure;

#pragma mark -
#pragma mark Initialization

-(void)setAPIKey:(NSString*)key {
    apiKey = key;
    if (apiKey) {
        //Parse out the datacenter and template it into the URL.
        NSArray *apiKeyParts = [apiKey componentsSeparatedByString:@"-"];
        if ([apiKeyParts count] > 1) {
            self.apiUrl = [NSString stringWithFormat:@"https://%@.api.mailchimp.com/1.3/?method=", [apiKeyParts objectAtIndex:1]];
        }
    }
}

-(id)initWithDelegate:(id)aDelegate andApiKey:(NSString *)key {
	self = [super init];
	if (self != nil) {
        self.apiUrl  = @"https://api.mailchimp.com/1.3/?method=";
        self.apiKey = key;
        self.delegate = aDelegate;
	}
	return self;
}

-(void)callAPIMethod:(NSString *)method withParams:(NSDictionary *)params {
    [self callAPIMethod:method withParams:params andUserInfo:nil];
}

-(void)callAPIMethod:(NSString *)method withParams:(NSDictionary *)params andUserInfo:(NSDictionary *)userInfo {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.apiUrl, method];

    if (apiKey) {
        urlString = [NSString stringWithFormat:@"%@&apikey=%@", urlString, apiKey];
    }

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setDelegate:self.delegate];
    [request setUserInfo:userInfo];
    [request setDidFinishSelector:self.onSuccess];
    [request setDidFailSelector:self.onFailure];
    [request setRequestMethod:@"POST"];

    if (params) {
        NSMutableData *postData = [NSMutableData dataWithData:[[params JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setPostBody:postData];
    }

    [request startAsynchronous];
}

//TODO: Stub out all version 1.3 API methods w/ required params and optional params in a single dictionary

- (void)dealloc {
    [apiKey release];
    [apiUrl release];
    [super dealloc];
}

@end