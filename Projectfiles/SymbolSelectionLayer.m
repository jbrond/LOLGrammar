//
//  SymbolSelectionLayer.m
//  LOLGramatik
//
//  Created by Jan Brond on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SymbolSelectionLayer.h"

@implementation SymbolSelectionLayer

-(id) init {
    if( (self=[super init] )) {
        
        wordSymbols = [NSMutableDictionary new];
        
    }
    
    return self;
}

-(void) addSymbol:(int) position:(grammarSymbolType) symbol:(CGRect) spritePosition
{
    CCSprite * node = (CCSprite*)[self getChildByTag:position];
    NSString * fname = [NSString stringWithFormat:@"symbol_%d.png",(symbol+1)];
    
    NSNumber * pos = [NSNumber numberWithInt:position];
    NSNumber * sym = [NSNumber numberWithInt:symbol];
    
    if (node != nil) {
        [self removeChild:node cleanup:true];
        [wordSymbols removeObjectForKey:pos];
    }
    
    //what happens if the word has a symbol?????
    CCSprite * sprite = [CCSprite spriteWithFile:fname];
    
    CGPoint symbolPosition;
    
    symbolPosition.x = spritePosition.origin.x + spritePosition.size.width/2;
    symbolPosition.y = spritePosition.origin.y - (spritePosition.size.height/4 * 3);
    
    [sprite setPosition:symbolPosition];
    [sprite setVisible:true];
    [sprite setScale:([self getScale] * 0.75)];
    //adding the sprite to the layer based on the word tag
    [self addChild:sprite z:1 tag:position];
    
    //Adding the symbol to the position
    [wordSymbols setObject:sym forKey:pos];
}

-(grammarSymbolType) getSymbol:(int) position
{
    NSNumber * pos = [NSNumber numberWithInt:position];
    NSNumber * sym = [wordSymbols objectForKey:pos];
    
    return (grammarSymbolType)[sym intValue];
}

-(void) updateSymbolPositions:(NSMutableDictionary*) symbolPositions: (NSMutableArray*) wordPositions
{
    //Update the list of sprites
    
    NSArray * keys = [symbolPositions allKeys];
    
    for (unsigned int i = 0; i < [keys count];i++) {
        NSNumber * pos = [keys objectAtIndex:i];
        
        NSNumber * sym = [symbolPositions objectForKey:pos];
        
        CGRect rect = [[wordPositions objectAtIndex:[pos intValue]] CGRectValue];
        //adding the symbol
        [self addSymbol:[pos intValue] :(grammarSymbolType)[sym intValue] :rect];
    }
}

-(void) removeAllSymbols
{
    NSArray * keys = [wordSymbols allKeys];
    
    //Remove the sprites from the layer
    for (unsigned int i = 0; i < [keys count]; i++) {
        
        NSNumber * pos = [keys objectAtIndex:i];
        
        CCNode * node = [self getChildByTag:[pos intValue]];
        
        [self removeChild:node cleanup:true];
    }
    
    [wordSymbols removeAllObjects];
    
}

-(void) removeSymbol:(int) position
{
    CCNode * sprite = [self getChildByTag:position];
    NSNumber * pos = [NSNumber numberWithInt:position];
    //removing the sprite from the layer
    [self removeChild:sprite cleanup:true];
    [wordSymbols removeObjectForKey:pos];
}
@end
