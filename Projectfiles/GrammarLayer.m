//
//  GrammarLayer.m
//  LOLGramatik
//
//  Created by Jan Brond on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrammarLayer.h"
#import "CubeCommand.h"
#import "theGrammarGame.h"

int numberMap[7] = { 0, 4, 1, 0, 5, 2, 3};

@implementation GrammarLayer

+(id) layerWithLayerNumber:(int)layerNumber {
	return [[GrammarLayer alloc] initWithLayerNumber:layerNumber];
}

-(id) initWithLayerNumber:(int)layerNumber {
	if( (self=[super init] )) {
        
        waitingForNextSentence = 0;
		//Random background color
		self.isTouchEnabled = YES;
        
        [self registerWithTouchDispatcher];
        
        size = [[CCDirector sharedDirector] winSize];
        
		CCSprite *bg = [CCSprite spriteWithFile:@"bg_grammar.png"];
        bg.position = ccp(size.width/2,size.height/2);
        
        bg.scale = [self getScale];
        [self addChild:bg z:0];		
        
        cube1Sprites = [NSMutableArray new];
        cube2Sprites = [NSMutableArray new];
        levelSprites = [NSMutableArray new];
        wordSelectionPositions = [NSMutableArray new];
        //Contains the sprites for the individual words
    
        for (int i=0;i<6;i++) {
            NSString * fname = [[NSString alloc] initWithFormat:@"side%d.png",(i+1)];
            
            //Adding the banners
            CCSprite * sprite = [CCSprite spriteWithFile:fname];
            sprite.scale = [self getScale] * 0.75;
            sprite.position = [self getGrammarCube1];
            [sprite setVisible:false];
            
            [self addChild:sprite];
            
            [cube1Sprites addObject:sprite];
        }
        
        for (int i=0;i<6;i++) {
            NSString * fname = [[NSString alloc] initWithFormat:@"side%d.png",(i+1)];
            
            //Adding the banners
            CCSprite * sprite = [CCSprite spriteWithFile:fname];
            sprite.scale = [self getScale] * 0.75;
            sprite.position = [self getGrammarCube2];
            [sprite setVisible:false];
            
            [self addChild:sprite];
            
            [cube2Sprites addObject:sprite];
        }
        
        CCSprite * banner = [CCSprite spriteWithFile:@"niveaubanner.png"];
        [banner setPosition:[self getGrammarBanner]];
        [banner setScale: [self getScale]];
        [self addChild:banner];
        
        CCSprite * levelSp = [CCSprite spriteWithFile:@"niveau1.png"];
        [levelSp setPosition:[self getGrammarLevel1]];
        [levelSp setScale: [self getScale]];
        [self addChild:levelSp];
        
        [levelSprites addObject:levelSp];
        
        levelSp = [CCSprite spriteWithFile:@"niveau2.png"];
        [levelSp setPosition:[self getGrammarLevel2]];
        [levelSp setScale: [self getScale]];
        [levelSp setVisible:false];
        [self addChild:levelSp];
        
        [levelSprites addObject:levelSp];
        
        levelSp = [CCSprite spriteWithFile:@"niveau3.png"];
        [levelSp setPosition:[self getGrammarLevel3]];
        [levelSp setScale: [self getScale]];
        [levelSp setVisible:false];
        [self addChild:levelSp];
        
        [levelSprites addObject:levelSp];
        
        levelSp = [CCSprite spriteWithFile:@"niveau4.png"];
        [levelSp setPosition:[self getGrammarLevel4]];
        [levelSp setScale: [self getScale]];
        [levelSp setVisible:false];
        [self addChild:levelSp];
        
        [levelSprites addObject:levelSp];
        
        levelSp = [CCSprite spriteWithFile:@"niveau5.png"];
        [levelSp setPosition:[self getGrammarLevel5]];
        [levelSp setScale: [self getScale]];
        [levelSp setVisible:false];
        [self addChild:levelSp];        
        
        [levelSprites addObject:levelSp];
        
        crossMark = [CCSprite spriteWithFile:@"cross.png"];
        [crossMark setPosition:[self getCheckMark]];
        [crossMark setScale:[self getScale]*2.0];
        [crossMark setVisible:false];
        
        [self addChild:crossMark];
        
        checkMark = [CCSprite spriteWithFile:@"check.png"];
        [checkMark setPosition:[self getCheckMark]];
        [checkMark setScale:[self getScale]*2.0];
        [checkMark setVisible:false];
        
        [self addChild:checkMark];
        
        //Creating and adding the word selection layer
        wordSelection = [[WordSelectionLayer alloc] init ];
        [wordSelection setVisible:true];
        
        [self addChild:wordSelection z:3];
        
        symbolSelection = [[SymbolSelectionLayer alloc] init ];
        [symbolSelection setVisible:true];
        
        [self addChild:symbolSelection z:2];
        
        line1 = [CCLabelTTF labelWithString:@"" fontName:@"fultonshandregular.ttf" fontSize:40];
        line2 = [CCLabelTTF labelWithString:@"" fontName:@"fultonshandregular.ttf" fontSize:40];    
        
        [line1 setColor:ccBLACK];
        line1.position = [self getGrammarLine1];
        
        [self addChild:line1];
        
        [line2 setColor:ccBLACK];
        line2.position = [self getGrammarLine2];
        
        [self addChild:line2];
        
        gameTime = [CCLabelTTF labelWithString:@"13:10" fontName:@"fultonshandregular.ttf" fontSize:30];
        [gameTime setColor:ccRED];
        [gameTime setPosition:[self getTimePosition]];
        
        [self addChild:gameTime];
        
        levelSentence = [CCLabelTTF labelWithString:@"1/10" fontName:@"fultonshandregular.ttf" fontSize:28];
        
        [levelSentence setColor:ccBLUE];
        [levelSentence setPosition:[self getSentenceNumberPosition]];
        
        [self addChild:levelSentence];
        
        //Update the lines
        [self updateText];
        
        [self setCubeSpriteVisible:1 :1];
        [self setCubeSpriteVisible:2 :1];
        
	}
	return self;
}

