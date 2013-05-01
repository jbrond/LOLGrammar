//
//  Sentence.m
//  MyHelloWorld
//
//  Created by Jan Brond on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Sentence.h"



@implementation Sentence 

@synthesize hasBeenSolved;
@synthesize level;
@synthesize text;
@synthesize words;
@synthesize currentWord;
@synthesize suggestedSymbolPositions;
@synthesize result;
@synthesize number;
@synthesize uid;

-(Sentence*) init: (NSString *) sentence
{
    self = [super init];
    if(self) {

        text = [NSString stringWithString:sentence];
        words = [sentence componentsSeparatedByString: @" "];
        kommaPositions = [[NSMutableArray alloc] init];
        wordClassList = [[NSMutableArray alloc] init ];
        
        suggestedKommaPositions = [[NSMutableArray alloc] init];
        suggestedSymbolPositions = [[NSMutableDictionary alloc] init ];
        
        currentWord = 0;
        
        uid = -1;
        
        result = false;
        hasBeenSolved = false;
        
        return self;
    }
    
    return nil;
}


-(bool) checkSuggestions
{
    //ok the user has tried to solve the sentence
    hasBeenSolved = true;
    
    //we think its ok
    result = true;
    
    unsigned int correctCommas = 0;
    //check the komma positions
    for (unsigned int i = 0; i < [suggestedKommaPositions count]; i++) {
        NSNumber * pos = [suggestedKommaPositions objectAtIndex:i];
        
        bool inSuggested = false;
        
        for (unsigned int kp = 0; kp < [kommaPositions count]; kp++) {
            NSNumber * sPos = [kommaPositions objectAtIndex:kp];
            
            if ([sPos intValue] == [pos intValue])
                inSuggested = true;
        }
        //the komma position is not in the list
        if (!inSuggested) {
            return result=false;
        }
        //the comma has been found and is correct
        correctCommas++;
    }
    //well som of the commas has not been suggested!
    //the sentence has not been solved
    if (correctCommas != [kommaPositions count]) {
        return result=false;
        
    }
    
    NSArray * keys = [suggestedSymbolPositions allKeys];
    unsigned int correctSymbols = 0;
    for (unsigned int i = 0; i < [keys count]; i++) {
        
        NSNumber * pos = [keys objectAtIndex:i];
        NSNumber * sym = [suggestedSymbolPositions objectForKey:pos];
        
        bool isSuggested = false;
        
        for (unsigned int k = 0; k < [wordClassList count]; k++) {
            
            wordClass * wc = [wordClassList objectAtIndex:k];
            
            if (wc.position == [pos intValue] && wc.type==[sym intValue]) {
                isSuggested = true;
            }
            
        }
        
        if (!isSuggested) {
            //The suggested position is not part of the correct list
            return result=false;
        }
        
        correctSymbols++;
    }
    
    if (correctSymbols != [wordClassList count]) {
        return result=false;
    }
    
    //Seems that the result is correct!!!
    
    return result;
}


-(void) nextWord
{
    if ((unsigned int)currentWord == ([words count]-1)) {
        currentWord = 0;
        return;
    }
    
    currentWord++;
}

-(void) previousWord
{
    if (currentWord==0) {
        currentWord = ([words count]-1);
        return;
    }
    
    currentWord--;
}

-(int) getNumberOfWords
{
    return [words count];
}

-(void) addWordClass: (int) position : (grammarSymbolType) wct
{
    wordClass * wc = [[wordClass alloc] init:position : wct];
    
    //Adding the wordClass to the list
    [wordClassList addObject:wc];
}

-(NSString*) getTextWithComma
{
    NSString * str = [NSString stringWithString:@""];
    
    NSArray *chunks = [text componentsSeparatedByString: @" "];
    
    for (unsigned int i=0;i<[chunks count];i++) {
        
        NSString * chunkStr = [chunks objectAtIndex:i];
        
        for (unsigned int cPos=0;cPos<[suggestedKommaPositions count];cPos++) {
            
            NSNumber * pos = [suggestedKommaPositions objectAtIndex:cPos];
            //Is this the same word position?
            if (i == (unsigned int)[pos intValue]) {
                chunkStr = [chunkStr stringByAppendingString:@","];
            }
        }
        chunkStr = [chunkStr stringByAppendingString:@" "];
        str = [str stringByAppendingString:chunkStr];
    }
    
    return str;
}
-(void) addCommaSuggestion
{
    for (unsigned int cPos=0;cPos<[suggestedKommaPositions count];cPos++) {
        
        NSNumber * pos = [suggestedKommaPositions objectAtIndex:cPos];
        //Is this the same word position?
        if (currentWord == [pos intValue]) {
            [suggestedKommaPositions removeObject:pos];
            
            return;
        }
    }
    
    //No comma found
    NSNumber * newCommaPosition = [NSNumber numberWithInt:currentWord];
    
    [suggestedKommaPositions addObject:newCommaPosition];
}

-(void) removeSymbolAndKommaSuggestions
{
    [suggestedSymbolPositions removeAllObjects];
    [suggestedKommaPositions removeAllObjects];
    
}

-(void) addSymbolSuggestion:(grammarSymbolType) symbol
{
    NSArray * keys = [suggestedSymbolPositions allKeys];
    
    NSNumber * ps = [NSNumber numberWithInt:symbol];
    NSNumber * cword = [NSNumber numberWithInt:currentWord];
    
    for (unsigned int i = 0; i< [keys count]; i++) {
        
        NSNumber * pos = [keys objectAtIndex:i];
        
        //do we have the position registered?
        if ([pos intValue] == currentWord) {
            
            //just remove the entry
            [suggestedSymbolPositions removeObjectForKey:pos];
            
            if (symbol != no_symbol)
                [suggestedSymbolPositions setObject:ps forKey:pos];

            return;
        }
    }
    
    //New entry add to list
    [suggestedSymbolPositions setObject:ps forKey:cword];
    
}

-(void) addWordClassFromString: (NSString *) positions : (grammarSymbolType) wct
{
    //Need to extract the positions from the string first and add them
    
    NSArray *listItems = [positions componentsSeparatedByString:@","];
    
    for (unsigned int n=0;n < [listItems count];n++) {
        
        NSString * str = [listItems objectAtIndex:n];
        
        if ( [str length] >0 ) {
            int pos = [ [listItems objectAtIndex:n] intValue] - 1;
            
            //Adding the position to the wordClasses
            [self addWordClass:pos :wct];
        }
        
    }
}

-(void) addCommaFromString: (NSString *) positions
{
    //Need to extract the positions from the string first and add them
    
    NSArray *listItems = [positions componentsSeparatedByString:@","];
    
    for (unsigned int n=0;n < [listItems count];n++) {
        
        int pos = [ [listItems objectAtIndex:n] intValue] - 1;
        
        //Adding the position to the wordClasses
        if (pos>=0)
            [self addComma:pos];
    }
}

-(void) addComma: (int) position
{
    NSNumber * pos = [NSNumber numberWithInt:position];
    
    [kommaPositions addObject:pos];
}

@end
