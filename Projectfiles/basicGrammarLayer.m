//
//  basicGrammarLayer.m
//  LOLGramatik
//
//  Created by Jan Brond on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "basicGrammarLayer.h"

@implementation basicGrammarLayer 

-(id) init
{
	if( (self=[super init] )) {
		size = [[CCDirector sharedDirector] winSize];
        
        CGSize ds = [[CCDirector sharedDirector] winSizeInPixels];
        //all sprites are based on the max size of the Ipad 3
        scale = ds.width / 2048;
	}
	return self;
}

//How to adjust the various sprites 
-(double) getScale
{
    return scale;
}

-(CGPoint) getTekstPosition
{
    CGPoint v = {size.width*579/2048, size.height*1137/1536};
    return v;
}
-(CGPoint) getBanner1Position
{
    CGPoint v = {size.width*1176/2048, size.height*894/1536};
    return v;
}

-(CGPoint) getCube1Position
{
    CGPoint v = {size.width*1833/2048, size.height*945/1536};
    return v;
}
-(CGPoint) getBanner2Position
{
    CGPoint v = {size.width*1188/2048, size.height*549/1536};
    return v;
}
-(CGPoint) getCube2Position
{
    CGPoint v = {size.width*1848/2048, size.height*567/1536};
    return v;
}

-(CGPoint) getGrammarCube1
{
    CGPoint v = {size.width*512/2048, size.height*230/1536};
    return v;
}
-(CGPoint) getGrammarCube2
{
    CGPoint v = {size.width*1536/2048, size.height*230/1536};
    return v;
}

//Full size image placed in the middle
-(CGPoint) getGrammarBanner
{
    CGPoint v = {size.width*1024/2048, size.height*768/1536};
    return v;

}

-(CGPoint) getGrammarLevel1
{
    CGPoint v = {size.width*163/2048, size.height*1086/1536};
    return v;
    
}
-(CGPoint) getGrammarLevel2
{
    CGPoint v = {size.width*368/2048, size.height*1090/1536};
    return v;
    
}
-(CGPoint) getGrammarLevel3
{
    CGPoint v = {size.width*598/2048, size.height*1090/1536};
    return v;
    
}
-(CGPoint) getGrammarLevel4
{
    CGPoint v = {size.width*800/2048, size.height*1090/1536};
    return v;
    
}
-(CGPoint) getGrammarLevel5
{
    CGPoint v = {size.width*1039/2048, size.height*1098/1536};
    return v;
    
}

-(CGPoint) getGrammarLine1Only
{
    CGPoint v = {size.width*1024/2048, size.height*768/1536};
    return v;
    
}

-(CGPoint) getGrammarLine1
{
    CGPoint v = {size.width*1024/2048, size.height*904/1536};
    return v;
    
}

-(CGPoint) getGrammarLine2
{
    CGPoint v = {size.width*1024/2048, size.height*654/1536};
    return v;
    
}

-(CGPoint) getCheckMark
{
    CGPoint v = {size.width*1720/2048, size.height*656/1536};
    return v;
    
}

-(CGPoint) getSentenceNumberPosition
{
    CGPoint v = {size.width*1920/2048, size.height*1010/1536};
    return v;
    
}

-(CGPoint) getTimePosition
{
    CGPoint v = {size.width*1024/2048, size.height*230/1536};
    return v;
    
}

@end