-(void) setCubeSpriteVisible:(int) cube : (int) orientation
{
    
    NSLog(@"Orientation %d",orientation);
    
    if (orientation<1 || orientation>6)
        return;
    
    //mapping the correct orientation
    int or = numberMap[orientation];

    if (cube == 1) {
        for (unsigned int i = 0;i< [cube1Sprites count];i++) {
            CCSprite * sprite = [cube1Sprites objectAtIndex:i];
            [sprite setVisible:false];
        
            if (i==(unsigned int)or)
                [sprite setVisible:true];
            
        }
    }
    if (cube == 2) {
        for (unsigned int i = 0;i< [cube2Sprites count];i++) {
            CCSprite * sprite = [cube2Sprites objectAtIndex:i];
            [sprite setVisible:false];
            
            if (i==(unsigned int)or)
                [sprite setVisible:true];
            
        }
    }
}

-(void) finishedSymbols
{
    //lets make sure we have the symbol updated
    //[self updateSymbol];
    
    Sentence * sen = [[theGrammarGame instance] getCurrentSentence];
    //checking the suggestion
    [sen checkSuggestions];
    
    //Update the check mark
    // and no matter what the result is remove it after few sec
    [self updateCheckMark];
    
    waitingForNextSentence = 3;
}
-(void)cubeActionPosition:(cubeMessage) cmd:(int) cubeId:(int) iValue
{
    switch (cmd) {
        case msgNone: 
            break;
        case msgHit: [self addComma];
            break;
        case msgBalance:
            break;
        case msgOrientation: [self setCubeSpriteVisible:cubeId:iValue];
            break;
        case msgThrow: 
            break;
        case msgShakeStart: 
            break;
        case msgShakeEnd: 
            break;
        case msgShakeDetected: 
            break;
        case msgTiltRight: [self nextWord:true];
            break;
        case msgTiltLeft: [self nextWord:false];
            break;
        case msgTiltShake: [self finishedSymbols];
            break;
        default:
            break;
    }
}

