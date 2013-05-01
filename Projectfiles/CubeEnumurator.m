//
//  CubeEnumurator.m
//  MyHelloWorld
//
//  Created by Jan Brond on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CubeEnumurator.h"
#import "CubeServiceMessage.h"

@implementation CubeEnumurator

@synthesize browser;
@synthesize services;
@synthesize serviceIP;

-(void) netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    
    [self.services addObject:aNetService];
    NSLog(@"Found Service. Resolving address...");
    [self resolveIPAddress:aNetService];
    
    //[self.tbView reloadData];
    
}

-(void) resolveIPAddress:(NSNetService *)service {
    NSNetService *remoteService = service;
    remoteService.delegate = self;    
    [remoteService resolveWithTimeout:0];
}

-(void) browseServices {
    
    NSLog(@"Browsing for services!");
    
    self.services = [NSMutableArray new];
    self.browser = [NSNetServiceBrowser new];
    self.browser.delegate = self;
    
    serverAddresses = [NSMutableDictionary new];
    
    [serverAddresses removeAllObjects];
    
    [self.browser searchForServicesOfType:@"_ArtefactService._tcp." inDomain:@""];
    
    //debug.text = [debug.text stringByAppendingString:@"Listening...\n"];
}

-(void) netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    
    NSLog(@"Did not resolve");
}

-(void) netServiceDidResolveAddress:(NSNetService *)sender {

    //Adding the address for the specified name
    [serverAddresses setObject:[[sender addresses] mutableCopy] forKey:[sender name]];
    
    NSLog(@"%@ %@",[sender name],[sender addresses]);
}

-(void) netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    
    //Removing the addresses from the list
    for(unsigned int i=0;i< [services count];i++) {
        
        NSNetService * ns = [services objectAtIndex:i];
        
        NSString * name = [ns name];
        
        if ([name compare:[aNetService name]]==0) {
            [serverAddresses removeObjectForKey:name];
        }
    }
    
    CubeServiceMessage * csm = [CubeServiceMessage alloc];

    //setting the name of the service removed
    [csm setCubeName:[aNetService name]];
    
    NSDictionary *messageCommand = [NSDictionary dictionaryWithObject:csm forKey:@"cubeServiceMessage"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cubeServiceMessage" object:nil userInfo:messageCommand];
    
    [self.services removeObject:aNetService];
    
    NSLog(@"Removed: %@",[aNetService hostName]);
}

-(NSData *) getCubeAddress:(NSString *) cubeName
{
    NSData *addr;
    
    NSArray * addra = [serverAddresses objectForKey:cubeName];
    addr = [addra objectAtIndex:0];
    
    return addr;
}

- (id) initSingleton
{
    if ((self = [super init]))
    {
        //[self browseServices];
    }
    
    return self;
}

+ (CubeEnumurator *) instance
{
    // Persistent instance.
    static CubeEnumurator *_default = nil;
    
    // Small optimization to avoid wasting time after the
    // singleton being initialized.
    if (_default != nil)
    {
        return _default;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    // Allocates once with Grand Central Dispatch (GCD) routine.
    // It's thread safe.
    static dispatch_once_t safer;
    dispatch_once(&safer, ^(void)
                  {
                      _default = [[CubeEnumurator alloc] initSingleton];
                  });
#else
    // Allocates once using the old approach, it's slower.
    // It's thread safe.
    @synchronized([CubeEnumurator class])
    {
        // The synchronized instruction will make sure,
        // that only one thread will access this point at a time.
        if (_default == nil)
        {
            _default = [[CubeEnumurator alloc] initSingleton];
        }
    }
#endif
    return _default;
}

/*- (id) retain
{
    return self;
}

- (oneway void) release
{
    // Does nothing here.
}

- (id) autorelease
{
    return self;
}

- (NSUInteger) retainCount
{
    return INT32_MAX;
}*/
@end
