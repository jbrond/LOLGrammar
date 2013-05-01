//
//  CubeConnection.m
//  LOLGramatik
//
//  Created by Jan Brond on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CubeConnection.h"

@implementation CubeConnection

-(void) allocConnections
{
    cube1Connection = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    cube2Connection = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)connectToCube1:(NSData*) addr
{
	BOOL done = NO;
    
    NSLog(@"Attempting connection to %@", addr);
    
    if ([cube1Connection isConnected]) {
        [cube1Connection disconnect];
    }
    
    NSError *err = nil;
    if ([cube1Connection connectToAddress:addr error:&err])
    {
        done = YES;
        
        [cube1Connection readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
        
    }
    else
    {
        NSLog(@"Unable to connect: %@", err);
    }
    
}

- (void)connectToCube2:(NSData*) addr
{
	BOOL done = NO;
    
    NSLog(@"Attempting connection to %@", addr);
    
    if ([cube2Connection isConnected]) {
        [cube2Connection disconnect];
    }
    
    NSError *err = nil;
    if ([cube2Connection connectToAddress:addr error:&err])
    {
        done = YES;
        
        [cube2Connection readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
        
    }
    else
    {
        NSLog(@"Unable to connect: %@", err);
    }
}

-(cubeMessage) resolveCommand:(NSString*) cmd
{
    if ([cmd compare:@"BL"] == 0) {
        return msgBalance;
    }
    if ([cmd compare:@"OG"] == 0) {
        return msgOrientation;
    }
    if ([cmd compare:@"SS"] == 0) {
        return msgShakeStart;
    }
    if ([cmd compare:@"SE"] == 0) {
        return msgShakeEnd;
    }
    if ([cmd compare:@"SD"] == 0) {
        return msgShakeDetected;
    }
    if ([cmd compare:@"HT"] == 0) {
        return msgHit;
    }
    if ([cmd compare:@"TR"] == 0) {
        return msgTiltRight;
    }
    if ([cmd compare:@"TL"] == 0) {
        return msgTiltLeft;
    }
    if ([cmd compare:@"TS"] == 0) {
        return msgTiltShake;
    }
    
    if ([cmd compare:@"TD"] == 0) {
        return msgThrow;
    }
    
    return msgNone;
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	// This method is executed on the socketQueue (not the main thread)
	
	dispatch_async(dispatch_get_main_queue(), ^{
		//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
		NSString *msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
        
        //NSString *hostname = [[[NSString alloc] initWithData:@"Hostname: @", [sock connectedHost]] autorelease ];
        
        //
        //NSLog(@"Str: %@",[sock connectedHost]);
        
		if (msg)
		{
            NSArray *fields = [msg componentsSeparatedByString:@":"];
            
            //float value = 0.0;
            
            if ([fields count]>1) {
                NSString * scmd = [[fields objectAtIndex:0] mutableCopy];
                NSString * value = [[fields objectAtIndex:1] mutableCopy];
                
                cubeMessage cmd = [self resolveCommand:scmd];
                
                //NSLog(@"Str: %@ Cmd: %d",msg,cmd);
                //Object holding the information about the command from the cube
                CubeCommand * message = [CubeCommand alloc];
                
                [message setMessage:cmd];
                [message setIValue:[value intValue]];
                [message setFValue:[value floatValue]]; 
                
                if (sock == cube1Connection) {
                    [message setCubeId:1];
                }
                if (sock == cube2Connection) {
                    [message setCubeId:2];
                }
                
                NSDictionary *messageCommand = [NSDictionary dictionaryWithObject:message forKey:@"messageCommand"];
                //
                //posting the message to whoever wants to respond to the message
                //
                [[NSNotificationCenter defaultCenter] postNotificationName:@"cubeMessage" object:nil userInfo:messageCommand];
                
            }
            
        }
		
	});
    
    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}


- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"Socket:DidConnectToHost: %@ Port: %hu", host, port);
	
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"SocketDidDisconnect:WithError: %@", err);
    
}

- (id) initSingleton
{
    if ((self = [super init]))
    {
        [self allocConnections];
    }
    
    return self;
}

+ (CubeConnection *) instance
{
    // Persistent instance.
    static CubeConnection *_default = nil;
    
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
                      _default = [[CubeConnection alloc] initSingleton];
                  });
#else
    // Allocates once using the old approach, it's slower.
    // It's thread safe.
    @synchronized([CubeConnection class])
    {
        // The synchronized instruction will make sure,
        // that only one thread will access this point at a time.
        if (_default == nil)
        {
            _default = [[CubeConnection alloc] initSingleton];
        }
    }
#endif
    return _default;
}

@end