-(void) nextSymbol
{
    [wordSelection nextSymbol];
    
    Sentence * sen = [[theGrammarGame instance] getCurrentSentence];
    
    [sen addSymbolSuggestion:[wordSelection currentSymbol]];
    
    //if we have no_symbol we need to remove it from the symbolselectionLayer
    
    if ([wordSelection currentSymbol] == no_symbol)
        [symbolSelection removeSymbol:[sen currentWord]];
}

-(void) previousSymbol
{
    [wordSelection previousSymbol];
    
    Sentence * sen = [[theGrammarGame instance] getCurrentSentence];
    
    [sen addSymbolSuggestion:[wordSelection currentSymbol]];
    
    if ([wordSelection currentSymbol] == no_symbol)
        [symbolSelection removeSymbol:[sen currentWord]];
}

-(void) setSymbol:(int) newSymbol
{
    if (newSymbol==1 || newSymbol==6) {
        [wordSelection setSymbol:no_symbol];
    }
    if (newSymbol==2 || newSymbol==5) {
        [wordSelection setSymbol:circle_symbol];
    }
    if (newSymbol==3 || newSymbol==4) {
        [wordSelection setSymbol:cross_symbol];
    }
    
    Sentence * sen = [[theGrammarGame instance] getCurrentSentence];
    
    [sen addSymbolSuggestion:[wordSelection currentSymbol]];
    
    if ([wordSelection currentSymbol] == no_symbol)
        [symbolSelection removeSymbol:[sen currentWord]];
}

-(void)cubeActionSymbol:(cubeMessage) cmd:(int) cubeId:(int) iValue
{
    switch (cmd) {
        case msgNone: 
            break;
        case msgHit:            //[self addComma];
            break;
        case msgBalance:
            break;
        case msgOrientation:    [self setCubeSpriteVisible:cubeId:iValue];
                                [self setSymbol:iValue];
            break;
        case msgThrow:          [self finishedSymbols];
            break;
        case msgShakeStart: 
            break;
        case msgShakeEnd: 
            break;
        case msgShakeDetected: 
            break;
        case msgTiltRight:      [self nextSymbol];
            break;
        case msgTiltLeft:       [self previousSymbol];
            break;
        case msgTiltShake:      [self finishedSymbols];
            break;
        default:
            break;
    }
}

-(Boolean) updateCheckMark
{
    Sentence * sen = [[theGrammarGame instance] getCurrentSentence];
    
    if ([sen hasBeenSolved]) {
        
        if ([sen result]) {
            [checkMark setVisible:true];
            [crossMark setVisible:false];
        } else {
            [crossMark setVisible:true];
            [checkMark setVisible:false];
        }
        
    } else {
        [crossMark setVisible:false];
        [checkMark setVisible:false];
    }
    
    int nsl = [[theGrammarGame instance] getNumberOfSentencesForLevel];
    int ns = [sen number];
    //Update the sentence/level
    NSString * str = [NSString stringWithFormat:@"%d/%d", ns,nsl];
    [levelSentence setString:str];
    
    return [sen result];
}
//Responding to the messages from the cubes
- (void)cubeMessage:(NSNotification *)note {
    
    NSDictionary *messageCommand = note.userInfo;
    CubeCommand *cubeCommand = [messageCommand objectForKey:@"messageCommand"];
    
    cubeMessage cmd = [cubeCommand message];
    //Now what to do with the cubeCommand???
    NSLog(@"CubeCommand: %d %d",cmd,[cubeCommand cubeId] );

    //based on the cube select what should be done
    if ([cubeCommand cubeId] == 1) {
        [self cubeActionPosition:cmd :[cubeCommand cubeId] :[cubeCommand iValue]];
    } else {
        [self cubeActionSymbol:cmd :[cubeCommand cubeId] :[cubeCommand iValue]];
    }
    
}

//Based on the current text add the comma
-(void) addComma
{
    Sentence * sen = [[theGrammarGame instance] getCurrentSentence];
    
    [sen addCommaSuggestion];
    
    //if we update the text the comma will be added
    [self updateText];
}

