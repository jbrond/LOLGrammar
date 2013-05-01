//
//  wordClass.m
//  MyHelloWorld
//
//  Created by Jan Brond on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "wordClass.h"

@implementation wordClass

@synthesize position;
@synthesize type;

-(wordClass*) init:(int) pos:(grammarSymbolType) t
{
    self = [super init];
    if(self) {
        
        self->position = pos;
        self->type = t;
        
        return self;
    }
    
    return nil;
}
@end
