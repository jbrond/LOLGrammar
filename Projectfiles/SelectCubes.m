//
//  SelectCubes.m
//  MyHelloWorld
//
//  Created by Jan Brond on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectCubes.h"
#import "CCUIViewWrapper.h"
#import "CubeEnumurator.h"
#import "theGrammarGame.h"
#import "CubeConnection.h"
#import "CubeServiceMessage.h"

@implementation SelectCubes

+(id) layerWithLayerNumber:(int)layerNumber {
	return [[SelectCubes alloc] initWithLayerNumber:layerNumber];
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
        
        NSString * t1c = [[theGrammarGame instance] team1Cube];
        
        team1Cube = [CCLabelTTF labelWithString:t1c fontName:@"fultonshandregular.ttf" fontSize:32];
        
        [team1Cube setColor:ccBLACK];
        team1Cube.position = [self getBanner1Position];
        
        [self addChild:team1Cube];
        
        
        bannerTeam2 = [CCSprite spriteWithFile:@"bannerteam2.png"];
        bannerTeam2.scale = [self getScale];
        bannerTeam2.position = [self getBanner2Position];
    
        [self addChild:bannerTeam2];
        
        NSString * t2c = [[theGrammarGame instance] team2Cube];
        
        team2Cube = [CCLabelTTF labelWithString:t2c fontName:@"fultonshandregular.ttf" fontSize:32];
        
        [team2Cube setColor:ccBLACK];
        team2Cube.position = [self getBanner2Position];
        
        [self addChild:team2Cube];
        
        ramme = [CCSprite spriteWithFile:@"ramme-rundt-ord.png"];
        ramme.scale = [self getScale] * 2;
        [ramme setVisible:false];
        ramme.position = [self getBanner1Position];
        
        [self addChild:ramme];
        //Adding the scrollview of the 
        //various cubes available
        [self addScrollView];
        
        CCLabelTTF *tekst = [CCLabelTTF labelWithString:@"Hvilke Cubes er med?" fontName:@"fultonshandregular.ttf" fontSize:14];
        
        [tekst setColor:ccBLACK];
        tekst.position = [self getTekstPosition];
        
        [self addChild:tekst];
        
        currentTeamSelected = 0;
        isCurrent = false;
        
        //
        //Apply for the message send from the CubeEnumurator
        //
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(cubeServiceMessage:) 
                                                     name:@"cubeServiceMessage" object:nil];

	}
	return self;
}

-(void) onExit
{
    NSLog(@"OnExit from Layer");
    
    isCurrent = false;
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self hide];
}

-(void) onEnter
{
    NSLog(@"OnEnter to Layer");
    
    isCurrent = true;
}

-(void) updateScrollView {
    NSMutableArray *services = [[CubeEnumurator instance] services];
    CGPoint viewSize = ccp(190.0f,247.0f);
    int nodeCount = [services count];
    CGPoint nodeSize = ccp(190.0f,40.0f);
    
    for (UIView *view in [scrollview subviews]) 
    {
        [view removeFromSuperview];
    }

    for (unsigned int n = 0; n < [services count]; n++) {
        
        NSNetService * ns = [services objectAtIndex:n];
        //Just disp the names of the various services
        NSLog(@"%@",[ns name]);
        
        CGFloat y = n * nodeSize.y;
        UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, y,
                                                                    nodeSize.x, nodeSize.y)];
        [view setTitle:[ns name] forState:(UIControlStateNormal)];
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
 
    //create the scroll view
    [self updateScrollView];
    
    if([bannerTeam1 containsTouch:touch]) {
        //
        //create the list of cubes available
        //
        NSLog(@"Touched Banner1");
        
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

//Responding to the messages from the cube enumerator
//in the case the cube loose contact
- (void)cubeServiceMessage:(NSNotification *)note {
    
    NSDictionary *messageCommand = note.userInfo;
    CubeServiceMessage *csm = [messageCommand objectForKey:@"cubeServiceMessage"];
    
    NSString * t1cn = [[theGrammarGame instance] team1Cube];
    
    if ([t1cn compare:[csm cubeName]]==0) {
        [[theGrammarGame instance] setTeam1Cube:@"Forbindelse Tabt"];
        [team1Cube setString:@"Forbindelse Tabt"];
    }
    
    NSString * t2cn = [[theGrammarGame instance] team2Cube];
    
    if ([t2cn compare:[csm cubeName]]==0) {
        [[theGrammarGame instance] setTeam2Cube:@"Forbindelse Tabt"];
        [team2Cube setString:@"Forbindelse Tabt"];
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
    
    //NSLog(@"cubeSelected %@", [buttonPressed titleForState:UIControlStateNormal]);
    
    if (currentTeamSelected == 1) {
        
        if ( [[[theGrammarGame instance] team2Cube] isEqualToString:[buttonPressed titleForState:UIControlStateNormal]] ) {
            //Trying to connect same cube to both jobs
            return;
        }
        
        [[theGrammarGame instance] setTeam1Cube:[buttonPressed titleForState:UIControlStateNormal]];
        
        [team1Cube setString:[buttonPressed titleForState:UIControlStateNormal]];
        
        //Make the connection??????
        
        NSData * addr = [[CubeEnumurator instance] getCubeAddress:[[theGrammarGame instance] team1Cube]];
        
        [[CubeConnection instance] connectToCube1:addr];
        //Make the connection
    }
    
    if (currentTeamSelected == 2) {
        
        if ( [[[theGrammarGame instance] team1Cube] isEqualToString:[buttonPressed titleForState:UIControlStateNormal]] ) {
            //Trying to connect same cube to both jobs
            return;
        }
        
        [[theGrammarGame instance] setTeam2Cube:[buttonPressed titleForState:UIControlStateNormal]];
        
        [team2Cube setString:[buttonPressed titleForState:UIControlStateNormal]];
        
        //Make the connection??????
        
        NSData * addr = [[CubeEnumurator instance] getCubeAddress:[[theGrammarGame instance] team2Cube]];
        
        [[CubeConnection instance] connectToCube2:addr];
    }
    
    [self hide];
}

//Switch to a different layer
-(void) goToLayer:(id)sender {
	
    CCMenuItemFont *item = (CCMenuItemFont*)sender;
	
    [(CCLayerMultiplex*)parent_ switchTo:item.tag];
}

@end