-(void) updateLevelStatus:(int) newLevel
{
    [[levelSprites objectAtIndex:newLevel] setVisible:true];
}

-(void) divideTextOnLines:(NSString *) str
{
    NSArray *chunks = [str componentsSeparatedByString: @" "];

    NSString * linestr = @"";
    
    CGSize textSize; 
    //we dont know for sure if there is word enough for line 2
    [line2 setString:@""];
    
    unsigned int i = 0;
    
    int lineN = 0;
    
    do {
        NSString * chunkStr = [chunks objectAtIndex:i];
        
        linestr = [linestr stringByAppendingString:chunkStr];
        
        [line1 setString:linestr];
        
        textSize = [line1 contentSize];
        
        //appending the space
        linestr = [linestr stringByAppendingString:@" "];
        
        i++;
        
        lineN = (textSize.width / 800);
        
    } while (i<[chunks count] && lineN == 0);
    
    //if we reached all the chunks - return
    if (i==[chunks count])
        return;
    
    linestr = @"";
    
    do {
        NSString * chunkStr = [chunks objectAtIndex:i];
        
        linestr = [linestr stringByAppendingString:chunkStr];
        
        [line2 setString:linestr];
        
        textSize = [line2 contentSize];
        
        //appending the space
        linestr = [linestr stringByAppendingString:@" "];
        
        i++;
        
        lineN = (textSize.width / 800);
        
    } while (i<[chunks count] && ( lineN==0));
}

-(int) calculateWordSelection
{
    //getting the string from the label
    NSString * str = [line1 string];
    
    NSArray *chunks = [str componentsSeparatedByString: @" "];
    
    CGSize tSize = [line1 contentSize];
    CGPoint pos = [line1 position];
    
    //Find the most left position of the string
    //
    float leftOrigin = pos.x - tSize.width / 2;
    //Clear the selection positions in the array
    [wordSelectionPositions removeAllObjects];
    float leftPosition = 0;
    //Blank string
    NSString * accumulatedString = @"";
    
    for (unsigned int i=0;i< [chunks count];i++) {
        
        NSString * chunkStr = [chunks objectAtIndex:i];
        
        
        //adding the space
        chunkStr = [chunkStr stringByAppendingString:@" "];
        [line1 setString:chunkStr];
        
        CGSize textSize = [line1 contentSize];
        
        //adding the rect of word selection for the specific line
        //
        [wordSelectionPositions addObject:[NSValue valueWithCGRect:CGRectMake(leftOrigin+leftPosition-5,pos.y+tSize.height,textSize.width-5,tSize.height*3)]];
        
        accumulatedString = [accumulatedString stringByAppendingString:chunkStr];
        [line1 setString:accumulatedString];
        
        CGSize accumulatedTextSize = [line1 contentSize];
        
        leftPosition = accumulatedTextSize.width;
        
    }
    //Restore the text of the label
    [line1 setString:str];
    
    return [chunks count];
}

-(int) calculateWordSelectionLine2
{
    //getting the string from the label
    NSString * str = [line2 string];
    
    NSArray *chunks = [str componentsSeparatedByString: @" "];
    
    CGSize tSize = [line2 contentSize];
    CGPoint pos = [line2 position];
    
    //Find the most left position of the string
    //
    float leftOrigin = pos.x - tSize.width / 2;
    
    float leftPosition = 0;
    //Blank string
    NSString * accumulatedString = @"";
    
    for (unsigned int i=0;i< [chunks count];i++) {
        
        NSString * chunkStr = [chunks objectAtIndex:i];
        
        //adding the space
        chunkStr = [chunkStr stringByAppendingString:@" "];
        [line2 setString:chunkStr];
        
        CGSize textSize = [line2 contentSize];
        
        //adding the rect of word selection for the specific line
        //
        [wordSelectionPositions addObject:[NSValue valueWithCGRect:CGRectMake(leftOrigin+leftPosition-5,pos.y+tSize.height,textSize.width-5,tSize.height*3)]];
        
        accumulatedString = [accumulatedString stringByAppendingString:chunkStr];
        [line2 setString:accumulatedString];
        
        CGSize accumulatedTextSize = [line2 contentSize];
        
        leftPosition = accumulatedTextSize.width;
        
    }
    //Restore the text of the label
    [line2 setString:str];
    
    return [chunks count];
}


