//
//  GrammarLayer.h
//  LOLGramatik
//
//  Created by Jan Brond on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "basicGrammarLayer.h"
#import "WordSelectionLayer.h"
#import "SymbolSelectionLayer.h"

@interface GrammarLayer : basicGrammarLayer {
    bool isCurrent;
    NSMutableArray * cube1Sprites;
    NSMutableArray * cube2Sprites;
    
    NSMutableArray * wordSelectionPositions;
    
    NSMutableArray * levelSprites;
    
    CCLabelTTF *line1;
    CCLabelTTF *line2;
    
    CCLabelTTF *gameTime;
    CCLabelTTF *levelSentence;
    
    CCSprite * symbol;
    
    CCSprite * crossMark;
    CCSprite * checkMark;
    
    NSDate * startTime;
    
    WordSelectionLayer * wordSelection;
    SymbolSelectionLayer * symbolSelection;
    NSTimer * timeUpdate;
    
    int waitingForNextSentence;
}

+(id) layerWithLayerNumber:(int)layerNumber;
-(id) initWithLayerNumber:(int)layerNumber;
-(void) goToLayer:(id)sender;
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
//-(void) estimateNumberOfLines:(NSString *) str;
@end
