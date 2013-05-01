//
//  WordSelectionLayer.h
//  LOLGramatik
//
//  Created by Jan Brond on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "basicGrammarLayer.h"


@interface WordSelectionLayer : basicGrammarLayer
{
    CGRect wordSelection;
    NSMutableArray * symbols;
    
    grammarSymbolType currentSymbol;
}

//@property (nonatomic) CGRect wordSelection;
@property (nonatomic) grammarSymbolType currentSymbol;
-(void) draw;
-(void) setWordSelection:(CGRect) position;
-(grammarSymbolType) nextSymbol;
-(grammarSymbolType) previousSymbol;
-(void) clearSymbol;
-(void) setSymbol:(grammarSymbolType) symbol;
@end