-(void) updateText
{
    Sentence * sen = [[theGrammarGame instance] getCurrentSentence];
    
    //NSString * str = [sen text];
    
    //set the text on the two lines
    [self divideTextOnLines:[sen getTextWithComma]];
    //[line1 setVisible:false];
    //[line1 setString:str];
    
    //Calculating the word selctions for both lines
    [self calculateWordSelection];
    [self calculateWordSelectionLine2];
    
    [line1 setVisible:true];
    [line2 setVisible:true];
    
    int currentWord = [sen currentWord];
    
    CGRect someRect = [[wordSelectionPositions objectAtIndex:currentWord] CGRectValue];
    
    [wordSelection setWordSelection:someRect];
    
}

-(void) initSymbols
{
    //this will remove all the symbols displayed
    [symbolSelection removeAllSymbols];
    //add the symbols from the suggested
    
    [self updateText];
    
    Sentence * sen = [[theGrammarGame instance] getCurrentSentence];
    //updating the symbols from previous
    [symbolSelection updateSymbolPositions:[sen suggestedSymbolPositions] :wordSelectionPositions];
    
    NSNumber * pos = [NSNumber numberWithInt:[sen currentWord]];
    
    NSNumber * sym = [[sen suggestedSymbolPositions] objectForKey:pos];
    
    if (sym != nil) {
        [wordSelection setSymbol:(grammarSymbolType)[sym intValue]];
    } else {
        [wordSelection clearSymbol];
    }
    
    [self updateCheckMark];
}
-(void) switchLevel:(int) level
{
    //Update the suggested symbols on the sentence
    
    [[theGrammarGame instance] setCurrentLevel:level];
    
    [self initSymbols];
}

-(void) updateSymbol
{
    if ([wordSelection currentSymbol] != no_symbol) {
        int wordPosition = [[[theGrammarGame instance] getCurrentSentence] currentWord];
        
        CGRect rect = [[wordSelectionPositions objectAtIndex:wordPosition] CGRectValue];
        
        [symbolSelection addSymbol:wordPosition  :[wordSelection currentSymbol] : rect];
    }
}

-(void) nextWord:(bool) direction
{
    //moving to the next word did we select symbol on previous word?
    [self updateSymbol];
    
    if (direction) {
        [[theGrammarGame instance] nextWord];
    } else {
        [[theGrammarGame instance] previousWord];
    }
    
    [wordSelection clearSymbol];
    
    int wordPosition = [[[theGrammarGame instance] getCurrentSentence] currentWord];
    
    [wordSelection setSymbol:[symbolSelection getSymbol:wordPosition]];
    
    [self updateText];
}

