//
//  SelectGameMode.m
//  MyHelloWorld
//
//  Created by Jan Brond on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectGameMode.h"
#import "theGrammarGame.h"

@implementation SelectGameMode

+(id) layerWithLayerNumber:(int)layerNumber {
	return [[SelectGameMode alloc] initWithLayerNumber:layerNumber];
}

-(id) initWithLayerNumber:(int)layerNumber {
	if( (self=[super init] )) {	
		//Random background color
		self.isTouchEnabled = YES;
        [self registerWithTouchDispatcher];
        
        size = [[CCDirector sharedDirector] winSize];
        
		CCSprite *bg = [CCSprite spriteWithFile:@"bg_mode.png"];
        bg.position = ccp(size.width/2,size.height/2);
        
        bg.scale = [self getScale];
        [self addChild:bg];		
        
        //Adding the banners
        bannerTeam1 = [CCSprite spriteWithFile:@"bannerteam1.png"];
        bannerTeam1.scale = [self getScale];
        bannerTeam1.position = [self getBanner1Position];
        
        [self addChild:bannerTeam1];
        
        //Adding the banners
        cubePractice = [CCSprite spriteWithFile:@"cubeteam1.png"];
        cubePractice.scale = [self getScale];
        cubePractice.position = [self getCube1Position];
        //Only visible if it has been selected
        [cubePractice setVisible:false];
        
        [self addChild:cubePractice];
        
        CCLabelTTF *practiceModeLabel = [CCLabelTTF labelWithString:@"Øve" fontName:@"fultonshandregular.ttf" fontSize:50];
        
        [practiceModeLabel setColor:ccBLACK];
        practiceModeLabel.position = [self getBanner1Position];
        
        [self addChild:practiceModeLabel];
        
        bannerTeam2 = [CCSprite spriteWithFile:@"bannerteam2.png"];
        bannerTeam2.scale = [self getScale];
        bannerTeam2.position = [self getBanner2Position];
        
        [self addChild:bannerTeam2];
        
        CCLabelTTF *timeModeLabel = [CCLabelTTF labelWithString:@"Tid" fontName:@"fultonshandregular.ttf" fontSize:50];
        
        [timeModeLabel setColor:ccBLACK];
        timeModeLabel.position = [self getBanner2Position];
        
        [self addChild:timeModeLabel];
        
        //Adding the tekst to the buble
        CCLabelTTF *tekst = [CCLabelTTF labelWithString:@"Hvad skal vi lave?" fontName:@"fultonshandregular.ttf" fontSize:16];
        
        [tekst setColor:ccBLACK];
        tekst.position = [self getTekstPosition];
        [self addChild:tekst];
        
        //Adding the banners
        cubeTime = [CCSprite spriteWithFile:@"cubeteam2.png"];
        cubeTime.scale = [self getScale];
        cubeTime.position = [self getCube2Position];
        //Only visible if it has been selected
        [cubeTime setVisible:false];
        
        [self addChild:cubeTime];
        
        if ([[theGrammarGame instance] mode] == grammarPractice) {
            [cubePractice setVisible:true];
            
        }
        if ([[theGrammarGame instance] mode] == grammarGame) {
            [cubeTime setVisible:true];
        }
        
	}
	return self;
}


//Touch events
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isCurrent)
        return;
    
    
    UITouch * touch = [touches anyObject];
    
    //CGPoint location = [touch locationInView:touch.view];
    
    if([bannerTeam1 containsTouch:touch]) {
        //
        //create the list of cubes available
        //
        NSLog(@"Touched Banner1");
        
        [[theGrammarGame instance] setMode:grammarPractice];
        [cubePractice setVisible:true];
        [cubeTime setVisible:false];
        
    }
    if([bannerTeam2 containsTouch:touch]) {
        NSLog(@"Touched Banner2");
        [[theGrammarGame instance] setMode:grammarGame];
        [cubePractice setVisible:false];
        [cubeTime setVisible:true];
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
    
    isCurrent = false;
}

-(void) onEnter
{
    NSLog(@"OnEnter to Layer");
    isCurrent = true;
}
//Switch to a different layer
-(void) goToLayer:(id)sender {
	
    CCMenuItemFont *item = (CCMenuItemFont*)sender;
	
    [(CCLayerMultiplex*)parent_ switchTo:item.tag];
}

@end
