//
//  CubeEnumurator.h
//  MyHelloWorld
//
//  Created by Jan Brond on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CubeEnumurator : NSObject
<NSNetServiceDelegate, NSNetServiceBrowserDelegate>{
    
    NSNetServiceBrowser *browser;
    NSMutableArray *services;
	NSMutableDictionary *serverAddresses;
    
    NSString *serviceIP;
    
}
+ (CubeEnumurator *) instance;
@property (nonatomic, retain) NSNetServiceBrowser *browser;
@property (nonatomic, retain) NSMutableArray *services;
@property (nonatomic, retain) NSString *serviceIP;

-(void) resolveIPAddress:(NSNetService *)service;
-(void) browseServices;
-(NSData *) getCubeAddress:(NSString *) cubeName;

@end
