#import "MainLayer.h"
#import "SelectCubes.h"
#import "SelectNames.h"
#import "SelectGameMode.h"
#import "GrammarLayer.h"

enum {
	TAG_RECIPE = 0,
	TAG_RECIPE_NAME = 1,
	TAG_NEXT_BUTTON = 2,
	TAG_PREV_BUTTON = 3,
	TAG_BG = 4
};

enum {
	Z_BG = 0,
	Z_RECIPE = 1,
	Z_HUD = 2
};

@implementation MainLayer

+(id) scene{
	CCScene *scene = [CCScene node];
	
	MainLayer *layer = [MainLayer node];
	
	[scene addChild:layer];

	return scene;
}

-(id) init
{
	if( (self=[super init] )) {
		//Initialization
				
		//Add background
		[self addBackground];
		
        [self addGameLayers];
        
		//Show buttons
		[self addButtons];
	}
	return self;
}

- (void) dealloc {
	//[recipes release];
	//[super dealloc];
}


-(void) addButtons {
	CGSize size = [[CCDirector sharedDirector] winSize];
	
	CCMenuItemFont* prev = [CCMenuItemFont itemFromString:@"Prev" target:self selector:@selector(prevCallback:)];
	CCMenu *prevMenu = [CCMenu menuWithItems:prev, nil];
    prevMenu.position = ccp( 40 , 20 );
    [self addChild:prevMenu z:Z_HUD tag:TAG_PREV_BUTTON];	
	
	CCMenuItemFont* next = [CCMenuItemFont itemFromString:@"Next" target:self selector:@selector(nextCallback:)];
	CCMenu *nextMenu = [CCMenu menuWithItems:next, nil];
    nextMenu.position = ccp( size.width-40 , 20 );
    [self addChild:nextMenu z:Z_HUD tag:TAG_NEXT_BUTTON];
    
    //Just for debug and testing of fonts
    /*CCLabelTTF *name = [CCLabelTTF labelWithString:@"True-Type Label Test" fontName:@"Dakota Regular.ttf" fontSize:32];
    
	name.position = ccp(size.width/2,20);
    
	[self addChild:name z:Z_HUD tag:TAG_RECIPE_NAME];*/
}

-(void) prevCallback:(id)sender {
    
    if (currentLayer==0)
        return;
    
    currentLayer--;
    
    [gameLayers switchTo:currentLayer];
	
}

-(void) nextCallback:(id)sender {
	
    if (currentLayer==2)
        return;
    
    currentLayer++;
    
    [gameLayers switchTo:currentLayer];

    //If Current layer == 3
    //change the visibility of the next button!
}

-(void) addGameLayers {
	
	gameLayers = [CCLayerMultiplex layerWithLayers: [SelectCubes layerWithLayerNumber:0], [SelectNames layerWithLayerNumber:1], [GrammarLayer layerWithLayerNumber:3], nil];
	
    currentLayer = 0;
    
    [self addChild: gameLayers z:0];	

}


-(void) addBackground {
	//CGSize size = [[CCDirector sharedDirector] winSize];
	//CCSprite *bg = [CCSprite spriteWithFile:@"græs_baggrund.png"];
	//bg.position = ccp(size.width/2,size.height/2);
    
	//[self addChild:bg z:Z_BG tag:TAG_BG];
}

@end