-(void) getNextSentence
{
    [[theGrammarGame instance] getNextSentence];
    
    [symbolSelection removeAllSymbols];
    
    Sentence * sen = [[theGrammarGame instance] getCurrentSentence];
    //updating the symbols from previous
    [symbolSelection updateSymbolPositions:[sen suggestedSymbolPositions] :wordSelectionPositions];
    
    NSNumber * pos = [NSNumber numberWithInt:[sen currentWord]];
    
    NSNumber * sym = [[sen suggestedSymbolPositions] objectForKey:pos];
    
    if (sym != nil) {
        [wordSelection setSymbol:(grammarSymbolType)[sym intValue]];
    } else {
        [wordSelection clearSymbol];
    } 
    
    [self updateCheckMark];
}
//Touch events
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isCurrent)
        return;
    
    UITouch * touch = [touches anyObject];
    
    //Check the game mode - if practice its ok to switch levels
    if ([[theGrammarGame instance] mode] == grammarPractice) {
    
        int cLevel = [[theGrammarGame instance] currentLevel];
    
        for (unsigned int i=0;i<[levelSprites count];i++) {
        
            CCSprite * ls = [levelSprites objectAtIndex:i];
        
            if ([ls containsTouch:touch] && i != (unsigned int)[[theGrammarGame instance] currentLevel ]) {
            //Update the suggested symbols on the sentence
            
                //lets check if the level has been all solved
                if ([[theGrammarGame instance] getLevelStatus:i]) {
                    return;
                }
                
                [self switchLevel:i];
                    
            }
        
        }
        
        [[levelSprites objectAtIndex:cLevel] setVisible:false];
        
        Sentence * sen = [[theGrammarGame instance] getCurrentSentence];
    
        if ([sen result] && [crossMark containsTouch:touch]) {
            [self getNextSentence];
        }
        
        [[levelSprites objectAtIndex:[[theGrammarGame instance] currentLevel]] setVisible:true];
    }
    
    //if the user
    if ([levelSentence containsTouch:touch]) {
        [[theGrammarGame instance] resetGameStatus];
        //update text and level
        [self updateLevel];
        [self updateText];
        [self updateSymbol];
        [self updateCheckMark];
        
        [symbolSelection removeAllSymbols];
    }
    
    
    CCSprite * next = [cube1Sprites objectAtIndex:0];
    
    if ([next containsTouch:touch]) {
        [self nextWord:true];
    }
    
    CCSprite * prev = [cube2Sprites objectAtIndex:0];
    
    if ([prev containsTouch:touch]) {
        [self nextSymbol];
        //[self updateText];
    }
    
}

-(void) updateLevel {
    
    //Set all levels invisible
    for (int i = 0; i < 5; i++) {
        [[levelSprites objectAtIndex:i] setVisible:false];
    }
    //get the current Level from the grammar game
    //Switch the level back on
    [[levelSprites objectAtIndex:[[theGrammarGame instance] currentLevel]] setVisible:true];
    
}

-(void) onTimer {
    
    NSDate * timeSinceStart = [[NSDate alloc] init];
    
    NSTimeInterval seconds = [timeSinceStart timeIntervalSinceDate:startTime];
    
    NSString * str = [NSString stringWithFormat:@"%2.0f Sek",seconds];
    
    [gameTime setString:str];
    
    //use the timer to wait for action
    if (waitingForNextSentence > 0) {
        
        waitingForNextSentence--;
        
        if (waitingForNextSentence==0) {
            
            if ([crossMark visible]) {
                
                [crossMark setVisible:false];
                
            } else {
                //We might end up on different level
                //Switch the level indicator
                int cLevel = [[theGrammarGame instance] currentLevel];
            
                [[levelSprites objectAtIndex:cLevel] setVisible:false];
            
                //The text has been solved
                //lets get the next one
                [[theGrammarGame instance] getNextSentence];
            
                [self initSymbols];
            
                //Switch the level back on
                [[levelSprites objectAtIndex:[[theGrammarGame instance] currentLevel]] setVisible:true];
            }
        }
    }
    
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) onExit
{
    NSLog(@"OnExit from Layer");
    
    //Removing our self from the observers list
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //Reset the timer
    [timeUpdate invalidate];
    timeUpdate = nil;
    
    //we exit the layer
    [[theGrammarGame instance] saveStatus];
    
    isCurrent = false;
}

-(void) onEnter
{
    NSLog(@"OnEnter to Layer");

    //need to respond to the various messages from the cubes
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(cubeMessage:) 
                                                 name:@"cubeMessage" object:nil];
    
    //Need to check the level and switch to the correct level
    [self updateText];
    [self updateLevel];
    [self updateCheckMark];
    //Start timer to update time
    //
    timeUpdate = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];

    startTime = [[NSDate alloc] init];
    
    isCurrent = true;
}
//Switch to a different layer
-(void) goToLayer:(id)sender {
	
    CCMenuItemFont *item = (CCMenuItemFont*)sender;
	
    [(CCLayerMultiplex*)parent_ switchTo:item.tag];
}

@end
