//
//  SelectNames.m
//  MyHelloWorld
//
//  Created by Jan Brond on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectNames.h"
#import "theGrammarGame.h"


@implementation SelectNames


+(id) layerWithLayerNumber:(int)layerNumber {
	return [[SelectNames alloc] initWithLayerNumber:layerNumber];
}

-(id) initWithLayerNumber:(int)layerNumber {
	if( (self=[super init] )) {	
        
        self.isTouchEnabled = YES;
        
        [self registerWithTouchDispatcher];
        
		//Random background color
		
        CGSize wsize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"bg_cube_navn.png"];
        bg.position = ccp(wsize.width/2,wsize.height/2);
        
        bg.scale = [self getScale];
        [self addChild:bg];
        
        //[self addScrollView];
        //Adding the various sprites
        //
        bannerTeam1 = [CCSprite spriteWithFile:@"bannerteam1.png"];
        bannerTeam1.scale = [self getScale];
        bannerTeam1.position = [self getBanner1Position];
        
        [self addChild:bannerTeam1];
        
        NSString * t1c = [[theGrammarGame instance] team1Name];
        
        team1Name = [CCLabelTTF labelWithString:t1c fontName:@"fultonshandregular.ttf" fontSize:32];
        
        [team1Name setColor:ccBLACK];
        team1Name.position = [self getBanner1Position];
        
        [self addChild:team1Name];
        
        bannerTeam2 = [CCSprite spriteWithFile:@"bannerteam2.png"];
        bannerTeam2.scale = [self getScale];
        bannerTeam2.position = [self getBanner2Position];
        
        [self addChild:bannerTeam2];
        
        NSString * t2c = [[theGrammarGame instance] team2Name];
        
        team2Name = [CCLabelTTF labelWithString:t2c fontName:@"fultonshandregular.ttf" fontSize:32];
        
        [team2Name setColor:ccBLACK];
        team2Name.position = [self getBanner2Position];
        
        [self addChild:team2Name];
        
        ramme = [CCSprite spriteWithFile:@"ramme-rundt-ord.png"];
        ramme.scale = [self getScale] * 2;
        [ramme setVisible:false];
        ramme.position = [self getBanner1Position];
        
        [self addChild:ramme];
        //Adding the scrollview of the 
        //various cubes available
        [self addScrollView];
        
        CCLabelTTF *tekst = [CCLabelTTF labelWithString:@"Hvem er med?" fontName:@"fultonshandregular.ttf" fontSize:16];
        
        [tekst setColor:ccBLACK];
        tekst.position = [self getTekstPosition];
        
        [self addChild:tekst];
        
        currentTeamSelected = 0;
        isCurrent = false;
        
	}
	return self;
}

-(void) onExit
{
    NSLog(@"OnExit from Layer");
    
    //Lets get the data from the DB
    [[theGrammarGame instance] loadStatus];
    
    isCurrent = false;
    [self hide];
}

-(void) onEnter
{
    NSLog(@"OnEnter to Layer");
    isCurrent = true;
}

-(void) updateScrollView {
    
    NSMutableArray * names = [[NSMutableArray alloc] initWithObjects:@"Tobias", @"Natasha", @"Amalie M", @"Signe", @"Jari", @"Anna", @"Stefanie" , @"Frederik", @"Julie", @"Linda", @"Esben", @"Nanna", @"Amalie K", @"Ditte", @"Morten", @"Freja", @"Jeppe", @"Rasmus", @"Andreas", @"Julie D", @"Dia", nil];
    
    CGPoint viewSize = ccp(190.0f,247.0f);
    int nodeCount = [names count];
    CGPoint nodeSize = ccp(190.0f,40.0f);
    
    for (UIView *view in [scrollview subviews]) 
    {
        [view removeFromSuperview];
    }
    
    for (unsigned int n = 0; n < [names count]; n++) {
        
        NSString * name = [names objectAtIndex:n];
        
        CGFloat y = n * nodeSize.y;
        UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, y,
                                                                    nodeSize.x, nodeSize.y)];
        [view setTitle:name forState:(UIControlStateNormal)];
        [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //Why rotate???
        //[view setTransform:CGAffineTransformMakeRotation(-3.14)];
        
        [view addTarget:self action:@selector(cubeSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollview addSubview:view];
    }
    
    scrollview.contentSize = CGSizeMake(viewSize.x, viewSize.y *
                                        nodeCount/6);
}
-(void) addScrollView {    
    //Create a simple UIScrollView with colored UIViews
    CGPoint viewSize = ccp(190.0f,247.0f);
    
    //int nodeCount = [services count];
    //Init scrollview
    scrollview = [[UIScrollView alloc] initWithFrame:
                  CGRectMake(0, 0, viewSize.x, viewSize.y)];
    
    //setting the background color to white
    [scrollview setBackgroundColor:[UIColor whiteColor]];
    
    
    //Wrap the UIScrollView object using CCUIViewWrapper
    wrapper = [CCUIViewWrapper wrapperForUIView:scrollview];
    [self addChild:wrapper];
    wrapper.rotation = 90;
    
    wrapper.position = [self getBanner1Position];
    [wrapper setAnchorPoint:ccp(0.5, 0.5)];
    //Not to show
    [wrapper setVisible:false];
    
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
        
        //create the scroll view
        [self updateScrollView];
        
        if (wrapper != nil) {
            CGPoint pos = [self getBanner1Position];
            [ramme setPosition:pos];
            [ramme setVisible:true];
            [wrapper setPosition:ccp(pos.y-93,pos.x-28)];
            [wrapper setVisible:true];
        }
        
        currentTeamSelected = 1;
        
    }
    if([bannerTeam2 containsTouch:touch]) {
        NSLog(@"Touched Banner2");
        
        //create the scroll view
        [self updateScrollView];
        
        if (wrapper != nil) {
            CGPoint pos = [self getBanner2Position];
            [ramme setPosition:pos];
            [ramme setVisible:true];
            [wrapper setPosition:ccp(pos.y-95,pos.x-40)];
            [wrapper setVisible:true];
        }
        
        currentTeamSelected = 2;
    }
    
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) hide
{
    [wrapper setVisible:false]; 
    [ramme setVisible:false];
}

- (void) cubeSelected:(id) sender
{
    UIButton * buttonPressed = (UIButton*) sender;
    
    if (currentTeamSelected == 1) {
        [[theGrammarGame instance] setTeam1Name:[buttonPressed titleForState:UIControlStateNormal]];
        
        [team1Name setString:[buttonPressed titleForState:UIControlStateNormal]];
    }
    
    if (currentTeamSelected == 2) {
        [[theGrammarGame instance] setTeam2Name:[buttonPressed titleForState:UIControlStateNormal]];
        
        [team2Name setString:[buttonPressed titleForState:UIControlStateNormal]];
    }

    
    [self hide];
}

//Switch to a different layer
-(void) goToLayer:(id)sender {
	
    CCMenuItemFont *item = (CCMenuItemFont*)sender;
	
    [(CCLayerMultiplex*)parent_ switchTo:item.tag];
}

@end
