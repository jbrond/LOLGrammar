//
//  wordClass.h
//  MyHelloWorld
//
//  Created by Jan Brond on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum { verbal, subject } wordClassType;
typedef enum { no_symbol, cross_symbol, circle_symbol } grammarSymbolType;

//Contains the position and the type of word class
@interface wordClass : NSObject {
    int position;
    grammarSymbolType type;
}

-(wordClass*) init:(int) position:(grammarSymbolType) t;

@property (nonatomic) int position;
@property (nonatomic) grammarSymbolType type;
@end
