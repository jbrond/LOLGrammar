//
//  WordSelectionLayer.m
//  LOLGramatik
//
//  Created by Jan Brond on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "WordSelectionLayer.h"

@implementation WordSelectionLayer

//@synthesize wordSelection;
@synthesize  currentSymbol;

-(id) init {
    if( (self=[super init] )) {
        
        symbols = [NSMutableArray new];
        
        for (int n=0;n<3;n++) {
            CCSprite * symbol;
            
            NSString * fname = [[NSString alloc] initWithFormat:@"symbol_%d.png",(n+1)];
            
            symbol = [CCSprite spriteWithFile:fname];
            symbol.scale = [self getScale] * 0.75;
            
            [symbol setVisible:false];
            
            [self addChild:symbol];
            
            [symbols addObject:symbol];
        }
        
        CCSprite * symbol = [symbols objectAtIndex:0];
        
        [symbol setVisible:true];
        
    }
    
    return self;
}

-(void) updateSymbolVisibility
{
    for (unsigned int n=0;n<[symbols count];n++) {
        CCSprite * sprite = [symbols objectAtIndex:n];
        
        if (n == currentSymbol) {
            [sprite setVisible:true];
        } else {
            [sprite setVisible:false];
        }
    }
}

-(void) clearSymbol
{
    currentSymbol = no_symbol;
    
    [self updateSymbolVisibility];
    
}

-(void) setSymbol:(grammarSymbolType) symbol
{
    currentSymbol = symbol;
    
    [self updateSymbolVisibility];
}

-(grammarSymbolType) nextSymbol
{
    currentSymbol++;
    
    if (currentSymbol > circle_symbol) {
        currentSymbol = no_symbol;
    }
    
    [self updateSymbolVisibility];
    
    return currentSymbol;
}

-(grammarSymbolType) previousSymbol
{
    if (currentSymbol == no_symbol) {
        currentSymbol = circle_symbol;
    } else {
        currentSymbol--;
    }
    
    [self updateSymbolVisibility];
    
    return currentSymbol;
}

-(void) setWordSelection:(CGRect) position
{
    wordSelection = position;
    
    CGPoint symbolPosition;
    
    symbolPosition.x = wordSelection.origin.x + wordSelection.size.width/2;
    symbolPosition.y = wordSelection.origin.y - (wordSelection.size.height/4 * 3);
    
    for (unsigned int n=0;n<[symbols count];n++) {
        CCSprite * sprite = [symbols objectAtIndex:n];
        
        [sprite setPosition:symbolPosition];        
    }
}
//Just testing
-(void) draw {
    //called to draw the WordSelction
    //glEnable(GL_LINE_SMOOTH);
    //all red

    //CGPoint symbolPosition;
    
    //symbolPosition.x = wordSelection.origin.x + wordSelection.size.width/2;
    //symbolPosition.y = wordSelection.origin.y - (wordSelection.size.height/3 * 2);
    //setting the symbol position
    //[symbol setPosition:symbolPosition];
    
    glColor4ub(231,45,45, 180);
    glLineWidth(5);
    
    ccDrawLine(ccp(wordSelection.origin.x, wordSelection.origin.y), ccp(wordSelection.origin.x, wordSelection.origin.y-wordSelection.size.height)); //Restore original values
    
    ccDrawLine(ccp(wordSelection.origin.x, wordSelection.origin.y-wordSelection.size.height), ccp(wordSelection.origin.x+wordSelection.size.width, wordSelection.origin.y-wordSelection.size.height));
    
    ccDrawLine(ccp(wordSelection.origin.x+wordSelection.size.width, wordSelection.origin.y-wordSelection.size.height), ccp(wordSelection.origin.x+wordSelection.size.width, wordSelection.origin.y));
    
    ccDrawLine(ccp(wordSelection.origin.x+wordSelection.size.width, wordSelection.origin.y), ccp(wordSelection.origin.x, wordSelection.origin.y));
	glLineWidth(1);
	//glDisable(GL_LINE_SMOOTH);
	glColor4ub(255,255,255,255);
	glPointSize(1);	
    
    [super draw];
}

@end
