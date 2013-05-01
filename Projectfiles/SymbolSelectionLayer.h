//
//  SymbolSelectionLayer.h
//  LOLGramatik
//
//  Created by Jan Brond on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "basicGrammarLayer.h"

@interface SymbolSelectionLayer : basicGrammarLayer
{
    NSMutableDictionary * wordSymbols;
}

-(void) addSymbol:(int) wordPosition:(grammarSymbolType) symbol:(CGRect) spritePosition;
-(void) removeAllSymbols;
-(void) removeSymbol:(int) position;
-(void) updateSymbolPositions:(NSMutableDictionary*) symbolPositions: (NSMutableArray*) wordPositions;
-(grammarSymbolType) getSymbol:(int) position;
@end
