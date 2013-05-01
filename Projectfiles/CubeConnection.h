//
//  CubeConnection.h
//  LOLGramatik
//
//  Created by Jan Brond on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "CubeCommand.h"

//This class takes care of the connection
//It implements an observer pattern
//Its a singleton

@interface CubeConnection : NSObject {
    GCDAsyncSocket *cube1Connection;
    GCDAsyncSocket *cube2Connection;
}

+ (CubeConnection *) instance;
- (void)connectToCube1:(NSData*) addr;
- (void)connectToCube2:(NSData*) addr;
@end
